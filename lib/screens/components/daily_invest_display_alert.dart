import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';

import '../../controllers/controllers_mixin.dart';
import '../../enum/invest_kind.dart';
import '../../extensions/extensions.dart';
import '../../repository/invest_records_repository.dart';

import 'fund_list_alert.dart';
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
  ConsumerState<DailyInvestDisplayAlert> createState() => _DailyInvestDisplayAlertState();
}

class _DailyInvestDisplayAlertState extends ConsumerState<DailyInvestDisplayAlert>
    with ControllersMixin<DailyInvestDisplayAlert> {
  List<InvestRecord>? thisDayInvestRecordList = <InvestRecord>[];

  Map<int, Map<String, InvestRecord>> investGrowthRateDataMap = <int, Map<String, InvestRecord>>{};

  Map<int, Map<String, dynamic>> investRatingDataMap = <int, Map<String, dynamic>>{};

  ///
  @override
  void initState() {
    super.initState();

    makeInvestGrowthRateData();

    toushiShintakuNotifier.getAllToushiShintaku();
  }

  ///
  void _init() {
    _makeThisDayInvestRecordList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    Future(_init);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(widget.date.yyyymmdd),
                  RichText(
                    text: TextSpan(
                      text: widget.totalPrice.toString().toCurrency(),
                      style: const TextStyle(color: Colors.yellowAccent),
                      children: <TextSpan>[
                        const TextSpan(text: ' / ', style: TextStyle(color: Colors.white)),
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
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => _showDeleteDialog(),
                  child: Container(
                      decoration:
                          BoxDecoration(color: Colors.grey.withOpacity(0.4), borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: const Text('レコード削除')),
                ),
              ),
              Expanded(child: _displayDailyInvest()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void _showDeleteDialog() {
    final Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
        onPressed: () {
          _deleteInvestRecords();

          Navigator.pop(context);
        },
        child: const Text('はい'));

    final AlertDialog alert = AlertDialog(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      content: const Text('このデータを消去しますか？'),
      actions: <Widget>[cancelButton, continueButton],
    );

    // ignore: inference_failure_on_function_invocation
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  ///
  Future<void> _deleteInvestRecords() async {
    InvestRecordsRepository()
        .getInvestRecordListByDate(isar: widget.isar, date: widget.date.yyyymmdd)
        .then((List<InvestRecord>? value) async {
      InvestRecordsRepository()
          .deleteInvestRecordList(isar: widget.isar, investRecordList: value)
          // ignore: always_specify_types
          .then((value2) async {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    });
  }

  ///
  Widget _displayDailyInvest() {
    makeInvestRatingDataMap();

    final List<Widget> list = <Widget>[];

    for (final InvestKind element in InvestKind.values) {
      if (element.japanName != InvestKind.blank.japanName) {
        final List<InvestRecord>? dispInvestRecordGold =
            thisDayInvestRecordList?.where((InvestRecord element4) => element4.investId == 0).toList();

        //---------------------------------//

        int totalPrice = 0;
        int totalDiff = 0;

        final List<Widget> list2 = <Widget>[];
        widget.investNameList.where((InvestName element2) => element2.kind == element.name).toList()
          ..sort((InvestName a, InvestName b) => a.dealNumber.compareTo(b.dealNumber))
          ..forEach((InvestName element3) {
            final List<InvestRecord>? dispInvestRecord = thisDayInvestRecordList
                ?.where((InvestRecord element4) => element4.investId == element3.relationalId)
                .toList();

            list2.add(Container(
              width: context.screenSize.width,
              margin: const EdgeInsets.all(2),
              decoration:
                  BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.2), width: 2))),
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
                        Text(element3.name, maxLines: 1, overflow: TextOverflow.ellipsis),
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
                              child: Text((dispInvestRecord != null && dispInvestRecord.isNotEmpty)
                                  ? dispInvestRecord[0].cost.toString().toCurrency()
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
                                (dispInvestRecord != null && dispInvestRecord.isNotEmpty)
                                    ? dispInvestRecord[0].price.toString().toCurrency()
                                    : '0',
                                style: const TextStyle(color: Colors.yellowAccent),
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
                                (dispInvestRecord != null && dispInvestRecord.isNotEmpty)
                                    ? (dispInvestRecord[0].price - dispInvestRecord[0].cost).toString().toCurrency()
                                    : '0',
                                style: const TextStyle(color: Color(0xFFFBB6CE)),
                              ),
                            ),
                            Text(
                              (dispInvestRecord != null && dispInvestRecord.isNotEmpty)
                                  ? '${((dispInvestRecord[0].price / dispInvestRecord[0].cost) * 100).toString().split('.')[0]} %'
                                  : '0',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              dailyInvestDisplayNotifier.setSelectedInvestName(selectedInvestName: element3.name);

                              InvestDialog(
                                context: context,
                                widget: InvestRecordListAlert(
                                    investName: element3, allInvestRecord: widget.allInvestRecord),
                                clearBarrierColor: true,
                              );
                            },
                            child: Icon(Icons.info_outline,
                                color: (element3.name == dailyInvestDisplayState.selectedInvestName)
                                    ? Colors.redAccent.withOpacity(0.6)
                                    : Colors.greenAccent.withOpacity(0.6)),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              toushiShintakuNotifier.setSelectedToushiShintakuName(name: '');

                              InvestDialog(
                                context: context,
                                widget: InvestRecordInputAlert(
                                  isar: widget.isar,
                                  date: widget.date,
                                  investName: element3,
                                  investRecord: thisDayInvestRecordList
                                      ?.where((InvestRecord element4) => element4.investId == element3.relationalId)
                                      .toList(),
                                  allInvestRecord: widget.allInvestRecord,
                                ),
                                clearBarrierColor: true,
                              );
                            },
                            child: Icon(Icons.input, color: Colors.greenAccent.withOpacity(0.6)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 12),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  if (investRatingDataMap[element3.relationalId] != null) ...<Widget>[
                                    Text(investRatingDataMap[element3.relationalId]!['diff'].toString()),
                                    Text(investRatingDataMap[element3.relationalId]!['dateDiff'].toString()),
                                    Text(
                                      investRatingDataMap[element3.relationalId]!['average']
                                          .toString()
                                          .toDouble()
                                          .toStringAsFixed(2),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Expanded(child: Container()),
                          ],
                        )),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              if (investGrowthRateDataMap[element3.relationalId] != null) ...<Widget>[
                                Text(investGrowthRateDataMap[element3.relationalId]!['start']!.date),
                                Text(investGrowthRateDataMap[element3.relationalId]!['start']!
                                    .cost
                                    .toString()
                                    .toCurrency()),
                                Text(investGrowthRateDataMap[element3.relationalId]!['start']!
                                    .price
                                    .toString()
                                    .toCurrency()),
                              ],
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              if (investGrowthRateDataMap[element3.relationalId] != null) ...<Widget>[
                                Text(investGrowthRateDataMap[element3.relationalId]!['end']!.date),
                                Text(investGrowthRateDataMap[element3.relationalId]!['end']!
                                    .cost
                                    .toString()
                                    .toCurrency()),
                                Text(investGrowthRateDataMap[element3.relationalId]!['end']!
                                    .price
                                    .toString()
                                    .toCurrency()),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
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
                  gradient: LinearGradient(
                      colors: <Color>[Colors.indigo.withOpacity(0.8), Colors.transparent],
                      stops: const <double>[0.7, 1])),
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
                              const TextSpan(text: ' / ', style: TextStyle(color: Colors.white)),
                              TextSpan(
                                text: totalDiff.toString().toCurrency(),
                                style: const TextStyle(color: Color(0xFFFBB6CE)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      if (element.name == 'shintaku') ...<Widget>[
                        GestureDetector(
                          onTap: () {
                            fundNotifier.setSelectedFundName(name: '');

                            InvestDialog(context: context, widget: const FundListAlert());
                          },
                          child: Icon(Icons.money, color: Colors.white.withOpacity(0.6), size: 20),
                        ),
                        const SizedBox(width: 20),
                      ],
                      GestureDetector(
                        onTap: () {
                          investGraphNotifier.setWideGraphDisplay(flag: true);

                          investGraphNotifier.setSelectedGraphId(id: 0);

                          investGraphNotifier.setSelectedGraphName(name: '');

                          InvestDialog(
                            context: context,
                            widget: InvestGraphAlert(
                              kind: element.name,
                              investNameList: widget.investNameList,
                              allInvestRecord: widget.allInvestRecord,
                              calendarCellDateDataList: widget.calendarCellDateDataList,
                            ),
                            clearBarrierColor: true,
                          );
                        },
                        child: Icon(Icons.graphic_eq, color: Colors.white.withOpacity(0.6), size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            ///////////////////// GOLD
            if (element.name == InvestKind.gold.name) ...<Widget>[
              Container(
                width: context.screenSize.width,
                margin: const EdgeInsets.all(2),
                decoration:
                    BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.2), width: 2))),
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
                      Expanded(child: Text('gold', maxLines: 1, overflow: TextOverflow.ellipsis))
                    ]),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topRight,
                                child: Text((dispInvestRecordGold != null && dispInvestRecordGold.isNotEmpty)
                                    ? dispInvestRecordGold[0].cost.toString().toCurrency()
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
                                  (dispInvestRecordGold != null && dispInvestRecordGold.isNotEmpty)
                                      ? dispInvestRecordGold[0].price.toString().toCurrency()
                                      : '0',
                                  style: const TextStyle(color: Colors.yellowAccent),
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
                                  (dispInvestRecordGold != null && dispInvestRecordGold.isNotEmpty)
                                      ? (dispInvestRecordGold[0].price - dispInvestRecordGold[0].cost)
                                          .toString()
                                          .toCurrency()
                                      : '0',
                                  style: const TextStyle(color: Color(0xFFFBB6CE)),
                                ),
                              ),
                              Text(
                                (dispInvestRecordGold != null && dispInvestRecordGold.isNotEmpty)
                                    ? '${((dispInvestRecordGold[0].price / dispInvestRecordGold[0].cost) * 100).toString().split('.')[0]} %'
                                    : '0',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                dailyInvestDisplayNotifier.setSelectedInvestName(selectedInvestName: 'gold');

                                InvestDialog(
                                  context: context,
                                  widget: InvestRecordListAlert(
                                    investName: InvestName()
                                      ..kind = InvestKind.gold.name
                                      ..frame = ''
                                      ..name = 'gold'
                                      ..dealNumber = 0
                                      ..relationalId = 0,
                                    allInvestRecord: widget.allInvestRecord,
                                  ),
                                  clearBarrierColor: true,
                                );
                              },
                              child: Icon(Icons.info_outline,
                                  color: ('gold' == dailyInvestDisplayState.selectedInvestName)
                                      ? Colors.redAccent.withOpacity(0.6)
                                      : Colors.greenAccent.withOpacity(0.6)),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                goldNotifier.setGoldFlag(flag: false);

                                InvestDialog(
                                  context: context,
                                  widget: InvestRecordInputAlert(
                                    isar: widget.isar,
                                    date: widget.date,
                                    investRecord: thisDayInvestRecordList
                                        ?.where((InvestRecord element4) => element4.investId == 0)
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
                              child: Icon(Icons.input, color: Colors.greenAccent.withOpacity(0.6)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    DefaultTextStyle(
                      style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 12),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: Container()),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                if (investGrowthRateDataMap[0] != null) ...<Widget>[
                                  Text(investGrowthRateDataMap[0]!['start']!.date),
                                  Text(investGrowthRateDataMap[0]!['start']!.cost.toString().toCurrency()),
                                  Text(investGrowthRateDataMap[0]!['start']!.price.toString().toCurrency()),
                                ],
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                if (investGrowthRateDataMap[0] != null) ...<Widget>[
                                  Text(investGrowthRateDataMap[0]!['end']!.date),
                                  Text(investGrowthRateDataMap[0]!['end']!.cost.toString().toCurrency()),
                                  Text(investGrowthRateDataMap[0]!['end']!.price.toString().toCurrency()),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            ///////////////////// GOLD

            if (element.name != InvestKind.gold.name) ...<Widget>[
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: list2),
            ],
          ],
        ));
      }
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) => list[index], childCount: list.length),
        ),
      ],
    );
  }

  ///
  void makeInvestRatingDataMap() {
    investRatingDataMap = <int, Map<String, dynamic>>{};

    investGrowthRateDataMap.forEach((int key, Map<String, InvestRecord> value) {
      final String startDate = value['start']!.date;
      final int startPrice = value['start']!.price;

      final String endDate = value['end']!.date;
      final int endPrice = value['end']!.price;

      final int dateDiff = DateTime.parse('$endDate 00:00:00').difference(DateTime.parse('$startDate 00:00:00')).inDays;
      final int diff = endPrice - startPrice;

      investRatingDataMap[key] = <String, dynamic>{
        'startDate': startDate,
        'startPrice': startPrice,
        'endDate': endDate,
        'endPrice': endPrice,
        'dateDiff': dateDiff,
        'diff': diff,
        'average': diff / dateDiff,
      };
    });
  }

  ///
  Future<void> _makeThisDayInvestRecordList() async => InvestRecordsRepository()
      .getInvestRecordListByDate(isar: widget.isar, date: widget.date.yyyymmdd)
      .then((List<InvestRecord>? value) => setState(() => thisDayInvestRecordList = value));

  ///
  void makeInvestGrowthRateData() {
    investGrowthRateDataMap = <int, Map<String, InvestRecord>>{};

    for (final InvestName element in widget.investNameList) {
      InvestRecord investRecordStart = InvestRecord()..price = 0;
      InvestRecord investRecordEnd = InvestRecord();

      InvestRecord investRecordStartGold = InvestRecord()..price = 0;
      InvestRecord investRecordEndGold = InvestRecord();

      for (final InvestRecord element2 in widget.allInvestRecord) {
        if (element2.investId == 0) {
          if (investRecordStartGold.price == 0) {
            investRecordStartGold = element2;
          }

          investRecordEndGold = element2;
        } else if (element.relationalId == element2.investId) {
          if (investRecordStart.price == 0) {
            investRecordStart = element2;
          }

          investRecordEnd = element2;
        }
      }

      investGrowthRateDataMap[element.relationalId] = <String, InvestRecord>{
        'start': investRecordStart,
        'end': investRecordEnd
      };

      investGrowthRateDataMap[0] = <String, InvestRecord>{'start': investRecordStartGold, 'end': investRecordEndGold};
    }
  }
}
