import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../collections/invest_name.dart';
import '../../enum/invest_kind.dart';
import '../../extensions/extensions.dart';
import '../../repository/invest_names_repository.dart';
import 'invest_name_input_alert.dart';
import 'parts/invest_dialog.dart';

class InvestNameListAlert extends StatefulWidget {
  const InvestNameListAlert({super.key, required this.isar, required this.investKind});

  final Isar isar;
  final InvestKind investKind;

  ///
  @override
  State<InvestNameListAlert> createState() => _InvestNameListAlertState();
}

class _InvestNameListAlertState extends State<InvestNameListAlert> {
  List<InvestName>? investNameList = [];

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
              Text('${widget.investKind.japanName}名称一覧'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  TextButton(
                    onPressed: () => InvestDialog(
                      context: context,
                      widget: InvestNameInputAlert(isar: widget.isar, investKind: widget.investKind),
                      clearBarrierColor: true,
                    ),
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
  Future<void> _makeStockNameList() async => InvestNamesRepository()
      .getInvestNameListByInvestKind(isar: widget.isar, investKind: widget.investKind.name)
      .then((value) => setState(() => investNameList = value));

  ///
  Widget _displayStockNames() {
    final list = <Widget>[];

    investNameList?.forEach((element) {
      list.add(Container(
        width: context.screenSize.width,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.2), width: 2))),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(element.frame), Text(element.name)],
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () => InvestDialog(
                context: context,
                widget: InvestNameInputAlert(isar: widget.isar, investName: element, investKind: widget.investKind),
                clearBarrierColor: true,
              ),
              child: Icon(Icons.edit, size: 16, color: Colors.greenAccent.withOpacity(0.6)),
            ),
          ],
        ),
      ));
    });

    return SingleChildScrollView(child: Column(children: list));
  }
}
