import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invest_note/screens/components/parts/invest_dialog.dart';
import 'package:invest_note/screens/components/stock_name_input_alert.dart';
import 'package:isar/isar.dart';

import '../../extensions/extensions.dart';

class StockNameListAlert extends StatefulWidget {
  const StockNameListAlert({super.key, required this.isar});

  final Isar isar;

  ///
  @override
  State<StockNameListAlert> createState() => _StockNameListAlertState();
}

class _StockNameListAlertState extends State<StockNameListAlert> {
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
              const Text('株式名称一覧'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  TextButton(
                    onPressed: () {
                      InvestDialog(
                        context: context,
                        widget: StockNameInputAlert(isar: widget.isar),
                      );
                    },
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
}
