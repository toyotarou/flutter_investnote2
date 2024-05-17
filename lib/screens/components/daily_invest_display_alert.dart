import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
import '../../enum/invest_kind.dart';
import '../../extensions/extensions.dart';
import '../../repository/invest_records_repository.dart';
import 'invest_record_input_alert.dart';
import 'parts/invest_dialog.dart';

class DailyInvestDisplayAlert extends StatefulWidget {
  const DailyInvestDisplayAlert(
      {super.key, required this.date, required this.isar, required this.investNameList, required this.allInvestRecord});

  final DateTime date;
  final Isar isar;
  final List<InvestName> investNameList;
  final List<InvestRecord> allInvestRecord;

  ///
  @override
  State<DailyInvestDisplayAlert> createState() => _DailyInvestDisplayAlertState();
}

class _DailyInvestDisplayAlertState extends State<DailyInvestDisplayAlert> {
  List<InvestRecord>? thisDayInvestRecordList = [];

  ///
  void _init() {
    _makeThisDayInvestRecordList();
  }

  ///
  @override
  Widget build(BuildContext context) {
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
            children: [
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              Text(widget.date.yyyymmdd),
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
    final list = <Widget>[];

    InvestKind.values.forEach((element) {
      if (element.japanName != InvestKind.blank.japanName) {
        final dispInvestRecordGold = thisDayInvestRecordList?.where((element4) => element4.investId == 0).toList();

        //---------------------------------//
        final list2 = <Widget>[];
        widget.investNameList.where((element2) => element2.kind == element.name).forEach((element3) {
          final dispInvestRecord = thisDayInvestRecordList?.where((element4) => element4.investId == element3.id).toList();

          list2.add(Container(
            width: context.screenSize.width,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.2), width: 2))),
            child: Column(
              children: [
                Row(children: [Expanded(child: Text(element3.name, maxLines: 1, overflow: TextOverflow.ellipsis))]),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            child: Text((dispInvestRecord != null && dispInvestRecord.isNotEmpty)
                                ? dispInvestRecord[0].cost.toString().toCurrency()
                                : '0'),
                          ),
                          Text(''),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              (dispInvestRecord != null && dispInvestRecord.isNotEmpty)
                                  ? dispInvestRecord[0].price.toString().toCurrency()
                                  : '0',
                              style: const TextStyle(color: Colors.yellowAccent),
                            ),
                          ),
                          Text(''),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
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
                            investName: element3,
                            investRecord: thisDayInvestRecordList?.where((element4) => element4.investId == element3.id).toList(),
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
          ));
        });
        //---------------------------------//

        list.add(Column(
          children: [
            Container(
                width: context.screenSize.width,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.indigo.withOpacity(0.8), Colors.transparent], stops: const [0.7, 1])),
                child: Row(children: [Text(element.japanName)])),

            ///////////////////// GOLD
            if (element.name == InvestKind.gold.name) ...[
              Container(
                width: context.screenSize.width,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.2), width: 2))),
                child: Column(
                  children: [
                    const Row(children: [Expanded(child: Text('gold', maxLines: 1, overflow: TextOverflow.ellipsis))]),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topRight,
                                child: Text((dispInvestRecordGold != null && dispInvestRecordGold.isNotEmpty)
                                    ? dispInvestRecordGold[0].cost.toString().toCurrency()
                                    : '0'),
                              ),
                              Text(''),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topRight,
                                child: Text(
                                  (dispInvestRecordGold != null && dispInvestRecordGold.isNotEmpty)
                                      ? dispInvestRecordGold[0].price.toString().toCurrency()
                                      : '0',
                                  style: const TextStyle(color: Colors.yellowAccent),
                                ),
                              ),
                              Text(''),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                alignment: Alignment.topRight,
                                child: Text(
                                  (dispInvestRecordGold != null && dispInvestRecordGold.isNotEmpty)
                                      ? (dispInvestRecordGold[0].price - dispInvestRecordGold[0].cost).toString().toCurrency()
                                      : '0',
                                  style: const TextStyle(color: Color(0xFFFBB6CE)),
                                ),
                              ),
                              Text(
                                (dispInvestRecordGold != null && dispInvestRecordGold.isNotEmpty)
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
                                investRecord: thisDayInvestRecordList?.where((element4) => element4.investId == 0).toList(),
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
              ),
            ],
            ///////////////////// GOLD

            if (element.name != InvestKind.gold.name) ...[
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: list2),
            ],
          ],
        ));
      }
    });

    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: list));
  }

  ///
  Future<void> _makeThisDayInvestRecordList() async => InvestRecordsRepository()
      .getInvestRecordListByDate(isar: widget.isar, date: widget.date.yyyymmdd)
      .then((value) => setState(() => thisDayInvestRecordList = value));
}
