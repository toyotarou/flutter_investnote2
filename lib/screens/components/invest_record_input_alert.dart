import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
import '../../extensions/extensions.dart';
import '../../repository/invest_records_repository.dart';
import '../../utilities/functions.dart';
import 'parts/error_dialog.dart';

// ignore: must_be_immutable
class InvestRecordInputParts extends StatefulWidget {
  InvestRecordInputParts({super.key, required this.isar, required this.date, required this.investName, this.investRecord});

  final Isar isar;
  final DateTime date;
  final InvestName investName;
  InvestRecord? investRecord;

  ///
  @override
  State<InvestRecordInputParts> createState() => _InvestRecordInputPartsState();
}

class _InvestRecordInputPartsState extends State<InvestRecordInputParts> {
  final TextEditingController _unitEditingController = TextEditingController();
  final TextEditingController _costEditingController = TextEditingController();
  final TextEditingController _priceEditingController = TextEditingController();

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
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.date.yyyymmdd), Text(widget.investName.name)]),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              _displayInputParts(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  (widget.investRecord != null)
                      ? Column(
                          children: [
                            GestureDetector(
                              onTap: _updateInvestRecord,
                              child: Text('投資詳細レコードを更新する', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                            ),
                          ],
                        )
                      : TextButton(
                          onPressed: _inputInvestRecord,
                          child: const Text('投資詳細レコードを追加する', style: TextStyle(fontSize: 12)),
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
                TextField(
                  controller: _unitEditingController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintText: '数量(30文字以内)',
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  ),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                ),
                const SizedBox(height: 10),
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
                  onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
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
  Future<void> _inputInvestRecord() async {
    var errFlg = false;

    if (_unitEditingController.text == '' || _costEditingController.text == '' || _priceEditingController.text == '') {
      errFlg = true;
    }

    if (errFlg == false) {
      [
        [_unitEditingController.text, 30],
        [_costEditingController.text, 30],
        [_priceEditingController.text, 10]
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

    final investRecord = InvestRecord()
      ..date = widget.date.yyyymmdd
      ..investId = widget.investName.id
      ..unit = _unitEditingController.text
      ..cost = _costEditingController.text.toInt()
      ..price = _priceEditingController.text.toInt();

    await InvestRecordsRepository().inputInvestRecord(isar: widget.isar, investRecord: investRecord).then((value) {
      _unitEditingController.clear();
      _costEditingController.clear();
      _priceEditingController.clear();

      Navigator.pop(context);
    });
  }

  ///
  Future<void> _updateInvestRecord() async {}
}
