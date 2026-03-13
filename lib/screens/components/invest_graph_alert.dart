import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';

import '../../controllers/controllers_mixin.dart';
import '../../enum/invest_kind.dart';
import '../../extensions/extensions.dart';

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

class _InvestGraphAlertState extends ConsumerState<InvestGraphAlert> with ControllersMixin<InvestGraphAlert> {
  final ScrollController _controller = ScrollController();

  final Utility _utility = Utility();

  ///
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final _GraphPayload payload = _buildGraphPayload();

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(child: LineChart(payload.graphData2)),
              const SizedBox(height: 40),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _controller,
            child: SizedBox(
              width: investGraphState.wideGraphDisplay
                  ? context.screenSize.width * (widget.calendarCellDateDataList.length / 10)
                  : context.screenSize.width * 0.65,
              height: context.screenSize.height - 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(width: context.screenSize.width),
                  Expanded(child: LineChart(payload.graphData)),
                  SizedBox(
                    height: 40,
                    child: investGraphState.wideGraphDisplay
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.3)),
                                onPressed: _jumpToEnd,
                                child: const Text('jump'),
                              ),
                              Row(
                                children: <Widget>[
                                  ElevatedButton(
                                    style:
                                        ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.3)),
                                    onPressed: _jumpToStart,
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
            investGraphGuideFrames: payload.investGraphGuideFrames,
            investGraphGuideNames: payload.investGraphGuideNames,
            investNameList: widget.investNameList,
          ),
        ],
      ),
    );
  }

  ///
  _GraphPayload _buildGraphPayload() {
    final List<int> idList = <int>[];
    final List<String> investGraphGuideFrames = <String>[];
    final List<String> investGraphGuideNames = <String>[];

    if (widget.kind == InvestKind.gold.name) {
      idList.add(0);
    } else {
      widget.investNameList.where((InvestName element) => element.kind == widget.kind).toList()
        ..sort((InvestName a, InvestName b) => a.dealNumber.compareTo(b.dealNumber))
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
            (element.price != 0 && element.cost != 0) ? ((element.price / element.cost) * 100).floor() : 0;
      }
    }

    final List<List<FlSpot>> flspotsList = <List<FlSpot>>[];

    if (investGraphState.selectedGraphId != 0) {
      map.forEach((int key, Map<String, int> value) {
        if (investGraphState.selectedGraphId == key) {
          final List<FlSpot> flspots = <FlSpot>[];

          int j = 0;
          value.forEach((String key2, int value2) {
            if (value2 > 0) {
              flspots.add(FlSpot(j.toDouble(), value2.toDouble()));
            }
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
          j++;
        });

        flspotsList.add(flspots);
      });
    }

    const int graphYMax = 300;
    const int graphYMin = 0;

    final List<Color> twelveColor = _utility.getTwelveColor();

    final LineChartData graphData = LineChartData(
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
                  color: element.bar.gradient?.colors.first ?? element.bar.color ?? Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );

                final String percent = element.y.round().toString().split('.')[0].toCurrency();

                list.add(LineTooltipItem('${element.x.toInt()} : $percent', textStyle, textAlign: TextAlign.start));
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
                meta: meta,
                child: DefaultTextStyle(
                  style: const TextStyle(fontSize: 10),
                  child: Column(
                    children: <Widget>[
                      Text(investGraphState.wideGraphDisplay ? _dateLabel(value: value, part: 0) : ''),
                      Text(
                        investGraphState.wideGraphDisplay ? _dateMdLabel(value: value) : '',
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
            color: (investGraphState.selectedGraphName != '' && investGraphState.selectedGraphColor != null)
                ? investGraphState.selectedGraphColor
                : twelveColor[i % 12],
            dotData: const FlDotData(show: false),
          ),
      ],
    );

    final LineChartData graphData2 = LineChartData(
      maxY: graphYMax.toDouble(),
      minY: graphYMin.toDouble(),

      borderData: FlBorderData(show: false),

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
            getTitlesWidget: (double value, TitleMeta meta) => Container(),
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
                  meta: meta, child: Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)));
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

    return _GraphPayload(
      graphData: graphData,
      graphData2: graphData2,
      investGraphGuideFrames: investGraphGuideFrames,
      investGraphGuideNames: investGraphGuideNames,
    );
  }

  ///
  List<LineTooltipItem> getGraphToolTip(List<LineBarSpot> touchedSpots) {
    final List<LineTooltipItem> list = <LineTooltipItem>[];

    for (final LineBarSpot element in touchedSpots) {
      final TextStyle textStyle = TextStyle(
          color: element.bar.gradient?.colors.first ?? element.bar.color ?? Colors.blueGrey,
          fontWeight: FontWeight.bold,
          fontSize: 12);

      final String price = element.y.round().toString().split('.')[0].toCurrency();

      list.add(LineTooltipItem(price, textStyle, textAlign: TextAlign.end));
    }

    return list;
  }

  ///
  void _jumpToEnd() {
    if (_controller.hasClients) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }
  }

  ///
  void _jumpToStart() {
    if (_controller.hasClients) {
      _controller.jumpTo(_controller.position.minScrollExtent);
    }
  }

  ///
  String _dateLabel({required double value, required int part}) {
    final int index = value.toInt();
    if (index < 0 || index >= widget.calendarCellDateDataList.length) {
      return '';
    }

    final List<String> dateParts = widget.calendarCellDateDataList[index].split('-');
    if (part < 0 || part >= dateParts.length) {
      return '';
    }

    return dateParts[part];
  }

  ///
  String _dateMdLabel({required double value}) {
    final int index = value.toInt();
    if (index < 0 || index >= widget.calendarCellDateDataList.length) {
      return '';
    }

    final List<String> dateParts = widget.calendarCellDateDataList[index].split('-');
    if (dateParts.length < 3) {
      return '';
    }

    return '${dateParts[1]}-${dateParts[2]}';
  }
}

class _GraphPayload {
  _GraphPayload({
    required this.graphData,
    required this.graphData2,
    required this.investGraphGuideFrames,
    required this.investGraphGuideNames,
  });

  final LineChartData graphData;
  final LineChartData graphData2;
  final List<String> investGraphGuideFrames;
  final List<String> investGraphGuideNames;
}
