import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
import '../../extensions/extensions.dart';
import 'page/invest_result_list_page.dart';

class TabInfo {
  TabInfo(this.label, this.widget);

  String label;
  Widget widget;
}

class InvestResultListAlert extends ConsumerStatefulWidget {
  const InvestResultListAlert({
    super.key,
    required this.isar,
    required this.investRecordMap,
    required this.investItemRecordMap,
    required this.investNameList,
    required this.investRecordList,
    required this.configMap,
  });

  final Isar isar;
  final Map<String, List<InvestRecord>> investRecordMap;
  final Map<int, List<InvestRecord>> investItemRecordMap;
  final List<InvestName> investNameList;
  final List<InvestRecord> investRecordList;
  final Map<String, String> configMap;

  @override
  ConsumerState<InvestResultListAlert> createState() => _InvestResultListAlertState();
}

class _InvestResultListAlertState extends ConsumerState<InvestResultListAlert> {
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
            leading: const Icon(Icons.check_box_outline_blank, color: Colors.transparent),
            //-------------------------//これを消すと「←」が出てくる（消さない）

            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.blueAccent,
              tabs: _tabs.map((TabInfo tab) => Tab(text: tab.label)).toList(),
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
    final List<int> years = <int>[];

    widget.investRecordMap.forEach((String key, List<InvestRecord> value) {
      final List<String> exDate = key.split('-');

      if (!years.contains(exDate[0].toInt())) {
        years.add(exDate[0].toInt());
      }
    });

    years.sort((int a, int b) => a.compareTo(b) * -1);

    for (final int element in years) {
      _tabs.add(TabInfo(
        element.toString(),
        InvestResultListPage(
          year: element,
          isar: widget.isar,
          investRecordMap: widget.investRecordMap,
          investItemRecordMap: widget.investItemRecordMap,
          investNameList: widget.investNameList,
          investRecordList: widget.investRecordList,
          configMap: widget.configMap,
        ),
      ));
    }
  }
}
