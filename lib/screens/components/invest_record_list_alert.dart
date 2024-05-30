import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
import '../../extensions/extensions.dart';

class InvestRecordListAlert extends ConsumerStatefulWidget {
  const InvestRecordListAlert({super.key, required this.investName, required this.allInvestRecord});

  final InvestName investName;
  final List<InvestRecord> allInvestRecord;

  ///
  @override
  ConsumerState<InvestRecordListAlert> createState() => _InvestRecordListAlertState();
}

class _InvestRecordListAlertState extends ConsumerState<InvestRecordListAlert> {
  @override
  Widget build(BuildContext context) {
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
              Text(widget.investName.name),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(child: _displayInvestRecordList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayInvestRecordList() {
    final list = <Widget>[];

    var lastCost = 0;
    widget.allInvestRecord.where((element) => element.investId == widget.investName.id).toList()
      ..sort((a, b) => a.date.compareTo(b.date))
      ..forEach((element) {
        final costColor = (lastCost != element.cost) ? Colors.yellowAccent : Colors.white;

        list.add(Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(flex: 2, child: Text(element.date)),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        element.cost.toString().toCurrency(),
                        style: TextStyle(color: costColor),
                      ),
                    ),
                  ),
                  Expanded(child: Container(alignment: Alignment.topRight, child: Text(element.price.toString().toCurrency()))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Expanded(
                      child: Container(alignment: Alignment.topRight, child: Text((element.price - element.cost).toString().toCurrency()))),
                ],
              ),
            ],
          ),
        ));

        lastCost = element.cost;
      });

    return SingleChildScrollView(child: Column(children: list));
  }
}
