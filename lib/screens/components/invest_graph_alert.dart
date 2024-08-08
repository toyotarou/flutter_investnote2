// ignore_for_file: lines_longer_than_80_chars

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invest_note/collections/invest_name.dart';
import 'package:invest_note/collections/invest_record.dart';
import 'package:invest_note/enum/invest_kind.dart';
import 'package:invest_note/extensions/extensions.dart';
import 'package:invest_note/screens/components/parts/custom_scroll_bar.dart';
import 'package:invest_note/state/invest_graph/invest_graph.dart';
import 'package:invest_note/utilities/utilities.dart';

class InvestGraphAlert extends ConsumerStatefulWidget {
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
  ConsumerState<InvestGraphAlert> createState() => _InvestGraphAlertState();
}

class _InvestGraphAlertState extends ConsumerState<InvestGraphAlert> {
  LineChartData graphData = LineChartData();
  LineChartData graphData2 = LineChartData();

  final ScrollController _controller = ScrollController();

  final Utility _utility = Utility();

  List<String> investGraphGuideNames = [];

  ///
  @override
  Widget build(BuildContext context) {
    setChartData();

    final wideGraphDisplay = ref
        .watch(investGraphProvider.select((value) => value.wideGraphDisplay));

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: [
          Column(
            children: [
              Expanded(child: LineChart(graphData2)),
              const SizedBox(height: 40),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _controller,
            child: SizedBox(
              width: wideGraphDisplay
                  ? context.screenSize.width *
                      (widget.calendarCellDateDataList.length / 10)
                  : context.screenSize.width * 0.65,
              height: context.screenSize.height - 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: context.screenSize.width),
                  Expanded(child: LineChart(graphData)),
                  SizedBox(
                    height: 40,
                    child: wideGraphDisplay
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.pinkAccent.withOpacity(0.3)),
                                onPressed: () => _controller.jumpTo(
                                    _controller.position.maxScrollExtent),
                                child: const Text('jump'),
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.pinkAccent.withOpacity(0.3)),
                                    onPressed: () => _controller.jumpTo(
                                        _controller.position.minScrollExtent),
                                    child: const Text('back'),
                                  ),
                                  const SizedBox(width: 50),
                                ],
                              ),
                            ],
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          ),
          CustomScrollBar(
            scrollController: _controller,
            investGraphGuideNames: investGraphGuideNames,
            investNameList: widget.investNameList,
          ),
        ],
      ),
    );
  }

  ///
  void setChartData() {
    final idList = <int>[];

    investGraphGuideNames = [];

    if (widget.kind == InvestKind.gold.name) {
      idList.add(0);
    } else {
      widget.investNameList
          .where((element) => element.kind == widget.kind)
          .forEach((element2) {
        idList.add(element2.id);

        investGraphGuideNames.add(element2.name);
      });
    }

    final map = <int, Map<String, int>>{};

    for (final element in idList) {
      final map2 = <String, int>{};
      for (final element2 in widget.calendarCellDateDataList) {
        map2[element2] = 0;
      }
      map[element] = map2;
    }

    for (final element in widget.allInvestRecord) {
      map[element.investId]?[element.date] =
          (element.price != 0 && element.cost != 0)
              ? ((element.price / element.cost) * 100)
                  .toString()
                  .split('.')[0]
                  .toInt()
              : 0;
    }

    final selectedGraphId =
        ref.watch(investGraphProvider.select((value) => value.selectedGraphId));

    final flspotsList = <List<FlSpot>>[];

    final points = <int>[];

    if (selectedGraphId != 0) {
      map.forEach((key, value) {
        if (selectedGraphId == key) {
          final flspots = <FlSpot>[];

          var j = 0;
          value.forEach((key2, value2) {
            if (value2 > 0) {
              flspots.add(FlSpot(j.toDouble(), value2.toDouble()));
            }

            points.add(value2);

            j++;
          });

          flspotsList.add(flspots);
        }
      });
    } else {
      map.forEach((key, value) {
        final flspots = <FlSpot>[];

        var j = 0;
        value.forEach((key2, value2) {
          if (value2 > 0) {
            flspots.add(FlSpot(j.toDouble(), value2.toDouble()));
          }

          points.add(value2);

          j++;
        });

        flspotsList.add(flspots);
      });
    }

    const graphYMax = 300;
    const graphYMin = 0;

    final investGraphState = ref.watch(investGraphProvider);

    final twelveColor = _utility.getTwelveColor();

    graphData = LineChartData(
      maxY: graphYMax.toDouble(),
      minY: graphYMin.toDouble(),

      borderData: FlBorderData(show: false),

      ///
      lineTouchData: LineTouchData(
          touchTooltipData:
              LineTouchTooltipData(getTooltipItems: getGraphToolTip)),

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
                      Text(investGraphState.wideGraphDisplay
                          ? widget.calendarCellDateDataList[value.toInt()]
                              .split('-')[0]
                          : ''),
                      Text(
                        investGraphState.wideGraphDisplay
                            ? '${widget.calendarCellDateDataList[value.toInt()].split('-')[1]}-${widget.calendarCellDateDataList[value.toInt()].split('-')[2]}'
                            : '',
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
            reservedSize: 30,
            getTitlesWidget: (value, meta) => Container(),
          ),
        ),
        //-------------------------// 左側の目盛り

        //-------------------------// 右側の目盛り
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) => Container(),
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
            color: (investGraphState.selectedGraphName != '' &&
                    investGraphState.selectedGraphColor != null)
                ? investGraphState.selectedGraphColor
                : twelveColor[i % 12],
            dotData: const FlDotData(show: false),
          ),
      ],
    );

    graphData2 = LineChartData(
      maxY: graphYMax.toDouble(),
      minY: graphYMin.toDouble(),

      borderData: FlBorderData(show: false),

      ///
      lineTouchData: LineTouchData(
          touchTooltipData:
              LineTouchTooltipData(getTooltipItems: getGraphToolTip)),

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
              return Container();
            },
          ),
        ),
        //-------------------------// 下部の目盛り

        //-------------------------// 左側の目盛り
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              if (value == graphYMin || value == graphYMax) {
                return const SizedBox();
              }

              return SideTitleWidget(
                  axisSide: AxisSide.left,
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  ));
            },
          ),
        ),
        //-------------------------// 左側の目盛り

        //-------------------------// 右側の目盛り
        rightTitles: const AxisTitles(),
        //-------------------------// 右側の目盛り
      ),

      ///
      lineBarsData: [],
    );
  }

  ///
  List<LineTooltipItem> getGraphToolTip(List<LineBarSpot> touchedSpots) {
    final list = <LineTooltipItem>[];

    for (final element in touchedSpots) {
      final textStyle = TextStyle(
          color: element.bar.gradient?.colors.first ??
              element.bar.color ??
              Colors.blueGrey,
          fontWeight: FontWeight.bold,
          fontSize: 12);

      final price = element.y.round().toString().split('.')[0].toCurrency();
//      final month = usageGuideList[element.barIndex].mm;

      list.add(LineTooltipItem(price, textStyle, textAlign: TextAlign.end));
    }

    return list;
  }
}
