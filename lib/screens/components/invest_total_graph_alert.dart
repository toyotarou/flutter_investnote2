import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invest_note/collections/invest_name.dart';
import 'package:invest_note/collections/invest_record.dart';
import 'package:invest_note/enum/invest_kind.dart';
import 'package:invest_note/extensions/extensions.dart';
import 'package:invest_note/model/invest_price.dart';
import 'package:invest_note/state/total_graph/total_graph.dart';
import 'package:isar/isar.dart';

class InvestTotalGraphAlert extends ConsumerStatefulWidget {
  const InvestTotalGraphAlert({
    super.key,
    required this.isar,
    required this.investNameList,
    required this.investRecordMap,
  });

  final Isar isar;
  final List<InvestName> investNameList;
  final Map<String, List<InvestRecord>> investRecordMap;

  @override
  ConsumerState<InvestTotalGraphAlert> createState() =>
      _InvestTotalGraphAlertState();
}

class _InvestTotalGraphAlertState extends ConsumerState<InvestTotalGraphAlert> {
  Map<String, InvestPrice> investPriceMap = {};

  LineChartData graphData = LineChartData();
  LineChartData graphData2 = LineChartData();

  ///
  @override
  Widget build(BuildContext context) {
    makeGraphData();

    setChartData();

    final selectedGraphName = ref
        .watch(totalGraphProvider.select((value) => value.selectedGraphName));

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: [
          Column(
            children: [
              Container(height: 70),
              Expanded(child: LineChart(graphData2)),
            ],
          ),
          SizedBox(
            width: context.screenSize.width * 0.65,
            height: context.screenSize.height - 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: context.screenSize.width),
                SizedBox(
                  height: 50,
                  child: Row(
                      children: InvestKind.values.map((e) {
                    return Row(
                      children: [
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  void makeGraphData() {
    final stockIds = <int>[];
    final shintakuIds = <int>[];

    widget.investNameList.forEach((element) {
      if (element.kind == InvestKind.stock.name) {
        stockIds.add(element.id);
      }

      if (element.kind == InvestKind.shintaku.name) {
        shintakuIds.add(element.id);
      }
    });

    widget.investRecordMap.forEach((key, value) {
      var stockCost = 0;
      var stockPrice = 0;
      var stockSum = 0;

      var shintakuCost = 0;
      var shintakuPrice = 0;
      var shintakuSum = 0;

      var goldCost = 0;
      var goldPrice = 0;
      var goldSum = 0;

      var allCost = 0;
      var allPrice = 0;
      var allSum = 0;

      value.forEach((element) {
        if (stockIds.contains(element.investId)) {
          stockCost += element.cost;
          stockPrice += element.price;
          stockSum += element.price - element.cost;
        }

        if (shintakuIds.contains(element.investId)) {
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
      });

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
    });
  }

  ///
  void setChartData() {
    final selectedGraphName = ref
        .watch(totalGraphProvider.select((value) => value.selectedGraphName));

    final graphInvestKind = <String>[];

    if (selectedGraphName == 'blank') {
      InvestKind.values.forEach((element) => graphInvestKind.add(element.name));
    } else {
      graphInvestKind.add(selectedGraphName);
    }

    final flspotsStockCost = <FlSpot>[];
    final flspotsStockPrice = <FlSpot>[];
    final flspotsStockSum = <FlSpot>[];

    final flspotsShintakuCost = <FlSpot>[];
    final flspotsShintakuPrice = <FlSpot>[];
    final flspotsShintakuSum = <FlSpot>[];

    final flspotsGoldCost = <FlSpot>[];
    final flspotsGoldPrice = <FlSpot>[];
    final flspotsGoldSum = <FlSpot>[];

    final flspotsAllCost = <FlSpot>[];
    final flspotsAllPrice = <FlSpot>[];
    final flspotsAllSum = <FlSpot>[];

    final points = <int>[];

    var i = 0;
    investPriceMap.forEach((key, value) {
      final values = <int>[];
      if (graphInvestKind.contains('stock')) {
        values
          ..add(value.stockCost)
          ..add(value.stockPrice)
          ..add(value.stockSum);

        flspotsStockCost.add(FlSpot(i.toDouble(), value.stockCost.toDouble()));
        flspotsStockPrice
            .add(FlSpot(i.toDouble(), value.stockPrice.toDouble()));
        flspotsStockSum.add(FlSpot(i.toDouble(), value.stockSum.toDouble()));
      }

      if (graphInvestKind.contains('shintaku')) {
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

      if (graphInvestKind.contains('gold')) {
        values
          ..add(value.goldCost)
          ..add(value.goldPrice)
          ..add(value.goldSum);

        flspotsGoldCost.add(FlSpot(i.toDouble(), value.goldCost.toDouble()));
        flspotsGoldPrice.add(FlSpot(i.toDouble(), value.goldPrice.toDouble()));
        flspotsGoldSum.add(FlSpot(i.toDouble(), value.goldSum.toDouble()));
      }

      if (graphInvestKind.contains('blank')) {
        values
          ..add(value.allCost)
          ..add(value.allPrice)
          ..add(value.allSum);

        flspotsAllCost.add(FlSpot(i.toDouble(), value.allCost.toDouble()));
        flspotsAllPrice.add(FlSpot(i.toDouble(), value.allPrice.toDouble()));
        flspotsAllSum.add(FlSpot(i.toDouble(), value.allSum.toDouble()));
      }

      values.forEach(points.add);

      i++;
    });

    final maxPoint = points.reduce(max);
    final minPoint = points.reduce(min);

    const warisuu = 1000;
    final graphYMax = (maxPoint / warisuu).ceil() * warisuu;
    final graphYMin = (minPoint * -1 / warisuu).ceil() * warisuu * -1;

    graphData = LineChartData(
      maxY: graphYMax.toDouble(),
      minY: graphYMin.toDouble(),

      borderData: FlBorderData(show: false),

      ///
      lineTouchData: const LineTouchData(enabled: false),

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
      lineBarsData: [
        if (graphInvestKind.contains('stock')) ...[
          LineChartBarData(
            spots: flspotsStockPrice,
            barWidth: 1,
            isStrokeCapRound: true,
            color: Colors.yellowAccent,
            dotData: const FlDotData(show: false),
          ),
          if (!graphInvestKind.contains('blank')) ...[
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
        if (graphInvestKind.contains('shintaku')) ...[
          LineChartBarData(
            spots: flspotsShintakuPrice,
            barWidth: 1,
            isStrokeCapRound: true,
            color: Colors.yellowAccent,
            dotData: const FlDotData(show: false),
          ),
          if (!graphInvestKind.contains('blank')) ...[
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
        if (graphInvestKind.contains('gold')) ...[
          LineChartBarData(
            spots: flspotsGoldPrice,
            barWidth: 1,
            isStrokeCapRound: true,
            color: Colors.yellowAccent,
            dotData: const FlDotData(show: false),
          ),
          if (!graphInvestKind.contains('blank')) ...[
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
        if (graphInvestKind.contains('blank')) ...[
          LineChartBarData(
            spots: flspotsAllPrice,
            barWidth: 3,
            isStrokeCapRound: true,
            color: Colors.white,
            dotData: const FlDotData(show: false),
          ),
          // LineChartBarData(
          //   spots: flspotsAllCost,
          //   barWidth: 1,
          //   isStrokeCapRound: true,
          //   color: Colors.white,
          //   dotData: const FlDotData(show: false),
          // ),
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
            getTitlesWidget: (value, meta) {
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
      lineBarsData: [],
    );
  }
}
