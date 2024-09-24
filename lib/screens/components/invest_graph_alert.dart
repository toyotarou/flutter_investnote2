// ignore_for_file: lines_longer_than_80_chars

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
import '../../enum/invest_kind.dart';
import '../../extensions/extensions.dart';
import '../../state/invest_graph/invest_graph.dart';
import '../../utilities/utilities.dart';
import 'parts/custom_scroll_bar.dart';

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

  List<String> investGraphGuideFrames = <String>[];
  List<String> investGraphGuideNames = <String>[];

  ///
  @override
  Widget build(BuildContext context) {
    setChartData();

    final bool wideGraphDisplay = ref.watch(investGraphProvider
        .select((InvestGraphState value) => value.wideGraphDisplay));

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
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
                children: <Widget>[
                  Container(width: context.screenSize.width),
                  Expanded(child: LineChart(graphData)),
                  SizedBox(
                    height: 40,
                    child: wideGraphDisplay
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.pinkAccent.withOpacity(0.3)),
                                onPressed: () => _controller.jumpTo(
                                    _controller.position.maxScrollExtent),
                                child: const Text('jump'),
                              ),
                              Row(
                                children: <Widget>[
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
            investGraphGuideFrames: investGraphGuideFrames,
            investGraphGuideNames: investGraphGuideNames,
            investNameList: widget.investNameList,
          ),
        ],
      ),
    );
  }

  ///
  void setChartData() {
    final List<int> idList = <int>[];

    investGraphGuideFrames = <String>[];
    investGraphGuideNames = <String>[];

    if (widget.kind == InvestKind.gold.name) {
      idList.add(0);
    } else {
      widget.investNameList
          .where((InvestName element) => element.kind == widget.kind)
          .toList()
        ..sort((InvestName a, InvestName b) =>
            a.dealNumber.compareTo(b.dealNumber))
        ..forEach((InvestName element2) {
          idList.add(element2.relationalId);

          investGraphGuideFrames.add(element2.frame);
          investGraphGuideNames.add(element2.name);
        });
    }

    final Map<int, Map<String, int>> map = <int, Map<String, int>>{};

    for (final int element in idList) {
      final Map<String, int> map2 = <String, int>{};
      for (final String element2 in widget.calendarCellDateDataList) {
        map2[element2] = 0;
      }
      map[element] = map2;
    }

    for (final InvestRecord element in widget.allInvestRecord) {
      if (element.price > 0 && element.cost > 0) {
        map[element.investId]?[element.date] =
            (element.price != 0 && element.cost != 0)
                ? ((element.price / element.cost) * 100)
                    .toString()
                    .split('.')[0]
                    .toInt()
                : 0;
      }
    }

    final int selectedGraphId = ref.watch(investGraphProvider
        .select((InvestGraphState value) => value.selectedGraphId));

    final List<List<FlSpot>> flspotsList = <List<FlSpot>>[];

    final List<int> points = <int>[];

    if (selectedGraphId != 0) {
      map.forEach((int key, Map<String, int> value) {
        if (selectedGraphId == key) {
          final List<FlSpot> flspots = <FlSpot>[];

          int j = 0;
          value.forEach((String key2, int value2) {
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
      map.forEach((int key, Map<String, int> value) {
        final List<FlSpot> flspots = <FlSpot>[];

        int j = 0;
        value.forEach((String key2, int value2) {
          if (value2 > 0) {
            flspots.add(FlSpot(j.toDouble(), value2.toDouble()));
          }

          points.add(value2);

          j++;
        });

        flspotsList.add(flspots);
      });
    }

    const int graphYMax = 300;
    const int graphYMin = 0;

    final InvestGraphState investGraphState = ref.watch(investGraphProvider);

    final List<Color> twelveColor = _utility.getTwelveColor();

    graphData = LineChartData(
      maxY: graphYMax.toDouble(),
      minY: graphYMin.toDouble(),

      borderData: FlBorderData(show: false),

      ///
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 2,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              final List<LineTooltipItem> list = <LineTooltipItem>[];

              for (final LineBarSpot element in touchedSpots) {
                final TextStyle textStyle = TextStyle(
                  color: element.bar.gradient?.colors.first ??
                      element.bar.color ??
                      Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );

                final String percent =
                    element.y.round().toString().split('.')[0].toCurrency();

                list.add(
                  LineTooltipItem(
                    '${element.x.toInt()} : $percent',
                    textStyle,
                    textAlign: TextAlign.start,
                  ),
                );
              }

              return list;
            }),
      ),

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
            getTitlesWidget: (double value, TitleMeta meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: DefaultTextStyle(
                  style: const TextStyle(fontSize: 10),
                  child: Column(
                    children: <Widget>[
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
            getTitlesWidget: (double value, TitleMeta meta) => Container(),
          ),
        ),
        //-------------------------// 左側の目盛り

        //-------------------------// 右側の目盛り
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (double value, TitleMeta meta) => Container(),
          ),
        ),
        //-------------------------// 右側の目盛り
      ),

      ///
      lineBarsData: <LineChartBarData>[
        for (int i = 0; i < flspotsList.length; i++)
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
            getTitlesWidget: (double value, TitleMeta meta) {
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
            getTitlesWidget: (double value, TitleMeta meta) {
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
      lineBarsData: <LineChartBarData>[],
    );
  }

  ///
  List<LineTooltipItem> getGraphToolTip(List<LineBarSpot> touchedSpots) {
    final List<LineTooltipItem> list = <LineTooltipItem>[];

    for (final LineBarSpot element in touchedSpots) {
      final TextStyle textStyle = TextStyle(
          color: element.bar.gradient?.colors.first ??
              element.bar.color ??
              Colors.blueGrey,
          fontWeight: FontWeight.bold,
          fontSize: 12);

      final String price =
          element.y.round().toString().split('.')[0].toCurrency();

      list.add(LineTooltipItem(price, textStyle, textAlign: TextAlign.end));
    }

    return list;
  }
}
