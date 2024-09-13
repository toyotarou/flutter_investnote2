import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
import '../../enum/invest_kind.dart';
import '../../enum/shintaku_frame.dart';
import '../../enum/stock_frame.dart';
import '../../extensions/extensions.dart';
import '../../repository/invest_names_repository.dart';
import '../../repository/invest_records_repository.dart';
import '../../state/invest_names/invest_names_notifier.dart';
import '../../state/invest_names/invest_names_response_state.dart';
import '../../utilities/functions.dart';
import 'parts/error_dialog.dart';

// ignore: must_be_immutable
class InvestNameInputAlert extends ConsumerStatefulWidget {
  InvestNameInputAlert(
      {super.key,
      required this.isar,
      this.investName,
      required this.investKind});

  final Isar isar;
  InvestName? investName;
  final InvestKind investKind;

  ///
  @override
  ConsumerState<InvestNameInputAlert> createState() =>
      _InvestNameInputAlertState();
}

class _InvestNameInputAlertState extends ConsumerState<InvestNameInputAlert> {
  final TextEditingController _investNumberEditingController =
      TextEditingController();

  final TextEditingController _investNameEditingController =
      TextEditingController();

  StockFrame _selectedStockFrame = StockFrame.blank;
  ShintakuFrame _selectedShintakuFrame = ShintakuFrame.blank;

  ///
  @override
  void initState() {
    super.initState();

    if (widget.investName != null) {
      _investNumberEditingController.text =
          widget.investName!.dealNumber.toString();

      _investNameEditingController.text = widget.investName!.name;

      if (widget.investKind == InvestKind.stock) {
        switch (widget.investName!.frame) {
          case '一般口座':
            _selectedStockFrame = StockFrame.general;
          case '特定口座':
            _selectedStockFrame = StockFrame.specific;
        }
      } else if (widget.investKind == InvestKind.shintaku) {
        switch (widget.investName!.frame) {
          case '特定口座':
            _selectedShintakuFrame = ShintakuFrame.specific;
          case 'NISAつみたて投資枠':
            _selectedShintakuFrame = ShintakuFrame.nisaAccumulated;
          case 'NISA成長投資枠':
            _selectedShintakuFrame = ShintakuFrame.nisaGrowth;
          case 'つみたてNISA':
            _selectedShintakuFrame = ShintakuFrame.nisaFreshly;
        }
      }
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              const Text('株式名称追加'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              _displayInputParts(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(),
                  if (widget.investName != null)
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (widget.investKind == InvestKind.stock) {
                              switch (widget.investName!.frame) {
                                case '一般口座':
                                  ref
                                      .read(investNamesProvider.notifier)
                                      .setStockFrame(
                                          stockFrame: StockFrame.general);
                                case '特定口座':
                                  ref
                                      .read(investNamesProvider.notifier)
                                      .setStockFrame(
                                          stockFrame: StockFrame.specific);
                              }
                            } else if (widget.investKind ==
                                InvestKind.shintaku) {
                              switch (widget.investName!.frame) {
                                case '特定口座':
                                  ref
                                      .read(investNamesProvider.notifier)
                                      .setShintakuFrame(
                                          shintakuFrame:
                                              ShintakuFrame.specific);
                                case 'NISAつみたて投資枠':
                                  ref
                                      .read(investNamesProvider.notifier)
                                      .setShintakuFrame(
                                          shintakuFrame:
                                              ShintakuFrame.nisaAccumulated);
                                case 'NISA成長投資枠':
                                  ref
                                      .read(investNamesProvider.notifier)
                                      .setShintakuFrame(
                                          shintakuFrame:
                                              ShintakuFrame.nisaGrowth);
                                case 'つみたてNISA':
                                  ref
                                      .read(investNamesProvider.notifier)
                                      .setShintakuFrame(
                                          shintakuFrame:
                                              ShintakuFrame.nisaFreshly);
                              }
                            }

                            _updateInvestName();
                          },
                          child: Text('${widget.investKind.japanName}名称を更新する',
                              style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _showDeleteDialog,
                          child: Text('${widget.investKind.japanName}名称を削除する',
                              style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                        ),
                      ],
                    )
                  else
                    TextButton(
                      onPressed: _inputInvestName,
                      child: Text('${widget.investKind.japanName}名称を追加する',
                          style: const TextStyle(fontSize: 12)),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayInputParts() {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              blurRadius: 24,
              spreadRadius: 16,
              color: Colors.black.withOpacity(0.2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            width: context.screenSize.width,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _investNumberEditingController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          hintText: '管理番号',
                          filled: true,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white54)),
                        ),
                        style:
                            const TextStyle(fontSize: 13, color: Colors.white),
                        onTapOutside: (PointerDownEvent event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: context.screenSize.width * 0.5,
                      child: const Text('(10文字以内)'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                getDropdownButton(),
                const SizedBox(height: 10),
                TextField(
                  controller: _investNameEditingController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintText: '${widget.investKind.japanName}名称(50文字以内)',
                    filled: true,
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54)),
                  ),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  onTapOutside: (PointerDownEvent event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget getDropdownButton() {
    final InvestNamesResponseState investNamesState =
        ref.watch(investNamesProvider);

    switch (widget.investKind) {
      case InvestKind.stock:
        // ignore: always_specify_types
        return DropdownButton(
          isExpanded: true,
          dropdownColor: Colors.pinkAccent.withOpacity(0.1),
          iconEnabledColor: Colors.white,
          items: StockFrame.values.map((StockFrame e) {
            // ignore: always_specify_types
            return DropdownMenuItem(
              value: e,
              child: Text(e.japanName, style: const TextStyle(fontSize: 12)),
            );
          }).toList(),
          value: (_selectedStockFrame != StockFrame.blank)
              ? _selectedStockFrame
              : investNamesState.stockFrame,
          onChanged: (StockFrame? value) {
            ref
                .read(investNamesProvider.notifier)
                .setStockFrame(stockFrame: value!);
          },
        );
      case InvestKind.shintaku:
        // ignore: always_specify_types
        return DropdownButton(
          isExpanded: true,
          dropdownColor: Colors.pinkAccent.withOpacity(0.1),
          iconEnabledColor: Colors.white,
          items: ShintakuFrame.values.map((ShintakuFrame e) {
            // ignore: always_specify_types
            return DropdownMenuItem(
              value: e,
              child: Text(e.japanName, style: const TextStyle(fontSize: 12)),
            );
          }).toList(),
          value: (_selectedShintakuFrame != ShintakuFrame.blank)
              ? _selectedShintakuFrame
              : investNamesState.shintakuFrame,
          onChanged: (ShintakuFrame? value) {
            ref
                .read(investNamesProvider.notifier)
                .setShintakuFrame(shintakuFrame: value!);
          },
        );

      case InvestKind.blank:
      case InvestKind.gold:
        return Container();
    }
  }

  ///
  Future<void> _inputInvestName() async {
    bool errFlg = false;

    if (_investNumberEditingController.text.trim() == '' ||
        _investNameEditingController.text.trim() == '') {
      errFlg = true;
    }

    if (!errFlg) {
      for (final List<Object> element in <List<Object>>[
        <Object>[_investNumberEditingController.text.trim(), 10],
        <Object>[_investNameEditingController.text.trim(), 50]
      ]) {
        if (!checkInputValueLengthCheck(
            value: element[0].toString(), length: element[1] as int)) {
          errFlg = true;
        }
      }
    }

    if (!errFlg) {
      if (int.tryParse(_investNumberEditingController.text) == null) {
        errFlg = true;
      }
    }

    if (errFlg) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () {
          if (mounted) {
            return error_dialog(
                context: context, title: '登録できません。', content: '値を正しく入力してください。');
          }
        },
      );

      return;
    }

    final InvestNamesResponseState investNamesState =
        ref.watch(investNamesProvider);

    String frame = '';

    switch (widget.investKind) {
      case InvestKind.stock:
        frame = investNamesState.stockFrame.japanName;

      case InvestKind.shintaku:
        frame = investNamesState.shintakuFrame.japanName;

      case InvestKind.blank:
      case InvestKind.gold:
        break;
    }

    final InvestName investName = InvestName()
      ..frame = frame
      ..dealNumber = _investNumberEditingController.text.trim().toInt()
      ..name = _investNameEditingController.text.trim()
      ..kind = widget.investKind.name;

    await InvestNamesRepository()
        .inputInvestName(isar: widget.isar, investName: investName)
        // ignore: always_specify_types
        .then((value) {
      _investNumberEditingController.clear();
      _investNameEditingController.clear();

      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  ///
  Future<void> _updateInvestName() async {
    final StockFrame stockFrame = ref.watch(investNamesProvider
        .select((InvestNamesResponseState value) => value.stockFrame));
    final ShintakuFrame shintakuFrame = ref.watch(investNamesProvider
        .select((InvestNamesResponseState value) => value.shintakuFrame));

    bool errFlg = false;

    switch (widget.investKind) {
      case InvestKind.stock:
        if (_investNumberEditingController.text.trim() == '' ||
            _investNameEditingController.text.trim() == '' ||
            (stockFrame == StockFrame.blank)) {
          errFlg = true;
        }
      case InvestKind.shintaku:
        if (_investNumberEditingController.text.trim() == '' ||
            _investNameEditingController.text.trim() == '' ||
            (shintakuFrame == ShintakuFrame.blank)) {
          errFlg = true;
        }

      case InvestKind.gold:
      case InvestKind.blank:
        break;
    }

    if (!errFlg) {
      for (final List<Object> element in <List<Object>>[
        <Object>[_investNumberEditingController.text.trim(), 10],
        <Object>[_investNameEditingController.text.trim(), 50]
      ]) {
        if (!checkInputValueLengthCheck(
            value: element[0].toString(), length: element[1] as int)) {
          errFlg = true;
        }
      }
    }

    if (!errFlg) {
      if (int.tryParse(_investNumberEditingController.text) == null) {
        errFlg = true;
      }
    }

    if (errFlg) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () {
          if (mounted) {
            return error_dialog(
                context: context, title: '登録できません。', content: '値を正しく入力してください。');
          }
        },
      );

      return;
    }

    String frame = '';

    switch (widget.investKind) {
      case InvestKind.stock:
        frame = stockFrame.japanName;

      case InvestKind.shintaku:
        frame = shintakuFrame.japanName;

      case InvestKind.blank:
      case InvestKind.gold:
        break;
    }

    await widget.isar.writeTxn(() async {
      await InvestNamesRepository()
          .getInvestName(isar: widget.isar, id: widget.investName!.id)
          .then((InvestName? value) async {
        value!
          ..dealNumber = _investNumberEditingController.text.trim().toInt()
          ..name = _investNameEditingController.text.trim()
          ..frame = frame;

        await InvestNamesRepository()
            .updateInvestName(isar: widget.isar, investName: value)
            // ignore: always_specify_types
            .then((value) {
          _investNumberEditingController.clear();
          _investNameEditingController.clear();

          if (mounted) {
            Navigator.pop(context);
          }
        });
      });
    });
  }

  ///
  void _showDeleteDialog() {
    final Widget cancelButton = TextButton(
        onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
        onPressed: () {
          _deleteInvestName();

          Navigator.pop(context);
        },
        child: const Text('はい'));

    final AlertDialog alert = AlertDialog(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      content: const Text('このデータを消去しますか？'),
      actions: <Widget>[cancelButton, continueButton],
    );

    // ignore: inference_failure_on_function_invocation
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  ///
  Future<void> _deleteInvestName() async => InvestRecordsRepository()
      .getInvestRecordListByInvestId(
          isar: widget.isar, investId: widget.investName!.id)
      .then((List<InvestRecord>? value) async => InvestRecordsRepository()
          .deleteInvestRecordList(isar: widget.isar, investRecordList: value)
          // ignore: always_specify_types
          .then((value2) async => InvestNamesRepository()
                  .deleteInvestName(
                      isar: widget.isar, id: widget.investName!.id)
                  // ignore: always_specify_types
                  .then((value3) {
                if (mounted) {
                  Navigator.pop(context);
                }
              })));
}
