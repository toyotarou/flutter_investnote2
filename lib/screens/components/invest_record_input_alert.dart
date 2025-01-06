import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
import '../../enum/invest_kind.dart';
import '../../extensions/extensions.dart';
import '../../repository/invest_records_repository.dart';
import '../../utilities/functions.dart';
import 'parts/error_dialog.dart';

// ignore: must_be_immutable
class InvestRecordInputAlert extends StatefulWidget {
  const InvestRecordInputAlert(
      {super.key,
      required this.isar,
      required this.date,
      required this.investName,
      this.investRecord,
      required this.allInvestRecord});

  final Isar isar;
  final DateTime date;
  final InvestName investName;
  final List<InvestRecord>? investRecord;
  final List<InvestRecord> allInvestRecord;

  ///
  @override
  State<InvestRecordInputAlert> createState() => _InvestRecordInputAlertState();
}

class _InvestRecordInputAlertState extends State<InvestRecordInputAlert> {
  final TextEditingController _costEditingController = TextEditingController();
  final TextEditingController _priceEditingController = TextEditingController();

  ///
  @override
  void initState() {
    super.initState();

    if (widget.investRecord!.isNotEmpty) {
      _costEditingController.text = widget.investRecord![0].cost.toString();
      _priceEditingController.text = widget.investRecord![0].price.toString();
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
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[Text(widget.date.yyyymmdd), Text(widget.investName.name)]),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              _displayInputParts(),
              if (widget.investName.kind == InvestKind.stock.name ||
                  widget.investName.kind == InvestKind.shintaku.name) ...<Widget>[
                ElevatedButton(
                  onPressed: getLastCost,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                  child: const Text('get last cost'),
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(),
                  if (widget.investRecord!.isNotEmpty)
                    TextButton(
                        onPressed: _updateInvestRecord,
                        child: const Text('投資詳細レコードを更新する', style: TextStyle(fontSize: 12)))
                  else
                    TextButton(
                        onPressed: _inputInvestRecord,
                        child: const Text('投資詳細レコードを追加する', style: TextStyle(fontSize: 12))),
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
          boxShadow: <BoxShadow>[BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2))]),
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
              children: <Widget>[
                TextField(
                  controller: _costEditingController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintText: '取得総額(10桁以内)',
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  ),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _priceEditingController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintText: '時価評価額(10桁以内)',
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  ),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _inputInvestRecord() async {
    bool errFlg = false;

    if (_costEditingController.text.trim() == '' || _priceEditingController.text.trim() == '') {
      errFlg = true;
    }

    if (!errFlg) {
      for (final List<Object> element in <List<Object>>[
        <Object>[_costEditingController.text.trim(), 30],
        <Object>[_priceEditingController.text.trim(), 10]
      ]) {
        if (!checkInputValueLengthCheck(value: element[0].toString(), length: element[1] as int)) {
          errFlg = true;
        }
      }
    }

    if (errFlg) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () {
          if (mounted) {
            return error_dialog(context: context, title: '登録できません。', content: '値を正しく入力してください。');
          }
        },
      );

      return;
    }

    final InvestRecord investRecord = InvestRecord()
      ..date = widget.date.yyyymmdd
      ..investId = (widget.investName.kind == 'gold') ? 0 : widget.investName.relationalId
      ..cost = _costEditingController.text.replaceAll(',', '').trim().toInt()
      ..price = _priceEditingController.text.replaceAll(',', '').trim().toInt();

    await InvestRecordsRepository()
        .inputInvestRecord(isar: widget.isar, investRecord: investRecord)
        // ignore: always_specify_types
        .then((value) {
      _costEditingController.clear();
      _priceEditingController.clear();

      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  ///
  Future<void> _updateInvestRecord() async {
    bool errFlg = false;

    if (_costEditingController.text.trim() == '' || _priceEditingController.text.trim() == '') {
      errFlg = true;
    }

    if (!errFlg) {
      for (final List<Object> element in <List<Object>>[
        <Object>[_costEditingController.text.trim(), 30],
        <Object>[_priceEditingController.text.trim(), 10]
      ]) {
        if (!checkInputValueLengthCheck(value: element[0].toString(), length: element[1] as int)) {
          errFlg = true;
        }
      }
    }

    if (errFlg) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () {
          if (mounted) {
            return error_dialog(context: context, title: '登録できません。', content: '値を正しく入力してください。');
          }
        },
      );

      return;
    }

    await widget.isar.writeTxn(() async {
      await InvestRecordsRepository()
          .getInvestRecord(isar: widget.isar, id: widget.investRecord![0].id)
          .then((InvestRecord? value) async {
        value!
          ..date = widget.date.yyyymmdd
          ..investId = (widget.investName.kind == InvestKind.gold.name) ? 0 : widget.investName.relationalId
          ..cost = _costEditingController.text.replaceAll(',', '').trim().toInt()
          ..price = _priceEditingController.text.replaceAll(',', '').trim().toInt();

        await InvestRecordsRepository()
            .updateInvestRecord(isar: widget.isar, investRecord: value)
            // ignore: always_specify_types
            .then((value) {
          _costEditingController.clear();
          _priceEditingController.clear();

          if (mounted) {
            Navigator.pop(context);
          }
        });
      });
    });
  }

  ///
  void getLastCost() {
    final List<String> dateList = <String>[];

    final List<String> yearList = <String>[];
    for (final InvestRecord element in widget.allInvestRecord) {
      final List<String> exDate = element.date.split('-');

      if (!yearList.contains(exDate[0])) {
        yearList.add(exDate[0]);
      }
    }

    final int roopNum = (yearList.contains(DateTime.now().year.toString())) ? 10 : 30;

    for (int i = 1; i < roopNum; i++) {
      final DateTime day = widget.date.add(Duration(days: i * -1));

      dateList.add(day.yyyymmdd);
    }

    int cost = 0;

    for (final String element3 in dateList) {
      widget.allInvestRecord
          .where((InvestRecord element) => element.investId == widget.investName.relationalId)
          .forEach((InvestRecord element2) {
        if (cost == 0) {
          if (element3 == element2.date) {
            cost = element2.cost;
          }
        }
      });
    }

    _costEditingController.text = cost.toString().trim();
  }
}
