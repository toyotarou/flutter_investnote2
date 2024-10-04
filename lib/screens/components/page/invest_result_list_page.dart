import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../../collections/invest_record.dart';
import '../../../extensions/extensions.dart';
import '../../home_screen.dart';

class InvestResultListPage extends StatefulWidget {
  const InvestResultListPage({
    super.key,
    required this.isar,
    required this.investRecordMap,
    required this.year,
  });

  final Isar isar;
  final Map<String, List<InvestRecord>> investRecordMap;
  final int year;

  @override
  State<InvestResultListPage> createState() => _InvestResultListPageState();
}

class _InvestResultListPageState extends State<InvestResultListPage> {
  int totalCost = 0;
  int totalPrice = 0;
  int totalDiff = 0;

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
                    Container(),
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(totalCost.toString().toCurrency()),
                            Text(
                              totalPrice.toString().toCurrency(),
                              style:
                                  const TextStyle(color: Colors.yellowAccent),
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

      if (exKey[0].toInt() == widget.year) {
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
      }
    });

    int tCost = 0;
    int tPrice = 0;
    int tDiff = 0;

    for (final String element in yearmonthList) {
      int startCost = 0;
      int endCost = 0;
      costMap.forEach((String key, int value) {
        final List<String> exKey = key.split('-');

        if ('${exKey[0]}-${exKey[1]}' == element) {
          if (startCost == 0) {
            startCost = value;
          }

          endCost = value;
        }
      });

      int startPrice = 0;
      int endPrice = 0;
      priceMap.forEach((String key, int value) {
        final List<String> exKey = key.split('-');
        if ('${exKey[0]}-${exKey[1]}' == element) {
          if (startPrice == 0) {
            startPrice = value;
          }

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);

                  Navigator.pushReplacement(
                    context,
                    // ignore: inference_failure_on_instance_creation, always_specify_types
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen(
                        isar: widget.isar,
                        baseYm: element,
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.greenAccent.withOpacity(0.4),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(child: Text(element)),
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
                  Text((endCost - startCost).toString().toCurrency()),
                  Text(
                    (endPrice - startPrice).toString().toCurrency(),
                    style: const TextStyle(color: Colors.yellowAccent),
                  ),
                  Text(
                    ((endPrice - endCost) - (startPrice - startCost))
                        .toString()
                        .toCurrency(),
                    style: const TextStyle(color: Color(0xFFFBB6CE)),
                  ),
                ],
              )),
            ],
          ),
        ),
      ));

      tCost += endCost - startCost;
      tPrice += endPrice - startPrice;
      tDiff += (endPrice - endCost) - (startPrice - startCost);
    }

    setState(() {
      totalCost = tCost;
      totalPrice = tPrice;
      totalDiff = tDiff;
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
}
