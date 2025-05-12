import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../../collections/invest_name.dart';
import '../../../collections/invest_record.dart';
import '../../../extensions/extensions.dart';
import '../../home_screen.dart';
import '../invest_cost_info_alert.dart';
import '../invest_cost_total_list_alert.dart';
import '../parts/invest_dialog.dart';

class InvestResultListPage extends StatefulWidget {
  const InvestResultListPage({
    super.key,
    required this.isar,
    required this.investRecordMap,
    required this.year,
    required this.investItemRecordMap,
    required this.investNameList,
    required this.investRecordList,
    required this.configMap,
  });

  final Isar isar;
  final Map<String, List<InvestRecord>> investRecordMap;
  final int year;
  final Map<int, List<InvestRecord>> investItemRecordMap;
  final List<InvestName> investNameList;
  final List<InvestRecord> investRecordList;
  final Map<String, String> configMap;

  @override
  State<InvestResultListPage> createState() => _InvestResultListPageState();
}

class _InvestResultListPageState extends State<InvestResultListPage> {
  int totalCost = 0;
  int totalPrice = 0;
  int totalDiff = 0;

  bool firstPriceSetted = false;
  int firstCost = 0;
  int firstPrice = 0;

  ///
  @override
  Widget build(BuildContext context) {
    if (!firstPriceSetted) {
      firstCost = (widget.configMap['startCostStock'] ?? '0').toInt() +
          (widget.configMap['startCostShintaku'] ?? '0').toInt() +
          (widget.configMap['startCostGold'] ?? '0').toInt();

      firstPrice = (widget.configMap['startPriceStock'] ?? '0').toInt() +
          (widget.configMap['startPriceShintaku'] ?? '0').toInt() +
          (widget.configMap['startPriceGold'] ?? '0').toInt();

      firstPriceSetted = true;
    }

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
              Expanded(child: _displayInvestResultList()),
              Divider(
                color: Colors.white.withOpacity(0.1),
                thickness: 5,
              ),
              SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        InvestDialog(
                          context: context,
                          widget: InvestCostTotalListAlert(
                            year: widget.year,
                            investItemRecordMap: widget.investItemRecordMap,
                            investNameList: widget.investNameList,
                            investRecordList: widget.investRecordList,
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          const SizedBox(width: 10),
                          Icon(FontAwesomeIcons.expand, color: Colors.white.withValues(alpha: 0.4)),
                          const SizedBox(width: 10),
                          const Text('cost'),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(totalCost.toString().toCurrency()),
                            Text(
                              totalPrice.toString().toCurrency(),
                              style: const TextStyle(color: Colors.yellowAccent),
                            ),
                            Text(
                              totalDiff.toString().toCurrency(),
                              style: const TextStyle(color: Color(0xFFFBB6CE)),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayInvestResultList() {
    final List<Widget> list = <Widget>[];

    final Map<String, int> costMap = <String, int>{};
    final Map<String, int> priceMap = <String, int>{};

    final List<String> yearmonthList = <String>[];
    widget.investRecordMap.forEach((String key, List<InvestRecord> value) {
      final List<String> exKey = key.split('-');

      int cost = 0;
      int price = 0;

      for (final InvestRecord element in value) {
        cost += element.cost;
        price += element.price;
      }

      costMap[key] = cost;
      priceMap[key] = price;

      final String yearmonth = '${exKey[0]}-${exKey[1]}';

      if (!yearmonthList.contains(yearmonth)) {
        yearmonthList.add(yearmonth);
      }
    });

    int tCost = 0;
    int tPrice = 0;
    int tDiff = 0;

    for (final String element in yearmonthList) {
      if (element.split('-')[0].toInt() == widget.year) {
        final int startCost = getStartCost(yearmonth: element, costMap: costMap);

        int endCost = 0;
        costMap.forEach((String key, int value) {
          final List<String> exKey = key.split('-');

          if ('${exKey[0]}-${exKey[1]}' == element) {
            endCost = value;
          }
        });

        final int startPrice = getStartPrice(yearmonth: element, priceMap: priceMap);

        int endPrice = 0;
        priceMap.forEach((String key, int value) {
          final List<String> exKey = key.split('-');
          if ('${exKey[0]}-${exKey[1]}' == element) {
            endPrice = value;
          }
        });

        list.add(Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
          ),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Container(), Text(element)],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);

                        Navigator.pushReplacement(
                          context,
                          // ignore: inference_failure_on_instance_creation, always_specify_types
                          MaterialPageRoute(
                            builder: (BuildContext context) => HomeScreen(isar: widget.isar, baseYm: element),
                          ),
                        );
                      },
                      child: CircleAvatar(radius: 10, backgroundColor: Colors.greenAccent.withOpacity(0.4)),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(startCost.toString().toCurrency()),
                        Text(
                          startPrice.toString().toCurrency(),
                          style: const TextStyle(color: Colors.yellowAccent),
                        ),
                        Text(
                          (startPrice - startCost).toString().toCurrency(),
                          style: const TextStyle(color: Color(0xFFFBB6CE)),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(endCost.toString().toCurrency()),
                        Text(
                          endPrice.toString().toCurrency(),
                          style: const TextStyle(color: Colors.yellowAccent),
                        ),
                        Text(
                          (endPrice - endCost).toString().toCurrency(),
                          style: const TextStyle(color: Color(0xFFFBB6CE)),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(width: 10),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
                                alignment: Alignment.topRight,
                                child: Text((endCost - startCost).toString().toCurrency()),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          (endPrice - startPrice).toString().toCurrency(),
                          style: const TextStyle(color: Colors.yellowAccent),
                        ),
                        Text(
                          ((endPrice - endCost) - (startPrice - startCost)).toString().toCurrency(),
                          style: const TextStyle(color: Color(0xFFFBB6CE)),
                        ),
                      ],
                    )),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        InvestDialog(
                          context: context,
                          widget: InvestCostInfoAlert(
                            yearmonth: element,
                            cost: endCost - startCost,
                            investItemRecordMap: widget.investItemRecordMap,
                            investNameList: widget.investNameList,
                            investRecordList: widget.investRecordList,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white.withOpacity(0.4)),
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: const Text('cost'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));

        tCost += endCost - startCost;
        tPrice += endPrice - startPrice;
        tDiff += (endPrice - endCost) - (startPrice - startCost);
      }
    }

    setState(() {
      totalCost = tCost;
      totalPrice = tPrice;
      totalDiff = tDiff;
    });

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) => list[index], childCount: list.length),
        ),
      ],
    );
  }

  int getStartCost({required String yearmonth, required Map<String, int> costMap}) {
    final InvestRecord investRecordListFirst = widget.investRecordList.first;
    final String firstYearMonth =
        '${investRecordListFirst.date.split('-')[0]}-${investRecordListFirst.date.split('-')[1]}';

    if (yearmonth == firstYearMonth) {
      return firstCost;
    } else {
      final DateTime prevYearMonth = DateTime(yearmonth.split('-')[0].toInt(), yearmonth.split('-')[1].toInt(), 0);

      final List<int> costList = <int>[];

      costMap.forEach((String key, int value) {
        final List<String> exKey = key.split('-');

        if ('${exKey[0]}-${exKey[1]}' == prevYearMonth.yyyymm) {
          costList.add(value);
        }
      });

      return costList.last;
    }
  }

  ///
  int getStartPrice({required String yearmonth, required Map<String, int> priceMap}) {
    final InvestRecord investRecordListFirst = widget.investRecordList.first;
    final String firstYearMonth =
        '${investRecordListFirst.date.split('-')[0]}-${investRecordListFirst.date.split('-')[1]}';

    if (yearmonth == firstYearMonth) {
      return firstPrice;
    } else {
      final DateTime prevYearMonth = DateTime(yearmonth.split('-')[0].toInt(), yearmonth.split('-')[1].toInt(), 0);

      final List<int> priceList = <int>[];

      priceMap.forEach((String key, int value) {
        final List<String> exKey = key.split('-');

        if ('${exKey[0]}-${exKey[1]}' == prevYearMonth.yyyymm) {
          priceList.add(value);
        }
      });

      return priceList.last;
    }
  }
}
