import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../collections/invest_name.dart';
import '../../../extensions/extensions.dart';
import '../../../utilities/functions.dart';
import 'error_dialog.dart';

class InvestRecordInputParts extends ConsumerStatefulWidget {
  const InvestRecordInputParts({super.key, required this.isar, required this.date, required this.investName});

  final Isar isar;
  final DateTime date;
  final InvestName investName;

  ///
  @override
  ConsumerState<InvestRecordInputParts> createState() => _DailyDetailPriceInputAlertState();
}

class _DailyDetailPriceInputAlertState extends ConsumerState<InvestRecordInputParts> {
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
      content: DecoratedBox(
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: double.infinity,
              child: DefaultTextStyle(
                style: GoogleFonts.kiwiMaru(fontSize: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(width: context.screenSize.width),
                    Row(
                      children: [
                        Text(widget.investName.name, style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                    Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Text(widget.date.yyyymmdd, style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _inputInvestRecord();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                      child: const Text('input'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _inputInvestRecord() async {
/*
  final TextEditingController _unitEditingController = TextEditingController();
  final TextEditingController _costEditingController = TextEditingController();
  final TextEditingController _priceEditingController = TextEditingController();

*/

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
  }
}
