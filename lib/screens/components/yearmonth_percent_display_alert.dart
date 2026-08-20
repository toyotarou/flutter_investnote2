import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../collections/invest_record.dart';
import '../../extensions/extensions.dart';

class YearmonthPercentDisplayAlert extends ConsumerStatefulWidget {
  const YearmonthPercentDisplayAlert({
    super.key,
    required this.investRecordList,
    required this.investRecordMap,
    required this.configMap,
  });

  final List<InvestRecord> investRecordList;
  final Map<String, List<InvestRecord>> investRecordMap;
  final Map<String, String> configMap;

  @override
  ConsumerState<YearmonthPercentDisplayAlert> createState() => _YearmonthPercentDisplayAlertState();
}

class _YearmonthPercentDisplayAlertState extends ConsumerState<YearmonthPercentDisplayAlert> {
  int _firstCost = 0;
  int _firstPrice = 0;
  bool _firstSetted = false;
  String _firstYearMonth = '';

  ///
  @override
  Widget build(BuildContext context) {
    if (!_firstSetted) {
      _firstCost = (widget.configMap['startCostStock'] ?? '0').toInt() +
          (widget.configMap['startCostShintaku'] ?? '0').toInt() +
          (widget.configMap['startCostGold'] ?? '0').toInt();

      _firstPrice = (widget.configMap['startPriceStock'] ?? '0').toInt() +
          (widget.configMap['startPriceShintaku'] ?? '0').toInt() +
          (widget.configMap['startPriceGold'] ?? '0').toInt();

      if (widget.investRecordList.isNotEmpty) {
        final InvestRecord first = widget.investRecordList.first;
        final List<String> exDate = first.date.split('-');
        _firstYearMonth = '${exDate[0]}-${exDate[1]}';
      }

      _firstSetted = true;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: _buildList(),
        ),
      ),
    );
  }

  ///
  Widget _buildList() {
    // 日付別 cost/price を集計
    final Map<String, int> costMap = <String, int>{};
    final Map<String, int> priceMap = <String, int>{};
    final List<String> yearmonthList = <String>[];

    widget.investRecordMap.forEach((String key, List<InvestRecord> records) {
      final List<String> exKey = key.split('-');
      int cost = 0;
      int price = 0;
      for (final InvestRecord r in records) {
        cost += r.cost;
        price += r.price;
      }
      costMap[key] = cost;
      priceMap[key] = price;

      final String ym = '${exKey[0]}-${exKey[1]}';
      if (!yearmonthList.contains(ym)) {
        yearmonthList.add(ym);
      }
    });

    // 降順ソート（新しい月が上）
    yearmonthList.sort((String a, String b) => b.compareTo(a));

    // 月ごとの start/end を収集
    final Map<String, int> monthStartCost = <String, int>{};
    final Map<String, int> monthStartPrice = <String, int>{};
    final Map<String, int> monthEndCost = <String, int>{};
    final Map<String, int> monthEndPrice = <String, int>{};

    for (final String ym in yearmonthList) {
      monthStartCost[ym] = _getStartCost(yearmonth: ym, costMap: costMap);
      monthStartPrice[ym] = _getStartPrice(yearmonth: ym, priceMap: priceMap);

      int endCost = 0;
      costMap.forEach((String key, int value) {
        final List<String> exKey = key.split('-');
        if ('${exKey[0]}-${exKey[1]}' == ym) {
          endCost = value;
        }
      });
      monthEndCost[ym] = endCost;

      int endPrice = 0;
      priceMap.forEach((String key, int value) {
        final List<String> exKey = key.split('-');
        if ('${exKey[0]}-${exKey[1]}' == ym) {
          endPrice = value;
        }
      });
      monthEndPrice[ym] = endPrice;
    }

    // 年ごとにグループ化して年間リターンを計算
    // (yearmonthList は降順なので groups[year][0] = 最新月, groups[year].last = 最古月)
    final Map<String, List<String>> yearGroups = <String, List<String>>{};
    for (final String ym in yearmonthList) {
      final String year = ym.split('-')[0];
      yearGroups.putIfAbsent(year, () => <String>[]).add(ym);
    }

    final Map<String, double> yearPercentMap = <String, double>{};
    final Map<String, int> yearEndProfitMap = <String, int>{};
    yearGroups.forEach((String year, List<String> months) {
      final String latest = months[0];
      final String earliest = months.last;
      final int yEndCost = monthEndCost[latest] ?? 0;
      final int yEndPrice = monthEndPrice[latest] ?? 0;
      final int yStartCost = monthStartCost[earliest] ?? 0;
      final int yStartPrice = monthStartPrice[earliest] ?? 0;
      final int yProfitDiff = (yEndPrice - yEndCost) - (yStartPrice - yStartCost);
      yearPercentMap[year] = yEndPrice > 0 ? (yProfitDiff / yEndPrice) * 100 : 0.0;
      yearEndProfitMap[year] = yEndPrice - yEndCost;
    });

    final String currentYear = yearmonthList.isNotEmpty ? yearmonthList[0].split('-')[0] : '';

    final List<Widget> rows = <Widget>[];
    bool isFirst = true;

    for (final String ym in yearmonthList) {
      final String year = ym.split('-')[0];
      final String month = ym.split('-')[1];

      final int startCost = monthStartCost[ym] ?? 0;
      final int startPrice = monthStartPrice[ym] ?? 0;
      final int endCost = monthEndCost[ym] ?? 0;
      final int endPrice = monthEndPrice[ym] ?? 0;
      final int costDiff = endCost - startCost;
      final int priceDiff = endPrice - startPrice;
      final int profitDiff = (endPrice - endCost) - (startPrice - startCost);
      final double priceDiffPercent = endPrice > 0 ? (profitDiff / endPrice) * 100 : 0.0;

      if (isFirst) {
        // リスト最上に今年のYTD年間バッジを挿入
        rows.add(_buildYearBadge(
          year: year,
          percent: yearPercentMap[year] ?? 0.0,
          isCurrent: true,
          yearEndProfit: yearEndProfitMap[year] ?? 0,
        ));
        isFirst = false;
      } else if (month == '12' && year != currentYear) {
        // 前年以前の12月の上に年間バッジを挿入
        rows.add(_buildYearBadge(
          year: year,
          percent: yearPercentMap[year] ?? 0.0,
          isCurrent: false,
          yearEndProfit: yearEndProfitMap[year] ?? 0,
        ));
      }

      rows.add(_buildRow(
        yearmonth: ym,
        endCost: endCost,
        endPrice: endPrice,
        costDiff: costDiff,
        priceDiff: priceDiff,
        priceDiffPercent: priceDiffPercent,
      ));
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => rows[index],
            childCount: rows.length,
          ),
        ),
      ],
    );
  }

  ///
  Widget _buildYearBadge({
    required String year,
    required double percent,
    required bool isCurrent,
    required int yearEndProfit,
  }) {
    final Color color = percent >= 0 ? Colors.greenAccent : Colors.redAccent;
    final String sign = percent >= 0 ? '+' : '';
    final String profitSign = yearEndProfit >= 0 ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.25)),
        ),
      ),
      child: Row(
        children: <Widget>[
          Text(
            '$year年${isCurrent ? ' (YTD)' : ''}',
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$sign${percent.toStringAsFixed(2)}%',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$profitSign${yearEndProfit.toString().toCurrency()}',
            style: const TextStyle(
              color: Color(0xFFFBB6CE),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _buildRow({
    required String yearmonth,
    required int endCost,
    required int endPrice,
    required int costDiff,
    required int priceDiff,
    required double priceDiffPercent,
  }) {
    final Color costColor = costDiff >= 0 ? Colors.lightBlueAccent : Colors.orangeAccent;
    final Color priceColor = priceDiff >= 0 ? Colors.greenAccent : Colors.redAccent;
    final Color badgeColor = priceDiffPercent >= 0 ? Colors.greenAccent : Colors.redAccent;
    final String priceSign = priceDiff >= 0 ? '+' : '';
    final String percentSign = priceDiffPercent >= 0 ? '+' : '';
    final int endProfit = endPrice - endCost;
    final String profitSign = endProfit >= 0 ? '+' : '';
    final int monthProfit = priceDiff - costDiff;
    final String monthProfitSign = monthProfit >= 0 ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.12)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ── 上段1行目：年月 + cost + total + バッジ ──
          Row(
            children: <Widget>[
              SizedBox(
                width: 65,
                child: Text(yearmonth, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ),
              const Spacer(),
              // cost増加
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  const Text('cost', style: TextStyle(color: Colors.white38, fontSize: 9)),
                  Text(
                    costDiff.toString().toCurrency(),
                    style: TextStyle(color: costColor, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // total増加
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  const Text('total', style: TextStyle(color: Colors.white38, fontSize: 9)),
                  Text(
                    '$priceSign${priceDiff.toString().toCurrency()}',
                    style: TextStyle(color: priceColor, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              // 楕円バッジ（全体比 %）
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: badgeColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$percentSign${priceDiffPercent.toStringAsFixed(2)}%',
                  style: TextStyle(color: badgeColor, fontSize: 11),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),

          const SizedBox(height: 4),

          // ── 上段2行目：月差額（profit）右寄せ ──
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Text('profit', style: TextStyle(color: Colors.white38, fontSize: 9)),
              const SizedBox(width: 6),
              Text(
                '$monthProfitSign${monthProfit.toString().toCurrency()}',
                style: const TextStyle(color: Color(0xFFFBB6CE), fontSize: 12),
              ),
              const SizedBox(width: 4),
            ],
          ),

          const SizedBox(height: 4),

          // ── 下段：月末累計 ──
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Text('累計', style: TextStyle(color: Colors.white24, fontSize: 10)),
              const SizedBox(width: 8),
              Text(
                endCost.toString().toCurrency(),
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
              const SizedBox(width: 16),
              Text(
                endPrice.toString().toCurrency(),
                style: const TextStyle(color: Colors.yellowAccent, fontSize: 11),
              ),
              const SizedBox(width: 12),
              Text(
                '$profitSign${endProfit.toString().toCurrency()}',
                style: const TextStyle(color: Color(0xFFFBB6CE), fontSize: 11),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ],
      ),
    );
  }

  ///
  int _getStartCost({required String yearmonth, required Map<String, int> costMap}) {
    if (yearmonth == _firstYearMonth) {
      return _firstCost;
    }

    final DateTime prevYearMonth = DateTime(
      yearmonth.split('-')[0].toInt(),
      yearmonth.split('-')[1].toInt(),
      0,
    );

    final List<int> costList = <int>[];
    costMap.forEach((String key, int value) {
      final List<String> exKey = key.split('-');
      if ('${exKey[0]}-${exKey[1]}' == prevYearMonth.yyyymm) {
        costList.add(value);
      }
    });

    return costList.isNotEmpty ? costList.last : 0;
  }

  ///
  int _getStartPrice({required String yearmonth, required Map<String, int> priceMap}) {
    if (yearmonth == _firstYearMonth) {
      return _firstPrice;
    }

    final DateTime prevYearMonth = DateTime(
      yearmonth.split('-')[0].toInt(),
      yearmonth.split('-')[1].toInt(),
      0,
    );

    final List<int> priceList = <int>[];
    priceMap.forEach((String key, int value) {
      final List<String> exKey = key.split('-');
      if ('${exKey[0]}-${exKey[1]}' == prevYearMonth.yyyymm) {
        priceList.add(value);
      }
    });

    return priceList.isNotEmpty ? priceList.last : 0;
  }
}
