import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
import '../../enum/invest_kind.dart';
import '../../extensions/extensions.dart';
import '../../utilities/utilities.dart';

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

  final Utility _utility = Utility();

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.3)),
                    onPressed: () => _controller.jumpTo(_controller.position.maxScrollExtent),
                    child: const Text('jump'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.3)),
                    onPressed: () => _controller.jumpTo(_controller.position.minScrollExtent),
                    child: const Text('back'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void setChartData() {
    final idList = <int>[];

    if (widget.kind == InvestKind.gold.name) {
      idList.add(0);
    } else {
      widget.investNameList.where((element) => element.kind == widget.kind).forEach((element2) => idList.add(element2.id));
    }

    final map = <int, Map<String, int>>{};

    idList.forEach((element) {
      final map2 = <String, int>{};
      widget.calendarCellDateDataList.forEach((element2) => map2[element2] = 0);
      map[element] = map2;
    });

    widget.allInvestRecord.forEach(
        (element) => map[element.investId]?[element.date] = ((element.price / element.cost) * 100).toString().split('.')[0].toInt());

    final flspotsList = <List<FlSpot>>[];

    final points = <int>[];

    map.forEach((key, value) {
      final flspots = <FlSpot>[];

      var j = 0;
      value.forEach((key2, value2) {
        flspots.add(FlSpot(j.toDouble(), value2.toDouble()));

        points.add(value2);

        j++;
      });

      flspotsList.add(flspots);
    });

    final maxPoint = (points.isNotEmpty) ? points.reduce(max) : 300;
    final minPoint = (points.isNotEmpty) ? points.reduce(min) : 0;

    final roundMax = (maxPoint / 10).round();
    final roundMin = (minPoint / 10).round();

    final graphYMax = (roundMax + 5) * 10;
    final graphYMin = (roundMin - 1) * 10;

    final twelveColor = _utility.getTwelveColor();

    graphData = LineChartData(
      maxY: graphYMax.toDouble(),
      minY: graphYMin.toDouble(),

      ///
      lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(getTooltipItems: getGraphToolTip)),

      ///
      gridData: _utility.getFlGridData(),

      ///
      titlesData: FlTitlesData(
        //-------------------------// 上部の目盛り
        topTitles: const AxisTitles(),
        //-------------------------// 上部の目盛り

        //-------------------------// 下部の目盛り
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: DefaultTextStyle(
                  style: const TextStyle(fontSize: 10),
                  child: Column(
                    children: [
                      Text(widget.calendarCellDateDataList[value.toInt()].split('-')[0]),
                      Text(
                        '${widget.calendarCellDateDataList[value.toInt()].split('-')[1]}-${widget.calendarCellDateDataList[value.toInt()].split('-')[2]}',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        //-------------------------// 下部の目盛り

        //-------------------------// 左側の目盛り
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 12)),
          ),
        ),
        //-------------------------// 左側の目盛り

        //-------------------------// 右側の目盛り
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 12)),
          ),
        ),
        //-------------------------// 右側の目盛り
      ),

      ///
      lineBarsData: [
        //forで仕方ない
        for (var i = 0; i < flspotsList.length; i++)
          LineChartBarData(
            spots: flspotsList[i],
            barWidth: 3,
            isStrokeCapRound: true,
            color: twelveColor[i],
          ),
      ],
    );
  }

  ///
  List<LineTooltipItem> getGraphToolTip(List<LineBarSpot> touchedSpots) {
    final list = <LineTooltipItem>[];

    touchedSpots.forEach((element) {
      final textStyle = TextStyle(
          color: element.bar.gradient?.colors.first ?? element.bar.color ?? Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 12);

      final price = element.y.round().toString().split('.')[0].toCurrency();
//      final month = usageGuideList[element.barIndex].mm;

      list.add(LineTooltipItem(price, textStyle, textAlign: TextAlign.end));
    });

    return list;
  }
}
