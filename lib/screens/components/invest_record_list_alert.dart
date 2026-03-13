import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
import '../../extensions/extensions.dart';

class InvestRecordListAlert extends ConsumerStatefulWidget {
  const InvestRecordListAlert({super.key, required this.investName, required this.allInvestRecord});

  final InvestName investName;
  final List<InvestRecord> allInvestRecord;

  ///
  @override
  ConsumerState<InvestRecordListAlert> createState() => _InvestRecordListAlertState();
}

class _InvestRecordListAlertState extends ConsumerState<InvestRecordListAlert> {
  List<InvestRecord> _filteredRecords = <InvestRecord>[];
  LineChartData _graphData = LineChartData();

  ///
  @override
  void initState() {
    super.initState();
    _refreshDisplayData();
  }

  ///
  @override
  void didUpdateWidget(covariant InvestRecordListAlert oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.investName.relationalId != widget.investName.relationalId ||
        !identical(oldWidget.allInvestRecord, widget.allInvestRecord)) {
      _refreshDisplayData();
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 150, child: LineChart(_graphData)),
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
    for (final InvestRecord element in _filteredRecords) {
      final Color costColor = (lastCost != element.cost) ? Colors.yellowAccent : Colors.white;

      list.add(Container(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
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
                    child:
                        Container(alignment: Alignment.topRight, child: Text(element.price.toString().toCurrency()))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(),
                Expanded(
                    child: Container(
                        alignment: Alignment.topRight,
                        child: Text((element.price - element.cost).toString().toCurrency()))),
              ],
            ),
          ],
        ),
      ));

      lastCost = element.cost;
    }

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
  void _refreshDisplayData() {
    _filteredRecords = widget.allInvestRecord
        .where((InvestRecord element) => element.investId == widget.investName.relationalId)
        .toList()
      ..sort((InvestRecord a, InvestRecord b) => a.date.compareTo(b.date));

    _graphData = _buildChartData(records: _filteredRecords);
  }

  ///
  LineChartData _buildChartData({required List<InvestRecord> records}) {
    final List<FlSpot> flspots = <FlSpot>[];
    final List<int> points = <int>[];

    for (int i = 0; i < records.length; i++) {
      final int diff = records[i].price - records[i].cost;
      points.add(diff);
      flspots.add(FlSpot(i.toDouble(), diff.toDouble()));
    }

    final double startPrice = points.isNotEmpty ? points.first.toDouble() : 0.0;
    final double endPrice = points.isNotEmpty ? points.last.toDouble() : 0.0;

    final List<FlSpot> flspotsTrend = (flspots.isNotEmpty) ? <FlSpot>[flspots.first, flspots.last] : <FlSpot>[];

    final int maxPoint = (points.isNotEmpty) ? points.reduce(max) : 0;
    final int minPoint = (points.isNotEmpty) ? points.reduce(min) : 0;

    double graphYMax = max(maxPoint, 0).toDouble();
    final double graphYMin = min(minPoint, 0).toDouble();

    if (graphYMax <= graphYMin) {
      graphYMax = graphYMin + 1;
    }

    return LineChartData(
      maxY: graphYMax,
      minY: graphYMin,
      lineTouchData: const LineTouchData(enabled: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
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
                    style: const TextStyle(fontSize: 10, color: Colors.orangeAccent),
                    children: <TextSpan>[
                      const TextSpan(text: ' / ', style: TextStyle(color: Colors.white)),
                      TextSpan(
                        text:
                            '${(endPrice - startPrice) > 0 ? '+' : ''} ${(endPrice - startPrice).toString().split('.')[0].toCurrency()}',
                        style: TextStyle(
                            color: ((endPrice - startPrice) > 0) ? const Color(0xFFFBB6CE) : Colors.yellowAccent),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        leftTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
      ),
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
