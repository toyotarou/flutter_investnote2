import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:invest_note/repository/invest_records_repository.dart';
import 'package:isar/isar.dart';

import '../../collections/invest_name.dart';
import '../../enum/invest_kind.dart';
import '../../enum/shintaku_frame.dart';
import '../../enum/stock_frame.dart';
import '../../extensions/extensions.dart';
import '../../repository/invest_names_repository.dart';
import '../../state/invest_names/invest_names_notifier.dart';
import '../../utilities/functions.dart';
import 'parts/error_dialog.dart';

// ignore: must_be_immutable
class InvestNameInputAlert extends ConsumerStatefulWidget {
  InvestNameInputAlert({super.key, required this.isar, this.investName, required this.investKind});

  final Isar isar;
  InvestName? investName;
  final InvestKind investKind;

  ///
  @override
  ConsumerState<InvestNameInputAlert> createState() => _InvestNameInputAlertState();
}

class _InvestNameInputAlertState extends ConsumerState<InvestNameInputAlert> {
  final TextEditingController _investNameEditingController = TextEditingController();

  StockFrame _selectedStockFrame = StockFrame.blank;
  ShintakuFrame _selectedShintakuFrame = ShintakuFrame.blank;

  ///
  @override
  void initState() {
    super.initState();

    if (widget.investName != null) {
      _investNameEditingController.text = widget.investName!.name;

      if (widget.investKind == InvestKind.stock) {
        switch (widget.investName!.frame) {
          case '一般口座':
            _selectedStockFrame = StockFrame.general;
            break;
          case '特定口座':
            _selectedStockFrame = StockFrame.specific;
            break;
        }
      } else if (widget.investKind == InvestKind.shintaku) {
        switch (widget.investName!.frame) {
          case '特定口座':
            _selectedShintakuFrame = ShintakuFrame.specific;
            break;
          case 'NISAつみたて投資枠':
            _selectedShintakuFrame = ShintakuFrame.nisaAccumulated;
            break;
          case 'NISA成長投資枠':
            _selectedShintakuFrame = ShintakuFrame.nisaGrowth;
            break;
          case 'つみたてNISA':
            _selectedShintakuFrame = ShintakuFrame.nisaFreshly;
            break;
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
            children: [
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              const Text('株式名称追加'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              _displayInputParts(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  (widget.investName != null)
                      ? Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (widget.investKind == InvestKind.stock) {
                                  switch (widget.investName!.frame) {
                                    case '一般口座':
                                      ref.read(investNamesProvider.notifier).setStockFrame(stockFrame: StockFrame.general);
                                      break;
                                    case '特定口座':
                                      ref.read(investNamesProvider.notifier).setStockFrame(stockFrame: StockFrame.specific);
                                      break;
                                  }
                                } else if (widget.investKind == InvestKind.shintaku) {
                                  switch (widget.investName!.frame) {
                                    case '特定口座':
                                      ref.read(investNamesProvider.notifier).setShintakuFrame(shintakuFrame: ShintakuFrame.specific);
                                      break;
                                    case 'NISAつみたて投資枠':
                                      ref.read(investNamesProvider.notifier).setShintakuFrame(shintakuFrame: ShintakuFrame.nisaAccumulated);
                                      break;
                                    case 'NISA成長投資枠':
                                      ref.read(investNamesProvider.notifier).setShintakuFrame(shintakuFrame: ShintakuFrame.nisaGrowth);
                                      break;
                                    case 'つみたてNISA':
                                      ref.read(investNamesProvider.notifier).setShintakuFrame(shintakuFrame: ShintakuFrame.nisaFreshly);
                                      break;
                                  }
                                }

                                _updateInvestName();
                              },
                              child: Text('${widget.investKind.japanName}名称を更新する',
                                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: _showDeleteDialog,
                              child: Text('${widget.investKind.japanName}名称を削除する',
                                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                            ),
                          ],
                        )
                      : TextButton(
                          onPressed: _inputInvestName,
                          child: Text('${widget.investKind.japanName}名称を追加する', style: const TextStyle(fontSize: 12)),
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
        boxShadow: [
          BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2)),
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
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Column(
              children: [
                getDropdownButton(),
                TextField(
                  controller: _investNameEditingController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintText: '${widget.investKind.japanName}名称(50文字以内)',
                    filled: true,
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  ),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
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
    final investNamesState = ref.watch(investNamesProvider);

    switch (widget.investKind) {
      case InvestKind.stock:
        return DropdownButton(
          isExpanded: true,
          dropdownColor: Colors.pinkAccent.withOpacity(0.1),
          iconEnabledColor: Colors.white,
          items: StockFrame.values.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e.japanName, style: const TextStyle(fontSize: 12)),
            );
          }).toList(),
          value: (_selectedStockFrame != StockFrame.blank) ? _selectedStockFrame : investNamesState.stockFrame,
          onChanged: (value) {
            ref.read(investNamesProvider.notifier).setStockFrame(stockFrame: value!);
          },
        );
      case InvestKind.shintaku:
        return DropdownButton(
          isExpanded: true,
          dropdownColor: Colors.pinkAccent.withOpacity(0.1),
          iconEnabledColor: Colors.white,
          items: ShintakuFrame.values.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e.japanName, style: const TextStyle(fontSize: 12)),
            );
          }).toList(),
          value: (_selectedShintakuFrame != ShintakuFrame.blank) ? _selectedShintakuFrame : investNamesState.shintakuFrame,
          onChanged: (value) {
            ref.read(investNamesProvider.notifier).setShintakuFrame(shintakuFrame: value!);
          },
        );

      case InvestKind.blank:
      case InvestKind.gold:
        return Container();
    }
  }

  ///
  Future<void> _inputInvestName() async {
    var errFlg = false;

    if (_investNameEditingController.text == '') {
      errFlg = true;
    }

    if (errFlg == false) {
      [
        [_investNameEditingController.text, 50]
      ].forEach((element) {
        if (checkInputValueLengthCheck(value: element[0].toString(), length: element[1] as int) == false) {
          errFlg = true;
        }
      });
    }

    if (errFlg) {
      Future.delayed(
        Duration.zero,
        () => error_dialog(context: context, title: '登録できません。', content: '値を正しく入力してください。'),
      );

      return;
    }

    final investNamesState = ref.watch(investNamesProvider);

    var frame = '';

    switch (widget.investKind) {
      case InvestKind.stock:
        frame = investNamesState.stockFrame.japanName;
        break;

      case InvestKind.shintaku:
        frame = investNamesState.shintakuFrame.japanName;
        break;

      case InvestKind.blank:
      case InvestKind.gold:
        break;
    }

    final investName = InvestName()
      ..frame = frame
      ..name = _investNameEditingController.text
      ..kind = widget.investKind.name;

    await InvestNamesRepository().inputInvestName(isar: widget.isar, investName: investName).then((value) {
      _investNameEditingController.clear();

      Navigator.pop(context);
    });
  }

  ///
  Future<void> _updateInvestName() async {
    final stockFrame = ref.watch(investNamesProvider.select((value) => value.stockFrame));
    final shintakuFrame = ref.watch(investNamesProvider.select((value) => value.shintakuFrame));

    var errFlg = false;

    if (_investNameEditingController.text == '' || (stockFrame == StockFrame.blank) || (shintakuFrame == ShintakuFrame.blank)) {
      errFlg = true;
    }

    if (errFlg == false) {
      [
        [_investNameEditingController.text, 30]
      ].forEach((element) {
        if (checkInputValueLengthCheck(value: element[0].toString(), length: element[1] as int) == false) {
          errFlg = true;
        }
      });
    }

    if (errFlg) {
      Future.delayed(
        Duration.zero,
        () => error_dialog(context: context, title: '登録できません。', content: '値を正しく入力してください。'),
      );

      return;
    }

    var frame = '';

    switch (widget.investKind) {
      case InvestKind.stock:
        frame = stockFrame.japanName;
        break;

      case InvestKind.shintaku:
        frame = shintakuFrame.japanName;
        break;

      case InvestKind.blank:
      case InvestKind.gold:
        break;
    }

    await widget.isar.writeTxn(() async {
      await InvestNamesRepository().getInvestName(isar: widget.isar, id: widget.investName!.id).then((value) async {
        value!
          ..name = _investNameEditingController.text
          ..frame = frame;

        await InvestNamesRepository().updateInvestName(isar: widget.isar, investName: value).then((value) {
          _investNameEditingController.clear();

          Navigator.pop(context);
        });
      });
    });
  }

  ///
  void _showDeleteDialog() {
    final Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
        onPressed: () {
          _deleteInvestName();

          Navigator.pop(context);
        },
        child: const Text('はい'));

    final alert = AlertDialog(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      content: const Text('このデータを消去しますか？'),
      actions: [cancelButton, continueButton],
    );

    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  ///
  Future<void> _deleteInvestName() async => InvestRecordsRepository()
      .getInvestRecordListByInvestId(isar: widget.isar, investId: widget.investName!.id)
      .then((value) async => InvestRecordsRepository().deleteInvestRecordList(isar: widget.isar, investRecordList: value).then((value2) async =>
          InvestNamesRepository().deleteInvestName(isar: widget.isar, id: widget.investName!.id).then((value3) => Navigator.pop(context))));
}
