import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
import '../../extensions/extensions.dart';

class InvestCostTotalListAlert extends ConsumerStatefulWidget {
  const InvestCostTotalListAlert(
      {super.key,
      required this.year,
      required this.investItemRecordMap,
      required this.investNameList,
      required this.investRecordList});

  final int year;
  final Map<int, List<InvestRecord>> investItemRecordMap;
  final List<InvestName> investNameList;
  final List<InvestRecord> investRecordList;

  @override
  ConsumerState<InvestCostTotalListAlert> createState() => _InvestCostTotalListAlertState();
}

class _InvestCostTotalListAlertState extends ConsumerState<InvestCostTotalListAlert> {
  Map<int, String> investNameMap = <int, String>{};

  ///
  @override
  void initState() {
    super.initState();

    for (final InvestName element in widget.investNameList) {
      investNameMap[element.relationalId] = element.name;
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('COST'),
                  Text(widget.year.toString()),
                ],
              ),
              Divider(
                color: Colors.white.withValues(alpha: 0.5),
                thickness: 5,
              ),
              Expanded(child: displayCostTotalList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayCostTotalList() {
    final List<Widget> list = <Widget>[];

    final Map<int, Map<int, List<int>>> nested = <int, Map<int, List<int>>>{};

    Map<int, int> lastYearLastCost = <int, int>{};

    final RegExp reg = RegExp('${widget.year - 1}');

    widget.investItemRecordMap.forEach((int key, List<InvestRecord> value) {
      value.sort((InvestRecord a, InvestRecord b) => a.date.compareTo(b.date));

      int keepCost = 0;

      for (final InvestRecord element in value) {
        if (reg.firstMatch(element.date) != null) {
          lastYearLastCost[key] = element.cost;
        }

        if (element.date.split('-')[0] == widget.year.toString()) {
          if (keepCost != element.cost) {
            ((nested[key] ??= <int, List<int>>{})[element.date.split('-')[1].toInt()] ??= <int>[])
                .add(element.cost - keepCost);
          }

          keepCost = element.cost;
        }
      }
    });

    if (widget.year == 2024) {
      lastYearLastCost = <int, int>{
        0: 343328,
        104: 294821,
        105: 269999,
        106: 269999,
        107: 50000,
        108: 49999,
        116: 40000,
        117: 909999
      };
    }

    final List<int> investIdList = <int>[];

    final Map<int, Map<int, int>> accumulationCostMap = <int, Map<int, int>>{};

    nested.forEach((int key, Map<int, List<int>> value) {
      final Map<int, int> map = <int, int>{};

      value.forEach((int key2, List<int> value2) {
        int sum = value2.fold<int>(0, (int a, int b) => a + b);

        if (key2 == 1) {
          sum -= lastYearLastCost[key] ?? 0;
        }

        map[key2] = sum;
      });

      accumulationCostMap[key] = map;

      investIdList.add(key);
    });

    investIdList.sort();

    for (final int element in investIdList) {
      final List<Widget> list2 = <Widget>[];

      if (accumulationCostMap[element] != null) {
        // ignore: always_specify_types
        for (final int element2 in List.generate(12, (int index) => index)) {
          if (element2 == 0) {
            continue;
          }

          final String cost = (accumulationCostMap[element]![element2] != null)
              ? accumulationCostMap[element]![element2].toString()
              : '0';

          list2.add(
            Container(
              width: 80,
              height: 30,
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: (element2 % 2).isOdd ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              alignment: Alignment.topRight,
              child: Text(cost.toCurrency()),
            ),
          );
        }
      }

      list.add(
        Row(
          children: <Widget>[
            Container(
              width: 200,
              height: 30,
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(border: Border.all(color: Colors.white.withValues(alpha: 0.3))),
              child: Text(
                (element == 0)
                    ? 'GOLD'
                    : (investNameMap[element] != null)
                        ? investNameMap[element]!
                        : '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(children: list2),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DefaultTextStyle(style: const TextStyle(fontSize: 12), child: Column(children: list)),
      ),
    );
  }
}
