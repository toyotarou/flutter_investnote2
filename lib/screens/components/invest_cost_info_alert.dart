import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
import '../../enum/invest_kind.dart';
import '../../extensions/extensions.dart';

class CostRecord {
  CostRecord({required this.date, required this.cost});

  String date;
  int cost;
}

class InvestCostInfoAlert extends ConsumerStatefulWidget {
  const InvestCostInfoAlert({
    super.key,
    required this.yearmonth,
    required this.cost,
    required this.investItemRecordMap,
    required this.investNameList,
  });

  final String yearmonth;
  final int cost;
  final Map<int, List<InvestRecord>> investItemRecordMap;
  final List<InvestName> investNameList;

  @override
  ConsumerState<InvestCostInfoAlert> createState() => _InvestCostInfoAlertState();
}

class _InvestCostInfoAlertState extends ConsumerState<InvestCostInfoAlert> {
  Map<int, List<CostRecord>> costRecordListMap = <int, List<CostRecord>>{};

  ///
  @override
  Widget build(BuildContext context) {
    makeCostRecordListMap();

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(widget.yearmonth),
                  Text(widget.cost.toString()),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(child: _displayInvestCostInfoList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void makeCostRecordListMap() {
    for (final InvestName element in widget.investNameList) {
      if (element.kind == InvestKind.shintaku.name) {
        costRecordListMap[element.relationalId] = <CostRecord>[];
      }
    }

    for (final InvestName element in widget.investNameList) {
      if (element.kind == InvestKind.shintaku.name) {
        int keepCost = 0;
        widget.investItemRecordMap[element.relationalId]?.forEach((InvestRecord element2) {
          if (keepCost > 0 && keepCost != element2.cost) {
            costRecordListMap[element.relationalId]
                ?.add(CostRecord(date: element2.date, cost: element2.cost - keepCost));
          }

          keepCost = element2.cost;
        });
      }
    }
  }

  ///
  Widget _displayInvestCostInfoList() {
    final List<Widget> list = <Widget>[];

    costRecordListMap.forEach((int key, List<CostRecord> value) {
      if (value.isNotEmpty) {
        list.add(Text(key.toString()));

        final List<Widget> list2 = <Widget>[];

        for (final CostRecord element in value) {
          list2.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(element.date),
              Text(element.cost.toString()),
            ],
          ));
        }

        list.add(Column(children: list2));
      }
    });

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) => list[index], childCount: list.length),
        ),
      ],
    );
  }
}
