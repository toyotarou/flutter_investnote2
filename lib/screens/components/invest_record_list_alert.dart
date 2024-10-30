import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
import '../../extensions/extensions.dart';

class InvestRecordListAlert extends ConsumerStatefulWidget {
  const InvestRecordListAlert(
      {super.key, required this.investName, required this.allInvestRecord});

  final InvestName investName;
  final List<InvestRecord> allInvestRecord;

  ///
  @override
  ConsumerState<InvestRecordListAlert> createState() =>
      _InvestRecordListAlertState();
}

class _InvestRecordListAlertState extends ConsumerState<InvestRecordListAlert> {
  LineChartData graphData = LineChartData();

  ///
  @override
  Widget build(BuildContext context) {
    setChartData();

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
                  Text(widget.investName.name),
                  Container(),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              const SizedBox(height: 10),
              SizedBox(height: 150, child: LineChart(graphData)),
              const SizedBox(height: 20),
              Expanded(child: _displayInvestRecordList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayInvestRecordList() {
    final List<Widget> list = <Widget>[];

    int lastCost = 0;
    widget.allInvestRecord
        .where((InvestRecord element) =>
            element.investId == widget.investName.relationalId)
        .toList()
      ..sort((InvestRecord a, InvestRecord b) => a.date.compareTo(b.date))
      ..forEach((InvestRecord element) {
        final Color costColor =
            (lastCost != element.cost) ? Colors.yellowAccent : Colors.white;

        list.add(Container(
          padding:
              const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(flex: 2, child: Text(element.date)),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        element.cost.toString().toCurrency(),
                        style: TextStyle(color: costColor),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                          alignment: Alignment.topRight,
                          child: Text(element.price.toString().toCurrency()))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(),
                  Expanded(
                      child: Container(
                          alignment: Alignment.topRight,
                          child: Text((element.price - element.cost)
                              .toString()
                              .toCurrency()))),
                ],
              ),
            ],
          ),
        ));

        lastCost = element.cost;
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

  ///
  void setChartData() {
    final List<FlSpot> flspots = <FlSpot>[];

    final List<int> points = <int>[];

    double startPrice = 0.0;
    double endPrice = 0.0;

    FlSpot startSpot = FlSpot.zero;
    FlSpot endSpot = FlSpot.zero;
    List<FlSpot> flspotsTrend = <FlSpot>[];

    for (int i = 0; i < widget.allInvestRecord.length; i++) {
      if (widget.allInvestRecord[i].investId ==
          widget.investName.relationalId) {
        if (startPrice == 0) {
          startPrice =
              (widget.allInvestRecord[i].price - widget.allInvestRecord[i].cost)
                  .toDouble();

          startSpot = FlSpot(
              i.toDouble(),
              (widget.allInvestRecord[i].price - widget.allInvestRecord[i].cost)
                  .toDouble());
        }

        flspots.add(
          FlSpot(
              i.toDouble(),
              (widget.allInvestRecord[i].price - widget.allInvestRecord[i].cost)
                  .toDouble()),
        );

        points.add(
            widget.allInvestRecord[i].price - widget.allInvestRecord[i].cost);

        endPrice =
            (widget.allInvestRecord[i].price - widget.allInvestRecord[i].cost)
                .toDouble();

        endSpot = FlSpot(
            i.toDouble(),
            (widget.allInvestRecord[i].price - widget.allInvestRecord[i].cost)
                .toDouble());
      }
    }

    flspotsTrend = <FlSpot>[startSpot, endSpot];

    final int maxPoint = (points.isNotEmpty) ? points.reduce(max) : 0;

    final int minPoint = (points.isNotEmpty) ? points.reduce(min) : 0;

    int devide = 0;
    switch (maxPoint.toString().length) {
      case 3:
        devide = 100;
      case 4:
        devide = 1000;
      case 5:
        devide = 10000;
      case 6:
        devide = 100000;
      case 7:
        devide = 1000000;
    }

    if (devide != 0) {
      final int graphYMax = (maxPoint / devide).round() * devide;
      final int graphYMin = (minPoint < 0) ? minPoint : 0;

      graphData = LineChartData(
        maxY: graphYMax.toDouble(),
        minY: graphYMin.toDouble(),

        ///
        lineTouchData: const LineTouchData(enabled: false),

        ///
        titlesData: FlTitlesData(
          //-------------------------// 上部の目盛り
          topTitles: const AxisTitles(),
          //-------------------------// 上部の目盛り

          //-------------------------// 下部の目盛り
          bottomTitles: AxisTitles(
            axisNameWidget: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontSize: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(startPrice.toString().split('.')[0].toCurrency()),
                  RichText(
                    text: TextSpan(
                      text: endPrice.toString().split('.')[0].toCurrency(),
                      style: const TextStyle(
                          fontSize: 10, color: Colors.orangeAccent),
                      children: <TextSpan>[
                        const TextSpan(
                            text: ' / ', style: TextStyle(color: Colors.white)),
                        TextSpan(
                          text:
                              '${(endPrice - startPrice) > 0 ? '+' : ''} ${(endPrice - startPrice).toString().split('.')[0].toCurrency()}',
                          style: TextStyle(
                              color: ((endPrice - startPrice) > 0)
                                  ? const Color(0xFFFBB6CE)
                                  : Colors.yellowAccent),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          //-------------------------// 下部の目盛り

          //-------------------------// 左側の目盛り
          leftTitles: const AxisTitles(),
          //-------------------------// 左側の目盛り

          //-------------------------// 右側の目盛り
          rightTitles: const AxisTitles(),
          //-------------------------// 右側の目盛り
        ),

        ///
        lineBarsData: <LineChartBarData>[
          LineChartBarData(
            spots: flspots,
            barWidth: 1,
            isStrokeCapRound: true,
            color: Colors.yellowAccent,
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: flspotsTrend,
            barWidth: 1,
            isStrokeCapRound: true,
            color: Colors.redAccent,
            dotData: const FlDotData(show: false),
          ),
        ],
      );
    }
  }
}
