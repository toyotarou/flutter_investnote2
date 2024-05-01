import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:invest_note/enum/stock_frame.dart';
import 'package:invest_note/state/stock_names/stock_names_notifier.dart';
import 'package:isar/isar.dart';

import '../../collections/stock.dart';
import '../../extensions/extensions.dart';
import '../../utilities/functions.dart';
import 'parts/error_dialog.dart';

// ignore: must_be_immutable
class StockNameInputAlert extends ConsumerStatefulWidget {
  StockNameInputAlert({super.key, required this.isar, this.stock});

  final Isar isar;
  Stock? stock;

  ///
  @override
  ConsumerState<StockNameInputAlert> createState() => _StockNameInputAlertState();
}

class _StockNameInputAlertState extends ConsumerState<StockNameInputAlert> {
  final TextEditingController _stockNameEditingController = TextEditingController();

  final StockFrame _selectedStockFrame = StockFrame.blank;

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
                  (widget.stock != null)
                      ? Column(
                          children: [
                            GestureDetector(
                              onTap: _updateStock,
                              child: Text('株式名称を更新する', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: _showDeleteDialog,
                              child: Text('株式名称を削除する', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                            ),
                          ],
                        )
                      : TextButton(
                          onPressed: _inputStock,
                          child: const Text('株式名称を追加する', style: TextStyle(fontSize: 12)),
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
    final stockNamesState = ref.watch(stockNamesProvider);

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
                DropdownButton(
                  isExpanded: true,
                  dropdownColor: Colors.pinkAccent.withOpacity(0.1),
                  iconEnabledColor: Colors.white,
                  items: StockFrame.values.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.japanName, style: const TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                  value: (_selectedStockFrame != StockFrame.blank) ? _selectedStockFrame : stockNamesState.stockFrame,
                  onChanged: (value) {
                    ref.read(stockNamesProvider.notifier).setStockFrame(stockFrame: value!);
                  },
                ),
                TextField(
                  controller: _stockNameEditingController,
                  decoration: const InputDecoration(labelText: '株式名称'),
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
  Future<void> _inputStock() async {
    var errFlg = false;

    if (_stockNameEditingController.text == '') {
      errFlg = true;
    }

    if (errFlg == false) {
      [
        [_stockNameEditingController.text, 30]
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

  ///
  Future<void> _updateStock() async {}

  ///
  void _showDeleteDialog() {
    final Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
        onPressed: () {
          _deleteStock();

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
  Future<void> _deleteStock() async {}
}
