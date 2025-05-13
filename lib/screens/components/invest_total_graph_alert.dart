import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
import '../../extensions/extensions.dart';
import 'page/invest_total_graph_page.dart';

class TabInfo {
  TabInfo(this.label, this.widget, {this.highlight = false});

  String label;
  Widget widget;
  bool highlight;
}

class InvestTotalGraphAlert extends ConsumerStatefulWidget {
  const InvestTotalGraphAlert(
      {super.key,
      required this.isar,
      required this.investNameList,
      required this.investRecordMap,
      required this.investRecordList});

  final Isar isar;
  final List<InvestName> investNameList;
  final Map<String, List<InvestRecord>> investRecordMap;
  final List<InvestRecord> investRecordList;

  @override
  ConsumerState<InvestTotalGraphAlert> createState() => _InvestTotalGraphAlertState();
}

class _InvestTotalGraphAlertState extends ConsumerState<InvestTotalGraphAlert> {
  final List<TabInfo> _tabs = <TabInfo>[];

  ///
  @override
  Widget build(BuildContext context) {
    _makeTab();

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.transparent,
            //-------------------------//これを消すと「←」が出てくる（消さない）
            leading: const Icon(
              Icons.check_box_outline_blank,
              color: Colors.transparent,
            ),
            //-------------------------//これを消すと「←」が出てくる（消さない）

            bottom: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Colors.blueAccent,
              tabs: _tabs.map((TabInfo tab) {
                return Tab(
                  child: Text(
                    tab.label,
                    style: TextStyle(
                      fontSize: 14,
                      color: tab.highlight ? Colors.yellowAccent : Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        body: TabBarView(
          children: _tabs.map((TabInfo tab) => tab.widget).toList(),
        ),
      ),
    );
  }

  ///
  void _makeTab() {
    _tabs.clear();

    final List<int> years = <int>[];

    widget.investRecordMap.forEach((String key, List<InvestRecord> value) {
      final List<String> exDate = key.split('-');

      if (!years.contains(exDate[0].toInt())) {
        years.add(exDate[0].toInt());
      }
    });

    _tabs.add(TabInfo(
        '[ALL]',
        InvestTotalGraphPage(
          isar: widget.isar,
          investNameList: widget.investNameList,
          investRecordMap: widget.investRecordMap,
          investRecordList: widget.investRecordList,
        ),
        highlight: true));

    years.sort((int a, int b) => a.compareTo(b) * -1);

    for (final int element in years) {
      _tabs.add(TabInfo(
        element.toString(),
        InvestTotalGraphPage(
          year: element,
          isar: widget.isar,
          investNameList: widget.investNameList,
          investRecordMap: widget.investRecordMap,
          investRecordList: widget.investRecordList,
        ),
      ));
    }
  }
}
