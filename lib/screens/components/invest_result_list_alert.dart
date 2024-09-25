import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../collections/invest_record.dart';
import '../../extensions/extensions.dart';
import '../home_screen.dart';

class InvestResultListAlert extends StatefulWidget {
  const InvestResultListAlert({
    super.key,
    required this.isar,
    required this.investRecordMap,
  });

  final Isar isar;
  final Map<String, List<InvestRecord>> investRecordMap;

  @override
  State<InvestResultListAlert> createState() => _InvestResultListAlertState();
}

class _InvestResultListAlertState extends State<InvestResultListAlert> {
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
              // Text(widget.investName.name),
              // Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              // const SizedBox(height: 10),
              // SizedBox(height: 150, child: LineChart(graphData)),
              // const SizedBox(height: 20),

              Expanded(child: _displayInvestResultList()),
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
      int cost = 0;
      int price = 0;

      for (final InvestRecord element in value) {
        cost += element.cost;
        price += element.price;
      }

      costMap[key] = cost;
      priceMap[key] = price;

      final List<String> exKey = key.split('-');

      final String yearmonth = '${exKey[0]}-${exKey[1]}';

      if (!yearmonthList.contains(yearmonth)) {
        yearmonthList.add(yearmonth);
      }
    });

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
}
