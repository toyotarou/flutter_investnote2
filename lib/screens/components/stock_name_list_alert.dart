import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../collections/stock_name.dart';
import '../../extensions/extensions.dart';
import '../../repository/stock_names_repository.dart';
import 'parts/invest_dialog.dart';
import 'stock_name_input_alert.dart';

class StockNameListAlert extends StatefulWidget {
  const StockNameListAlert({super.key, required this.isar});

  final Isar isar;

  ///
  @override
  State<StockNameListAlert> createState() => _StockNameListAlertState();
}

class _StockNameListAlertState extends State<StockNameListAlert> {
  List<StockName>? stockNameList = [];

  ///
  @override
  Widget build(BuildContext context) {
    _makeStockNameList();

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
                    onPressed: () => InvestDialog(context: context, widget: StockNameInputAlert(isar: widget.isar)),
                    child: const Text('株式名称を追加する', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              Expanded(child: _displayStockNames()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _makeStockNameList() async =>
      StockNamesRepository().getStockNameList(isar: widget.isar).then((value) => setState(() => stockNameList = value));

  ///
  Widget _displayStockNames() {
    final list = <Widget>[];

    stockNameList?.forEach((element) {
      list.add(Container(
        width: context.screenSize.width,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.2), width: 2))),
        child: Row(
          children: [
            SizedBox(width: 80, child: Text(element.frame)),
            Expanded(child: Text(element.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
            GestureDetector(
              onTap: () => InvestDialog(context: context, widget: StockNameInputAlert(isar: widget.isar, stockName: element)),
              child: Icon(Icons.edit, size: 16, color: Colors.greenAccent.withOpacity(0.6)),
            ),
          ],
        ),
      ));
    });

    return SingleChildScrollView(child: Column(children: list));
  }
}
