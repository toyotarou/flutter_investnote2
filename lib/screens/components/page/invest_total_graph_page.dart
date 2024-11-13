import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../collections/invest_name.dart';
import '../../../collections/invest_record.dart';
import '../../../enum/invest_kind.dart';
import '../../../extensions/extensions.dart';
import '../../../model/invest_price.dart';
import '../../../state/total_graph/total_graph.dart';

class InvestTotalGraphPage extends ConsumerStatefulWidget {
  const InvestTotalGraphPage({
    super.key,
    required this.isar,
    required this.investNameList,
    required this.investRecordMap,
    required this.year,
    required this.investRecordList,
  });

  final Isar isar;
  final List<InvestName> investNameList;

  final Map<String, List<InvestRecord>> investRecordMap;
  final int year;
  final List<InvestRecord> investRecordList;

  @override
  ConsumerState<InvestTotalGraphPage> createState() =>
      _InvestTotalGraphAlertState();
}

class _InvestTotalGraphAlertState extends ConsumerState<InvestTotalGraphPage> {
  Map<String, InvestPrice> investPriceMap = <String, InvestPrice>{};

  LineChartData graphData = LineChartData();
  LineChartData graphData2 = LineChartData();

  ///
  @override
  Widget build(BuildContext context) {
    makeGraphData();

    setChartData();

    final String selectedGraphName = ref.watch(totalGraphProvider
        .select((TotalGraphState value) => value.selectedGraphName));

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(height: 50 + 20),
              Expanded(child: LineChart(graphData2)),
              const SizedBox(height: 100),
            ],
          ),
          SizedBox(
            width: context.screenSize.width,
            height: context.screenSize.height - 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(width: context.screenSize.width),
                SizedBox(
                  height: 50,
                  child: Row(
                      children: InvestKind.values.map((InvestKind e) {
                    return Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(totalGraphProvider.notifier)
                                .setSelectedGraphName(name: e.name);
                          },
                          child: CircleAvatar(
                            backgroundColor: (selectedGraphName == e.name)
                                ? Colors.orangeAccent.withOpacity(0.6)
                                : Colors.black.withOpacity(0.6),
                            child: Text(
                              (e.name == 'blank') ? 'ALL' : e.japanName,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    );
                  }).toList()),
                ),
                const SizedBox(height: 20),
                Expanded(child: LineChart(graphData)),
                SizedBox(
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      Divider(
                        color: Colors.white.withOpacity(0.1),
                        thickness: 5,
                      ),
                      const SizedBox(height: 10),
                      displayStartMonthParts(),
                      const SizedBox(height: 20),
                      displayEndMonthParts(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget displayStartMonthParts() {
    final double width = context.screenSize.width;

    final int oneRadius = ((width * 0.3) / 12).floor();

    final int fontSize = ((width * 0.27) / 12).floor();

    // ignore: always_specify_types
    final List<int> list = List.generate(12, (int index) => index);

    final int selectedStartMonth = ref.watch(totalGraphProvider
        .select((TotalGraphState value) => value.selectedStartMonth));

    return Row(
      children: list.map((int element) {
        return Padding(
          padding: const EdgeInsets.all(1.2),
          child: GestureDetector(
            onTap: (widget.year == DateTime.now().year &&
                    element >= DateTime.now().month)
                ? null
                : () {
                    ref
                        .read(totalGraphProvider.notifier)
                        .setSelectedStartMonth(month: element + 1);

                    ref
                        .read(totalGraphProvider.notifier)
                        .setSelectedEndMonth(month: 0);

                    if (element == selectedStartMonth - 1) {
                      ref
                          .read(totalGraphProvider.notifier)
                          .setSelectedStartMonth(month: 0);
                    }
                  },
            child: CircleAvatar(
              backgroundColor: (element + 1 == selectedStartMonth)
                  ? Colors.yellowAccent.withOpacity(0.2)
                  : (widget.year == DateTime.now().year &&
                          element >= DateTime.now().month)
                      ? Colors.grey.withOpacity(0.2)
                      : Colors.white.withOpacity(0.2),
              radius: oneRadius.toDouble(),
              child: Text(
                (element + 1).toString().padLeft(2, '0'),
                style: TextStyle(fontSize: fontSize.toDouble()),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  ///
  Widget displayEndMonthParts() {
    final double width = context.screenSize.width;

    final int oneRadius = ((width * 0.3) / 12).floor();

    final int fontSize = ((width * 0.27) / 12).floor();

    // ignore: always_specify_types
    final List<int> list = List.generate(12, (int index) => index);

    final int selectedStartMonth = ref.watch(totalGraphProvider
        .select((TotalGraphState value) => value.selectedStartMonth));

    final int selectedEndMonth = ref.watch(totalGraphProvider
        .select((TotalGraphState value) => value.selectedEndMonth));

    return Row(
      children: list.map((int element) {
        return Padding(
          padding: const EdgeInsets.all(1.2),
          child: GestureDetector(
            onTap: ((element < selectedStartMonth - 1) ||
                    (widget.year == DateTime.now().year &&
                        element >= DateTime.now().month))
                ? null
                : () {
                    ref
                        .read(totalGraphProvider.notifier)
                        .setSelectedEndMonth(month: element + 1);
                  },
            child: CircleAvatar(
              backgroundColor: (element + 1 == selectedEndMonth)
                  ? Colors.yellowAccent.withOpacity(0.2)
                  : (widget.year == DateTime.now().year &&
                          element >= DateTime.now().month)
                      ? Colors.grey.withOpacity(0.2)
                      : Colors.white.withOpacity(0.2),
              radius: oneRadius.toDouble(),
              child: Text(
                (element + 1).toString().padLeft(2, '0'),
                style: TextStyle(fontSize: fontSize.toDouble()),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  ///
  void makeGraphData() {
    investPriceMap = <String, InvestPrice>{};

    final List<int> stockRelationalIds = <int>[];
    final List<int> shintakuRelationalIds = <int>[];

    for (final InvestName element in widget.investNameList) {
      if (element.kind == InvestKind.stock.name) {
        stockRelationalIds.add(element.relationalId);
      }

      if (element.kind == InvestKind.shintaku.name) {
        shintakuRelationalIds.add(element.relationalId);
      }
    }

    final int selectedStartMonth = ref.watch(totalGraphProvider
        .select((TotalGraphState value) => value.selectedStartMonth));
    final int selectedEndMonth = ref.watch(totalGraphProvider
        .select((TotalGraphState value) => value.selectedEndMonth));

    final List<String> selectedMonthList = <String>[];

    final int endMonth = (selectedEndMonth == 0) ? 12 : selectedEndMonth;

    for (int i = selectedStartMonth; i <= endMonth; i++) {
      selectedMonthList.add(i.toString().padLeft(2, '0'));
    }

    widget.investRecordMap.forEach((String key, List<InvestRecord> value) {
      final List<String> exKey = key.split('-');

      if (exKey[0].toInt() == widget.year) {
        if (selectedMonthList.contains(exKey[1])) {
          int stockCost = 0;
          int stockPrice = 0;
          int stockSum = 0;

          int shintakuCost = 0;
          int shintakuPrice = 0;
          int shintakuSum = 0;

          int goldCost = 0;
          int goldPrice = 0;
          int goldSum = 0;

          int allCost = 0;
          int allPrice = 0;
          int allSum = 0;

          for (final InvestRecord element in value) {
            if (stockRelationalIds.contains(element.investId)) {
              stockCost += element.cost;
              stockPrice += element.price;
              stockSum += element.price - element.cost;
            }

            if (shintakuRelationalIds.contains(element.investId)) {
              shintakuCost += element.cost;
              shintakuPrice += element.price;
              shintakuSum += element.price - element.cost;
            }

            if (element.investId == 0) {
              goldCost += element.cost;
              goldPrice += element.price;
              goldSum += element.price - element.cost;
            }

            allCost += element.cost;
            allPrice += element.price;
            allSum += element.price - element.cost;
          }

          investPriceMap[key] = InvestPrice(
            stockCost: stockCost,
            stockPrice: stockPrice,
            stockSum: stockSum,
            shintakuCost: shintakuCost,
            shintakuPrice: shintakuPrice,
            shintakuSum: shintakuSum,
            goldCost: goldCost,
            goldPrice: goldPrice,
            goldSum: goldSum,
            allCost: allCost,
            allPrice: allPrice,
            allSum: allSum,
          );
        }
      }
    });
  }

  ///
  void setChartData() {
    final String selectedGraphName = ref.watch(totalGraphProvider
        .select((TotalGraphState value) => value.selectedGraphName));

    final List<String> graphInvestKind = <String>[];

    if (selectedGraphName == 'blank') {
      for (final InvestKind element in InvestKind.values) {
        graphInvestKind.add(element.name);
      }
    } else {
      graphInvestKind.add(selectedGraphName);
    }

    final List<FlSpot> flspotsStockCost = <FlSpot>[];
    final List<FlSpot> flspotsStockPrice = <FlSpot>[];
    final List<FlSpot> flspotsStockSum = <FlSpot>[];

    final List<FlSpot> flspotsShintakuCost = <FlSpot>[];
    final List<FlSpot> flspotsShintakuPrice = <FlSpot>[];
    final List<FlSpot> flspotsShintakuSum = <FlSpot>[];

    final List<FlSpot> flspotsGoldCost = <FlSpot>[];
    final List<FlSpot> flspotsGoldPrice = <FlSpot>[];
    final List<FlSpot> flspotsGoldSum = <FlSpot>[];

    final List<FlSpot> flspotsAllCost = <FlSpot>[];
    final List<FlSpot> flspotsAllPrice = <FlSpot>[];
    final List<FlSpot> flspotsAllSum = <FlSpot>[];

    final List<int> points = <int>[];

    int i = 0;
    investPriceMap.forEach((String key, InvestPrice value) {
      final List<int> values = <int>[];
      if (graphInvestKind.contains('stock')) {
        if (value.stockCost > 0 && value.stockPrice > 0) {
          values
            ..add(value.stockCost)
            ..add(value.stockPrice)
            ..add(value.stockSum);

          flspotsStockCost
              .add(FlSpot(i.toDouble(), value.stockCost.toDouble()));
          flspotsStockPrice
              .add(FlSpot(i.toDouble(), value.stockPrice.toDouble()));
          flspotsStockSum.add(FlSpot(i.toDouble(), value.stockSum.toDouble()));
        }
      }

      if (graphInvestKind.contains('shintaku')) {
        if (value.shintakuCost > 0 && value.shintakuPrice > 0) {
          values
            ..add(value.shintakuCost)
            ..add(value.shintakuPrice)
            ..add(value.shintakuSum);

          flspotsShintakuCost
              .add(FlSpot(i.toDouble(), value.shintakuCost.toDouble()));
          flspotsShintakuPrice
              .add(FlSpot(i.toDouble(), value.shintakuPrice.toDouble()));
          flspotsShintakuSum
              .add(FlSpot(i.toDouble(), value.shintakuSum.toDouble()));
        }
      }

      if (graphInvestKind.contains('gold')) {
        if (value.goldCost > 0 && value.goldPrice > 0) {
          values
            ..add(value.goldCost)
            ..add(value.goldPrice)
            ..add(value.goldSum);

          flspotsGoldCost.add(FlSpot(i.toDouble(), value.goldCost.toDouble()));
          flspotsGoldPrice
              .add(FlSpot(i.toDouble(), value.goldPrice.toDouble()));
          flspotsGoldSum.add(FlSpot(i.toDouble(), value.goldSum.toDouble()));
        }
      }

      if (graphInvestKind.contains('blank')) {
        if (value.allCost > 0 && value.allPrice > 0) {
          values
            ..add(value.allCost)
            ..add(value.allPrice)
            ..add(value.allSum);

          flspotsAllCost.add(FlSpot(i.toDouble(), value.allCost.toDouble()));
          flspotsAllPrice.add(FlSpot(i.toDouble(), value.allPrice.toDouble()));
          flspotsAllSum.add(FlSpot(i.toDouble(), value.allSum.toDouble()));
        }
      }

      values.forEach(points.add);

      i++;
    });

    if (points.isNotEmpty) {
      final int maxPoint = points.reduce(max);
      final int minPoint = points.reduce(min);

      final int addNum = (selectedGraphName == 'blank') ? 20 : 0;

      const int warisuu = 100000;
      final int graphYMax = ((maxPoint / warisuu).ceil() + addNum) * warisuu;
      final int graphYMin = (minPoint * -1 / warisuu).ceil() * warisuu * -1;

      /////////////////////////////////////////////////
      List<String> dispDateList = <String>[];

      final Map<String, List<String>> dispDateMap = <String, List<String>>{};
      final List<String> monthList = <String>[];

      for (final InvestRecord element in widget.investRecordList) {
        if (!dispDateList.contains(element.date)) {
          dispDateList.add(element.date);
        }

        final List<String> exDate = element.date.split('-');

        if (!monthList.contains(exDate[1])) {
          dispDateMap[exDate[1]] = <String>[];

          monthList.add(exDate[1]);
        }
      }

      for (final InvestRecord element in widget.investRecordList) {
        final List<String> exDate = element.date.split('-');

        if (dispDateMap[exDate[1]] != null) {
          if (!dispDateMap[exDate[1]]!.contains(element.date)) {
            dispDateMap[exDate[1]]?.add(element.date);
          }
        }
      }

      //=================

      final int selectedStartMonth = ref.watch(totalGraphProvider
          .select((TotalGraphState value) => value.selectedStartMonth));

      final int selectedEndMonth = ref.watch(totalGraphProvider
          .select((TotalGraphState value) => value.selectedEndMonth));

      if (selectedStartMonth > 0 && selectedEndMonth > 0) {
        dispDateList = <String>[];

        for (int i = selectedStartMonth; i <= selectedEndMonth; i++) {
          dispDateMap[i.toString().padLeft(2, '0')]
              ?.forEach((String element) => dispDateList.add(element));
        }
      } else if (selectedStartMonth > 0) {
        dispDateList = dispDateMap[selectedStartMonth.toString()] ?? <String>[];
      }

      /////////////////////////////////////////////////

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

                int i = 0;
                for (final LineBarSpot element in touchedSpots) {
                  final TextStyle textStyle = TextStyle(
                    color: element.bar.gradient?.colors.first ??
                        element.bar.color ??
                        Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );

                  final String price =
                      element.y.round().toString().split('.')[0].toCurrency();

                  final String day = dispDateList[element.x.toInt()];

                  final String dayStr = (i == 0) ? '$day\n' : '';

                  list.add(
                    LineTooltipItem('$dayStr$price', textStyle,
                        textAlign: TextAlign.end),
                  );

                  i++;
                }

                return list;
              }),
        ),

        ///
        titlesData: const FlTitlesData(
          //-------------------------// 上部の目盛り
          topTitles: AxisTitles(),
          //-------------------------// 上部の目盛り

          //-------------------------// 下部の目盛り
          bottomTitles: AxisTitles(),
          //-------------------------// 下部の目盛り

          //-------------------------// 左側の目盛り
          leftTitles: AxisTitles(),
          //-------------------------// 左側の目盛り

          //-------------------------// 右側の目盛り
          rightTitles: AxisTitles(),
          //-------------------------// 右側の目盛り
        ),

        ///
        lineBarsData: <LineChartBarData>[
          if (graphInvestKind.contains('stock')) ...<LineChartBarData>[
            LineChartBarData(
              spots: flspotsStockPrice,
              barWidth: 1,
              isStrokeCapRound: true,
              color: Colors.yellowAccent,
              dotData: const FlDotData(show: false),
            ),
            if (!graphInvestKind.contains('blank')) ...<LineChartBarData>[
              LineChartBarData(
                spots: flspotsStockCost,
                barWidth: 1,
                isStrokeCapRound: true,
                color: Colors.white,
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: flspotsStockSum,
                barWidth: 1,
                isStrokeCapRound: true,
                color: const Color(0xFFFBB6CE),
                dotData: const FlDotData(show: false),
              ),
            ],
          ],
          if (graphInvestKind.contains('shintaku')) ...<LineChartBarData>[
            LineChartBarData(
              spots: flspotsShintakuPrice,
              barWidth: 1,
              isStrokeCapRound: true,
              color: Colors.yellowAccent,
              dotData: const FlDotData(show: false),
            ),
            if (!graphInvestKind.contains('blank')) ...<LineChartBarData>[
              LineChartBarData(
                spots: flspotsShintakuCost,
                barWidth: 1,
                isStrokeCapRound: true,
                color: Colors.white,
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: flspotsShintakuSum,
                barWidth: 1,
                isStrokeCapRound: true,
                color: const Color(0xFFFBB6CE),
                dotData: const FlDotData(show: false),
              ),
            ],
          ],
          if (graphInvestKind.contains('gold')) ...<LineChartBarData>[
            LineChartBarData(
              spots: flspotsGoldPrice,
              barWidth: 1,
              isStrokeCapRound: true,
              color: Colors.yellowAccent,
              dotData: const FlDotData(show: false),
            ),
            if (!graphInvestKind.contains('blank')) ...<LineChartBarData>[
              LineChartBarData(
                spots: flspotsGoldCost,
                barWidth: 1,
                isStrokeCapRound: true,
                color: Colors.white,
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: flspotsGoldSum,
                barWidth: 1,
                isStrokeCapRound: true,
                color: const Color(0xFFFBB6CE),
                dotData: const FlDotData(show: false),
              ),
            ],
          ],
          if (graphInvestKind.contains('blank')) ...<LineChartBarData>[
            LineChartBarData(
              spots: flspotsAllPrice,
              barWidth: 3,
              isStrokeCapRound: true,
              color: Colors.white,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: flspotsAllSum,
              barWidth: 1,
              isStrokeCapRound: true,
              color: const Color(0xFFFBB6CE),
              dotData: const FlDotData(show: false),
            ),
          ],
        ],
      );

      graphData2 = LineChartData(
        maxY: graphYMax.toDouble(),
        minY: graphYMin.toDouble(),

        borderData: FlBorderData(show: false),

        ///
        lineTouchData: const LineTouchData(enabled: false),

        ///
        titlesData: FlTitlesData(
          //-------------------------// 上部の目盛り
          topTitles: const AxisTitles(),
          //-------------------------// 上部の目盛り

          //-------------------------// 下部の目盛り
          bottomTitles: const AxisTitles(),
          //-------------------------// 下部の目盛り

          //-------------------------// 左側の目盛り
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
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
  }
}
