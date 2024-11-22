import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
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
    required this.investRecordList,
  });

  final String yearmonth;
  final int cost;
  final Map<int, List<InvestRecord>> investItemRecordMap;
  final List<InvestName> investNameList;
  final List<InvestRecord> investRecordList;

  @override
  ConsumerState<InvestCostInfoAlert> createState() => _InvestCostInfoAlertState();
}

class _InvestCostInfoAlertState extends ConsumerState<InvestCostInfoAlert> {
  Map<int, List<CostRecord>> costRecordListMap = <int, List<CostRecord>>{};

  int sumCost = 0;

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
                  Text(widget.cost.toString().toCurrency(), style: const TextStyle(color: Colors.orangeAccent)),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(child: _displayInvestCostInfoList()),
              const SizedBox(height: 10),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(sumCost.toString().toCurrency(), style: const TextStyle(color: Colors.yellowAccent)),
                      Text((widget.cost - sumCost).toString().toCurrency(), style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void makeCostRecordListMap() {
    final InvestRecord investRecordListFirst = widget.investRecordList.first;

    for (final InvestName element in widget.investNameList) {
      costRecordListMap[element.relationalId] = <CostRecord>[];
    }

    costRecordListMap[0] = <CostRecord>[];

    for (final InvestName element in widget.investNameList) {
      int keepCost = 0;
      widget.investItemRecordMap[element.relationalId]?.forEach((InvestRecord element2) {
        if (keepCost != element2.cost) {
          if (widget.yearmonth == '${element2.date.split('-')[0]}-${element2.date.split('-')[1]}') {
            if (element2.date != investRecordListFirst.date) {
              costRecordListMap[element.relationalId]
                  ?.add(CostRecord(date: element2.date, cost: element2.cost - keepCost));
            }
          }
        }

        keepCost = element2.cost;
      });
    }

    int keepCost = 0;
    widget.investItemRecordMap[0]?.forEach((InvestRecord element2) {
      if (keepCost != element2.cost) {
        if (widget.yearmonth == '${element2.date.split('-')[0]}-${element2.date.split('-')[1]}') {
          if (element2.date != investRecordListFirst.date) {
            costRecordListMap[0]?.add(CostRecord(date: element2.date, cost: element2.cost - keepCost));
          }
        }
      }

      keepCost = element2.cost;
    });
  }

  ///
  Widget _displayInvestCostInfoList() {
    final List<Widget> list = <Widget>[];

    int sum = 0;

    costRecordListMap.forEach((int key, List<CostRecord> value) {
      if (value.isNotEmpty) {
        if (key == 0) {
          list.add(const Text('gold'));
        } else {
          final InvestName investName =
              widget.investNameList.firstWhere((InvestName element) => element.relationalId == key);

          list.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[Text(investName.frame), Text(investName.name)],
          ));
        }

        final List<Widget> list2 = <Widget>[];

        for (final CostRecord element in value) {
          list2.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(element.date),
              Text(element.cost.toString().toCurrency(), style: const TextStyle(color: Colors.yellowAccent)),
            ],
          ));

          sum += element.cost;
        }

        list.add(Column(children: list2));

        list.add(const SizedBox(height: 10));
      }
    });

    setState(() {
      sumCost = sum;
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
