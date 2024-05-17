import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:invest_note/enum/invest_kind.dart';

import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
import '../../extensions/extensions.dart';

class InvestGraphAlert extends StatefulWidget {
  const InvestGraphAlert({
    super.key,
    required this.kind,
    required this.investNameList,
    required this.allInvestRecord,
    required this.calendarCellDateDataList,
  });

  final String kind;
  final List<InvestName> investNameList;
  final List<InvestRecord> allInvestRecord;
  final List<String> calendarCellDateDataList;

  ///
  @override
  State<InvestGraphAlert> createState() => _InvestGraphAlertState();
}

class _InvestGraphAlertState extends State<InvestGraphAlert> {
  LineChartData graphData = LineChartData();

  final ScrollController _controller = ScrollController();

  ///
  @override
  Widget build(BuildContext context) {
    setChartData();

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        child: SizedBox(
          width: context.screenSize.width * (widget.calendarCellDateDataList.length / 10),
          height: context.screenSize.height - 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: context.screenSize.width),

              Expanded(child: LineChart(graphData)),

              //
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.pinkAccent.withOpacity(0.3),
              //       ),
              //       onPressed: () {
              //         _controller.jumpTo(_controller.position.maxScrollExtent);
              //       },
              //       child: const Text('jump'),
              //     ),
              //     ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.pinkAccent.withOpacity(0.3),
              //       ),
              //       onPressed: () {
              //         _controller.jumpTo(_controller.position.minScrollExtent);
              //       },
              //       child: const Text('back'),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void setChartData() {
/*
    //---------------------------------------(1)
    usageGuideList = [];

    var flag = 1;
    if (date.year == 2020) {
      flag = (date.month < 6) ? 0 : 1;
    }

    switch (flag) {
      case 0:
        for (var i = 6; i >= 1; i--) {
          usageGuideList.add(DateTime(date.yyyy.toInt(), i));
        }
        break;
      case 1:
        for (var i = 0; i < 6; i++) {
          usageGuideList.add(DateTime(date.yyyy.toInt(), date.mm.toInt() - i));
        }
        break;
    }
    //---------------------------------------(1)

    //---------------------------------------(2)
    final graphValues = <String, List<Map<String, dynamic>>>{};

    usageGuideList.forEach((element) {
      final list2 = <Map<String, int>>[];

      var sum = 0;

      final spendYearlyList = _ref.watch(spendMonthDetailProvider(element).select((value) => value.spendYearlyList));

      spendYearlyList.value?.forEach((element2) {
        sum += element2.spend;

        list2.add({'day': element2.date.day, 'sum': sum});
      });

      graphValues[element.yyyymm] = list2;
    });
    //---------------------------------------(2)

    //---------------------------------------(3)
    final flspotsList = <List<FlSpot>>[];

    final points = <int>[];

    graphValues.entries.forEach((element) {
      final flspots = <FlSpot>[];

      element.value.forEach((element2) {
        flspots.add(FlSpot(element2['day'].toString().toDouble(), element2['sum'].toString().toDouble()));

        points.add(element2['sum']);
      });

      flspotsList.add(flspots);
    });
    //---------------------------------------(3)
*/

    final idList = <int>[];

    if (widget.kind == InvestKind.gold.name) {
      idList.add(0);
    } else {
      widget.investNameList.where((element) => element.kind == widget.kind).forEach((element2) => idList.add(element2.id));
    }

    final map = <int, Map<String, int>>{};

    idList.forEach((element) {
      final map2 = <String, int>{};
      widget.calendarCellDateDataList.forEach((element2) {
        map2[element2] = 0;
      });
      map[element] = map2;
    });

    widget.allInvestRecord.forEach((element) {
      map[element.investId]?[element.date] = element.price;
    });

    print(map);

    /*
    I/flutter ( 3834): {
    2: {2024-05-01: 35656, 2024-05-02: 35115, 2024-05-07: 34766, 2024-05-08: 34505, 2024-05-09: 34720, 2024-05-10: 34306, 2024-05-13: 34211, 2024-05-14: 34557, 2024-05-15: 34869, 2024-05-16: 34832, 2024-05-17: 35171},
    3: {2024-05-01: 13193, 2024-05-02: 13016, 2024-05-07: 13105, 2024-05-08: 13306, 2024-05-09: 13319, 2024-05-10: 13210, 2024-05-13: 13146, 2024-05-14: 13234, 2024-05-15: 13195, 2024-05-16: 13189, 2024-05-17: 13441},
    4: {2024-05-01: 3466, 2024-05-02: 3485, 2024-05-07: 4224, 2024-05-08: 5010, 2024-05-09: 5089, 2024-05-10: 4849, 2024-05-13: 4683, 2024-05-14: 4763, 2024-05-15: 4725, 2024-05-16: 5151, 2024-05-17: 5191}}

    */

    /*

    I/flutter ( 3834): {
    5: {2024-05-01: 381649, 2024-05-02: 378739, 2024-05-07: 382619, 2024-05-08: 382377, 2024-05-09: 384802, 2024-05-10: 393711, 2024-05-13: 396822, 2024-05-14: 397693, 2024-05-15: 401177, 2024-05-16: 400182, 2024-05-17: 401298},
    6: {2024-05-01: 431473, 2024-05-02: 427264, 2024-05-07: 421244, 2024-05-08: 429604, 2024-05-09: 432341, 2024-05-10: 443992, 2024-05-13: 446747, 2024-05-14: 447967, 2024-05-15: 449292, 2024-05-16: 451972, 2024-05-17: 449954},
    7: {2024-05-01: 437719, 2024-05-02: 433787, 2024-05-07: 427289, 2024-05-08: 435426, 2024-05-09: 438417, 2024-05-10: 450393, 2024-05-13: 452908, 2024-05-14: 454523, 2024-05-15: 455532, 2024-05-16: 458280, 2024-05-17: 456060}, 8: {2024-05-01: 103034, 2024-05-02: 103471, 2024-05-07: 102244, 2024-05-08: 100517, 2024-05-09: 99976, 2024-05-10: 110885, 2024-05-13: 109246, 2024-05-14: 109810, 2024-05-15: 110085, 2024-05-16: 110748, 2024-05-17: 109269}, 9: {2024-05-01: 104943, 2024-05-02: 105389, 2024-05-07: 105384, 2024-05-08: 103170, 2024-05-09: 102954, 2024-05-10: 113969,

    */

    /*
    I/flutter ( 3834): {
    0: {2024-05-01: 577003, 2024-05-02: 578905, 2024-05-07: 573979, 2024-05-08: 573258, 2024-05-09: 574271, 2024-05-10: 585306, 2024-05-13: 590838, 2024-05-14: 586685, 2024-05-15: 592524, 2024-05-16: 593738, 2024-05-17: 594705}}

    */

    graphData = LineChartData();
  }
}
