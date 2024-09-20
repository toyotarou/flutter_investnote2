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
  const InvestNameListAlert({
    super.key,
    required this.isar,
    required this.investKind,
    required this.investNameList,
  });

  final Isar isar;
  final InvestKind investKind;
  final List<InvestName> investNameList;

  ///
  @override
  State<InvestNameListAlert> createState() => _InvestNameListAlertState();
}

class _InvestNameListAlertState extends State<InvestNameListAlert> {
  List<InvestName>? investNameList = <InvestName>[];

  ///
  @override
  Widget build(BuildContext context) {
    _makeStockNameList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              Text('${widget.investKind.japanName}名称一覧'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(),
                  TextButton(
                    onPressed: () => InvestDialog(
                      context: context,
                      widget: InvestNameInputAlert(
                        isar: widget.isar,
                        investKind: widget.investKind,
                        investNameList: widget.investNameList,
                      ),
                      clearBarrierColor: true,
                    ),
                    child: Text(
                      getInvestName(),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
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
  String getInvestName() {
    switch (widget.investKind) {
      case InvestKind.stock:
        return '株式名称を追加する';
      case InvestKind.shintaku:
        return '信託名称を追加する';
      case InvestKind.blank:
      case InvestKind.gold:
    }
    return '';
  }

  ///
  Future<void> _makeStockNameList() async => InvestNamesRepository()
      .getInvestNameListByInvestKind(
          isar: widget.isar, investKind: widget.investKind.name)
      .then(
          (List<InvestName>? value) => setState(() => investNameList = value));

  ///
  Widget _displayStockNames() {
    final List<Widget> list = <Widget>[];

    investNameList?.forEach((InvestName element) {
      list.add(Container(
        width: context.screenSize.width,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Colors.white.withOpacity(0.2), width: 2))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 30,
              child: Text(element.dealNumber.toString()),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[Text(element.frame), Text(element.name)],
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () => InvestDialog(
                context: context,
                widget: InvestNameInputAlert(
                  isar: widget.isar,
                  investName: element,
                  investKind: widget.investKind,
                  investNameList: widget.investNameList,
                ),
                clearBarrierColor: true,
              ),
              child: Icon(Icons.edit,
                  size: 16, color: Colors.greenAccent.withOpacity(0.6)),
            ),
          ],
        ),
      ));
    });

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => list[index],
            childCount: list.length,
          ),
        ),
      ],
    );
  }
}
