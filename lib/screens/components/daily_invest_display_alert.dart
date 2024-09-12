// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
import '../../enum/invest_kind.dart';
import '../../extensions/extensions.dart';
import '../../repository/invest_records_repository.dart';
import '../../state/daily_invest_display/daily_invest_display.dart';
import '../../state/invest_graph/invest_graph.dart';
import 'invest_graph_alert.dart';
import 'invest_record_input_alert.dart';
import 'invest_record_list_alert.dart';
import 'parts/invest_dialog.dart';

class DailyInvestDisplayAlert extends ConsumerStatefulWidget {
  const DailyInvestDisplayAlert(
      {super.key,
      required this.date,
      required this.isar,
      required this.investNameList,
      required this.allInvestRecord,
      required this.calendarCellDateDataList,
      required this.totalPrice,
      required this.totalDiff});

  final DateTime date;
  final Isar isar;
  final List<InvestName> investNameList;
  final List<InvestRecord> allInvestRecord;
  final List<String> calendarCellDateDataList;
  final int totalPrice;
  final int totalDiff;

  ///
  @override
  ConsumerState<DailyInvestDisplayAlert> createState() =>
      _DailyInvestDisplayAlertState();
}

class _DailyInvestDisplayAlertState
    extends ConsumerState<DailyInvestDisplayAlert> {
  List<InvestRecord>? thisDayInvestRecordList = <InvestRecord>[];

  ///
  void _init() {
    _makeThisDayInvestRecordList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    Future(_init);

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(widget.date.yyyymmdd),
                  RichText(
                    text: TextSpan(
                      text: widget.totalPrice.toString().toCurrency(),
                      style: const TextStyle(color: Colors.yellowAccent),
                      children: <TextSpan>[
                        const TextSpan(
                            text: ' / ', style: TextStyle(color: Colors.white)),
                        TextSpan(
                          text: widget.totalDiff.toString().toCurrency(),
                          style: const TextStyle(color: Color(0xFFFBB6CE)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(child: _displayDailyInvest()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayDailyInvest() {
    final List<Widget> list = <Widget>[];

    final String selectedInvestName = ref.watch(
        dailyInvestDisplayProvider.select((DailyInvestDisplayState value) => value.selectedInvestName));

    for (final InvestKind element in InvestKind.values) {
      if (element.japanName != InvestKind.blank.japanName) {
        final List<InvestRecord>? dispInvestRecordGold = thisDayInvestRecordList
            ?.where((InvestRecord element4) => element4.investId == 0)
            .toList();

        //---------------------------------//

        int totalPrice = 0;
        int totalDiff = 0;

        final List<Widget> list2 = <Widget>[];
        widget.investNameList
            .where((InvestName element2) => element2.kind == element.name)
            .toList()
          ..sort((InvestName a, InvestName b) => a.dealNumber.compareTo(b.dealNumber))
          ..forEach((InvestName element3) {
            final List<InvestRecord>? dispInvestRecord = thisDayInvestRecordList
                ?.where((InvestRecord element4) => element4.investId == element3.id)
                .toList();

            list2.add(Container(
              width: context.screenSize.width,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.white.withOpacity(0.2), width: 2))),
              child: Column(
                children: <Widget>[
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    SizedBox(
                      width: 20,
                      child: Text(
                        element3.dealNumber.toString().padLeft(2, '0'),
                        style: const TextStyle(color: Colors.orangeAccent),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          element3.frame,
                          style: const TextStyle(color: Colors.lightBlueAccent),
                        ),
                        Text(
                          element3.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ))
                  ]),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topRight,
                              child: Text((dispInvestRecord != null &&
                                      dispInvestRecord.isNotEmpty)
                                  ? dispInvestRecord[0]
                                      .cost
                                      .toString()
                                      .toCurrency()
                                  : '0'),
                            ),
                            const Text(''),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                (dispInvestRecord != null &&
                                        dispInvestRecord.isNotEmpty)
                                    ? dispInvestRecord[0]
                                        .price
                                        .toString()
                                        .toCurrency()
                                    : '0',
                                style:
                                    const TextStyle(color: Colors.yellowAccent),
                              ),
                            ),
                            const Text(''),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                (dispInvestRecord != null &&
                                        dispInvestRecord.isNotEmpty)
                                    ? (dispInvestRecord[0].price -
                                            dispInvestRecord[0].cost)
                                        .toString()
                                        .toCurrency()
                                    : '0',
                                style:
                                    const TextStyle(color: Color(0xFFFBB6CE)),
                              ),
                            ),
                            Text(
                              (dispInvestRecord != null &&
                                      dispInvestRecord.isNotEmpty)
                                  ? '${((dispInvestRecord[0].price / dispInvestRecord[0].cost) * 100).toString().split('.')[0]} %'
                                  : '0',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              ref
                                  .read(dailyInvestDisplayProvider.notifier)
                                  .setSelectedInvestName(
                                      selectedInvestName: element3.name);

                              InvestDialog(
                                context: context,
                                widget: InvestRecordListAlert(
                                  investName: element3,
                                  allInvestRecord: widget.allInvestRecord,
                                ),
                                clearBarrierColor: true,
                              );
                            },
                            icon: Icon(Icons.info_outline,
                                color: (element3.name == selectedInvestName)
                                    ? Colors.redAccent.withOpacity(0.6)
                                    : Colors.greenAccent.withOpacity(0.6)),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          InvestDialog(
                            context: context,
                            widget: InvestRecordInputAlert(
                              isar: widget.isar,
                              date: widget.date,
                              investName: element3,
                              investRecord: thisDayInvestRecordList
                                  ?.where((InvestRecord element4) =>
                                      element4.investId == element3.id)
                                  .toList(),
                              allInvestRecord: widget.allInvestRecord,
                            ),
                            clearBarrierColor: true,
                          );
                        },
                        child: Icon(Icons.input,
                            color: Colors.greenAccent.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ],
              ),
            ));

            if (dispInvestRecord != null && dispInvestRecord.isNotEmpty) {
              totalPrice += dispInvestRecord[0].price;

              totalDiff += dispInvestRecord[0].price - dispInvestRecord[0].cost;
            }
          });
        //---------------------------------//

        list.add(Column(
          children: <Widget>[
            Container(
              width: context.screenSize.width,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                Colors.indigo.withOpacity(0.8),
                Colors.transparent
              ], stops: const <double>[
                0.7,
                1
              ])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(width: 60, child: Text(element.japanName)),
                      if (element.name != InvestKind.gold.name) ...<Widget>[
                        RichText(
                          text: TextSpan(
                            text: totalPrice.toString().toCurrency(),
                            style: const TextStyle(color: Colors.yellowAccent),
                            children: <TextSpan>[
                              const TextSpan(
                                  text: ' / ',
                                  style: TextStyle(color: Colors.white)),
                              TextSpan(
                                text: totalDiff.toString().toCurrency(),
                                style:
                                    const TextStyle(color: Color(0xFFFBB6CE)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      ref
                          .read(investGraphProvider.notifier)
                          .setWideGraphDisplay(flag: true);

                      ref
                          .read(investGraphProvider.notifier)
                          .setSelectedGraphId(id: 0);

                      ref
                          .read(investGraphProvider.notifier)
                          .setSelectedGraphName(name: '');

                      InvestDialog(
                        context: context,
                        widget: InvestGraphAlert(
                          kind: element.name,
                          investNameList: widget.investNameList,
                          allInvestRecord: widget.allInvestRecord,
                          calendarCellDateDataList:
                              widget.calendarCellDateDataList,
                        ),
                        clearBarrierColor: true,
                      );
                    },
                    child: Icon(Icons.graphic_eq,
                        color: Colors.white.withOpacity(0.6), size: 20),
                  ),
                ],
              ),
            ),

            ///////////////////// GOLD
            if (element.name == InvestKind.gold.name) ...<Widget>[
              Container(
                width: context.screenSize.width,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.white.withOpacity(0.2), width: 2))),
                child: Column(
                  children: <Widget>[
                    const Row(children: <Widget>[
                      SizedBox(
                        width: 30,
                        child: Text(
                          '01',
                          style: TextStyle(color: Colors.orangeAccent),
                        ),
                      ),
                      Expanded(
                          child: Text('gold',
                              maxLines: 1, overflow: TextOverflow.ellipsis))
                    ]),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topRight,
                                child: Text((dispInvestRecordGold != null &&
                                        dispInvestRecordGold.isNotEmpty)
                                    ? dispInvestRecordGold[0]
                                        .cost
                                        .toString()
                                        .toCurrency()
                                    : '0'),
                              ),
                              const Text(''),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topRight,
                                child: Text(
                                  (dispInvestRecordGold != null &&
                                          dispInvestRecordGold.isNotEmpty)
                                      ? dispInvestRecordGold[0]
                                          .price
                                          .toString()
                                          .toCurrency()
                                      : '0',
                                  style: const TextStyle(
                                      color: Colors.yellowAccent),
                                ),
                              ),
                              const Text(''),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topRight,
                                child: Text(
                                  (dispInvestRecordGold != null &&
                                          dispInvestRecordGold.isNotEmpty)
                                      ? (dispInvestRecordGold[0].price -
                                              dispInvestRecordGold[0].cost)
                                          .toString()
                                          .toCurrency()
                                      : '0',
                                  style:
                                      const TextStyle(color: Color(0xFFFBB6CE)),
                                ),
                              ),
                              Text(
                                (dispInvestRecordGold != null &&
                                        dispInvestRecordGold.isNotEmpty)
                                    ? '${((dispInvestRecordGold[0].price / dispInvestRecordGold[0].cost) * 100).toString().split('.')[0]} %'
                                    : '0',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            InvestDialog(
                              context: context,
                              widget: InvestRecordInputAlert(
                                isar: widget.isar,
                                date: widget.date,
                                investRecord: thisDayInvestRecordList
                                    ?.where(
                                        (InvestRecord element4) => element4.investId == 0)
                                    .toList(),
                                allInvestRecord: widget.allInvestRecord,
                                investName: InvestName()
                                  ..id = 0
                                  ..kind = InvestKind.gold.name
                                  ..name = 'gold',
                              ),
                              clearBarrierColor: true,
                            );
                          },
                          child: Icon(Icons.input,
                              color: Colors.greenAccent.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            ///////////////////// GOLD

            if (element.name != InvestKind.gold.name) ...<Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: list2),
            ],
          ],
        ));
      }
    }

    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: list));
  }

  ///
  Future<void> _makeThisDayInvestRecordList() async => InvestRecordsRepository()
      .getInvestRecordListByDate(isar: widget.isar, date: widget.date.yyyymmdd)
      .then((List<InvestRecord>? value) => setState(() => thisDayInvestRecordList = value));
}
