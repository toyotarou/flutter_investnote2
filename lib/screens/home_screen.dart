import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../collections/invest_name.dart';
import '../collections/invest_record.dart';
import '../enum/invest_kind.dart';
import '../extensions/extensions.dart';
import '../repository/invest_names_repository.dart';
import '../repository/invest_records_repository.dart';
import '../state/calendars/calendars_notifier.dart';
import '../state/calendars/calendars_response_state.dart';
import '../state/daily_invest_display/daily_invest_display.dart';
import '../state/holidays/holidays_notifier.dart';
import '../state/holidays/holidays_response_state.dart';
import '../state/total_graph/total_graph.dart';
import '../utilities/utilities.dart';
import 'components/csv_data/data_export_alert.dart';
import 'components/csv_data/data_import_alert.dart';
import 'components/daily_invest_display_alert.dart';
import 'components/invest_name_list_alert.dart';
import 'components/invest_result_list_alert.dart';
import 'components/invest_total_graph_alert.dart';
import 'components/parts/back_ground_image.dart';
import 'components/parts/invest_dialog.dart';
import 'components/parts/menu_head_icon.dart';

class CalendarCellSumData {
  CalendarCellSumData(
      {required this.date,
      required this.stockSum,
      required this.shintakuSum,
      required this.goldSum,
      required this.allSum});

  String date;
  int stockSum;
  int shintakuSum;
  int goldSum;
  int allSum;
}

// ignore: must_be_immutable
class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key, this.baseYm, required this.isar});

  String? baseYm;
  final Isar isar;

  ///
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime _calendarMonthFirst = DateTime.now();
  final List<String> _youbiList = <String>[
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  List<String> _calendarDays = <String>[];

  Map<String, String> _holidayMap = <String, String>{};

  final Utility _utility = Utility();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<InvestName>? investNameList = <InvestName>[];

  List<InvestRecord>? investRecordList = <InvestRecord>[];

  Map<String, List<InvestRecord>> investRecordMap =
      <String, List<InvestRecord>>{};

  List<String> calendarCellDateDataList = <String>[];
  Map<String, CalendarCellSumData> calendarCellSumDataMap =
      <String, CalendarCellSumData>{};

  ///
  void _init() {
    _makeInvestNameList();

    _makeInvestRecordList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    Future(_init);

    if (widget.baseYm != null) {
      // ignore: always_specify_types
      Future(() => ref
          .read(calendarProvider.notifier)
          .setCalendarYearMonth(baseYm: widget.baseYm));
    }

    final CalendarsResponseState calendarState = ref.watch(calendarProvider);

    if (investRecordList!.isNotEmpty) {
      makeCalendarCellSumDataMap();
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(calendarState.baseYearMonth),
            const SizedBox(width: 10),
            IconButton(
              onPressed: _goPrevMonth,
              icon: Icon(Icons.arrow_back_ios,
                  color: Colors.white.withOpacity(0.8), size: 14),
            ),
            IconButton(
              onPressed: (DateTime.now().yyyymm == calendarState.baseYearMonth)
                  ? null
                  : _goNextMonth,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: (DateTime.now().yyyymm == calendarState.baseYearMonth)
                    ? Colors.grey.withOpacity(0.6)
                    : Colors.white.withOpacity(0.8),
                size: 14,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              InvestDialog(
                context: context,
                widget: InvestResultListAlert(
                  isar: widget.isar,
                  investRecordMap: investRecordMap,
                ),
              );
            },
            icon: Icon(Icons.list,
                color: Colors.white.withOpacity(0.6), size: 20),
          ),
          IconButton(
            onPressed: () {
              ref
                  .read(totalGraphProvider.notifier)
                  .setSelectedStartMonth(month: 0);

              ref
                  .read(totalGraphProvider.notifier)
                  .setSelectedEndMonth(month: 0);

              InvestDialog(
                context: context,
                widget: InvestTotalGraphAlert(
                  isar: widget.isar,
                  investNameList: investNameList ?? <InvestName>[],
                  investRecordMap: investRecordMap,
                  investRecordList: investRecordList ?? <InvestRecord>[],
                ),
              );
            },
            icon: Icon(Icons.graphic_eq,
                color: Colors.white.withOpacity(0.6), size: 20),
          ),
          IconButton(
            onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
            icon: Icon(Icons.settings,
                color: Colors.white.withOpacity(0.6), size: 20),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          const BackGroundImage(),
          Container(
              width: context.screenSize.width,
              height: context.screenSize.height,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5))),
          Column(
            children: <Widget>[
              displayMonthSummary(),
              Expanded(child: _getCalendar()),
            ],
          ),
        ],
      ),
      endDrawer: _dispDrawer(),
    );
  }

  ///
  Widget displayMonthSummary() {
    final CalendarsResponseState calendarState = ref.watch(calendarProvider);

    List<InvestRecord> firstDateInvestRecordList = <InvestRecord>[];
    List<InvestRecord> lastDateInvestRecordList = <InvestRecord>[];

    int i = 0;
    investRecordMap.forEach((String key, List<InvestRecord> value) {
      final List<String> exKey = key.split('-');
      if ('${exKey[0]}-${exKey[1]}' == calendarState.baseYearMonth) {
        if (i == 0) {
          firstDateInvestRecordList = value;
        }

        lastDateInvestRecordList = value;

        i++;
      }
    });

    int firstCostTotal = 0;
    int firstPriceTotal = 0;
    for (final InvestRecord element in firstDateInvestRecordList) {
      firstCostTotal += element.cost;
      firstPriceTotal += element.price;
    }

    int lastCostTotal = 0;
    int lastPriceTotal = 0;
    for (final InvestRecord element in lastDateInvestRecordList) {
      lastCostTotal += element.cost;
      lastPriceTotal += element.price;
    }

    final int firstDiff = firstPriceTotal - firstCostTotal;
    final int lastDiff = lastPriceTotal - lastCostTotal;

    final int monthCostDiff = lastCostTotal - firstCostTotal;
    final int monthPriceDiff = lastPriceTotal - firstPriceTotal;
    final int monthDiffDiff = lastDiff - firstDiff;

    return Container(
      padding: const EdgeInsets.all(10),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 12),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(firstCostTotal.toString().toCurrency()),
                  Text(firstPriceTotal.toString().toCurrency(),
                      style: const TextStyle(color: Colors.yellowAccent)),
                  Text(firstDiff.toString().toCurrency(),
                      style: const TextStyle(color: Color(0xFFFBB6CE))),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(lastCostTotal.toString().toCurrency()),
                  Text(lastPriceTotal.toString().toCurrency(),
                      style: const TextStyle(color: Colors.yellowAccent)),
                  Text(lastDiff.toString().toCurrency(),
                      style: const TextStyle(color: Color(0xFFFBB6CE))),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(monthCostDiff.toString().toCurrency()),
                  Text(monthPriceDiff.toString().toCurrency(),
                      style: const TextStyle(color: Colors.yellowAccent)),
                  Text(monthDiffDiff.toString().toCurrency(),
                      style: const TextStyle(color: Color(0xFFFBB6CE))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  Widget _dispDrawer() {
    return Drawer(
      backgroundColor: Colors.blueGrey.withOpacity(0.2),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () => InvestDialog(
                  context: context,
                  widget: InvestNameListAlert(
                    isar: widget.isar,
                    investKind: InvestKind.stock,
                    investNameList: investNameList ?? <InvestName>[],
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('株式名称登録'),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => InvestDialog(
                  context: context,
                  widget: InvestNameListAlert(
                    isar: widget.isar,
                    investKind: InvestKind.shintaku,
                    investNameList: investNameList ?? <InvestName>[],
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('信託名称登録'),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              GestureDetector(
                onTap: () {
                  InvestDialog(
                      context: context,
                      widget: DataExportAlert(isar: widget.isar));
                },
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('データエクスポート'),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  InvestDialog(
                      context: context,
                      widget: DataImportAlert(isar: widget.isar));
                },
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('データインポート'),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void _goPrevMonth() {
    final CalendarsResponseState calendarState = ref.watch(calendarProvider);

    Navigator.pushReplacement(
      context,
      // ignore: inference_failure_on_instance_creation, always_specify_types
      MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(
              isar: widget.isar, baseYm: calendarState.prevYearMonth)),
    );
  }

  ///
  void _goNextMonth() {
    final CalendarsResponseState calendarState = ref.watch(calendarProvider);

    Navigator.pushReplacement(
      context,
      // ignore: inference_failure_on_instance_creation, always_specify_types
      MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(
              isar: widget.isar, baseYm: calendarState.nextYearMonth)),
    );
  }

  ///
  Widget _getCalendar() {
    final HolidaysResponseState holidayState = ref.watch(holidayProvider);

    if (holidayState.holidayMap.value != null) {
      _holidayMap = holidayState.holidayMap.value!;
    }

    final CalendarsResponseState calendarState = ref.watch(calendarProvider);

    _calendarMonthFirst =
        DateTime.parse('${calendarState.baseYearMonth}-01 00:00:00');

    final DateTime monthEnd =
        DateTime.parse('${calendarState.nextYearMonth}-00 00:00:00');

    final int diff = monthEnd.difference(_calendarMonthFirst).inDays;
    final int monthDaysNum = diff + 1;

    final String youbi = _calendarMonthFirst.youbiStr;
    final int youbiNum =
        _youbiList.indexWhere((String element) => element == youbi);

    final int weekNum = ((monthDaysNum + youbiNum) <= 35) ? 5 : 6;

    // ignore: always_specify_types
    _calendarDays = List.generate(weekNum * 7, (int index) => '');

    for (int i = 0; i < (weekNum * 7); i++) {
      if (i >= youbiNum) {
        final DateTime gendate =
            _calendarMonthFirst.add(Duration(days: i - youbiNum));

        if (_calendarMonthFirst.month == gendate.month) {
          _calendarDays[i] = gendate.day.toString();
        }
      }
    }

    final List<Widget> list = <Widget>[];
    for (int i = 0; i < weekNum; i++) {
      list.add(_getCalendarRow(week: i));
    }

    return DefaultTextStyle(
        style: const TextStyle(fontSize: 11),
        child: SingleChildScrollView(child: Column(children: list)));
  }

  ///
  Widget _getCalendarRow({required int week}) {
    final List<Widget> list = <Widget>[];

    final List<int> stockRelationalIds = <int>[];
    final List<int> shintakuRelationalIds = <int>[];

    investNameList?.forEach((InvestName element) {
      if (element.kind == InvestKind.stock.name) {
        stockRelationalIds.add(element.relationalId);
      }

      if (element.kind == InvestKind.shintaku.name) {
        shintakuRelationalIds.add(element.relationalId);
      }
    });

    for (int i = week * 7; i < ((week + 1) * 7); i++) {
      final String generateYmd = (_calendarDays[i] == '')
          ? ''
          : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month,
                  _calendarDays[i].toInt())
              .yyyymmdd;

      final String youbiStr = (_calendarDays[i] == '')
          ? ''
          : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month,
                  _calendarDays[i].toInt())
              .youbiStr;

      //////////////////////////////////////////////////

      int stockCost = 0;
      int stockPrice = 0;
      int stockSum = 0;

      int shintakuCost = 0;
      int shintakuPrice = 0;
      int shintakuSum = 0;

      int goldCost = 0;
      int goldPrice = 0;
      int goldSum = 0;

      if (investRecordMap[generateYmd] != null) {
        for (final InvestRecord element in investRecordMap[generateYmd]!) {
          if (stockRelationalIds.contains(element.investId)) {
            stockCost += element.cost;
            stockPrice += element.price;
          }

          if (shintakuRelationalIds.contains(element.investId)) {
            shintakuCost += element.cost;
            shintakuPrice += element.price;
          }

          if (element.investId == 0) {
            goldCost += element.cost;
            goldPrice += element.price;
          }
        }

        stockSum = stockPrice - stockCost;
        shintakuSum = shintakuPrice - shintakuCost;
        goldSum = goldPrice - goldCost;
      }

      int allSum = 0;
      for (final int element in <int>[
        stockCost,
        stockPrice,
        shintakuCost,
        shintakuPrice,
        goldCost,
        goldPrice
      ]) {
        allSum += element;
      }

      //////////////////////////////////////////////////

      final int index = calendarCellDateDataList
          .indexWhere((String element) => element == generateYmd);
      final String beforeDate =
          (index > 0) ? calendarCellDateDataList[index - 1] : '';

      bool tapFlag = true;
      if (i % 7 == 0 || i % 7 == 6) {
        tapFlag = false;
      }
      if (_calendarDays[i] == '') {
        tapFlag = false;
      } else if (DateTime.parse('$generateYmd 00:00:00')
          .isAfter(DateTime.now())) {
        tapFlag = false;
      }

      list.add(
        Expanded(
          flex: (i % 7 == 0 || i % 7 == 6) ? 1 : 2,
          child: GestureDetector(
            onTap: tapFlag
                ? () {
                    ref
                        .read(dailyInvestDisplayProvider.notifier)
                        .setSelectedInvestName(selectedInvestName: '');

                    InvestDialog(
                      context: context,
                      widget: DailyInvestDisplayAlert(
                          date: DateTime.parse('$generateYmd 00:00:00'),
                          isar: widget.isar,
                          investNameList: investNameList ?? <InvestName>[],
                          allInvestRecord: investRecordList ?? <InvestRecord>[],
                          calendarCellDateDataList: calendarCellDateDataList,
                          totalPrice: stockPrice + shintakuPrice + goldPrice,
                          totalDiff: stockSum + shintakuSum + goldSum),
                    );
                  }
                : null,
            child: Container(
              margin: const EdgeInsets.all(1),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: (_calendarDays[i] == '')
                      ? Colors.transparent
                      : (generateYmd == DateTime.now().yyyymmdd)
                          ? Colors.orangeAccent.withOpacity(0.4)
                          : Colors.white.withOpacity(0.1),
                  width: 3,
                ),
                color: (_calendarDays[i] == '')
                    ? Colors.transparent
                    : (DateTime.parse('$generateYmd 00:00:00')
                            .isAfter(DateTime.now()))
                        ? Colors.white.withOpacity(0.1)
                        : _utility.getYoubiColor(
                            date: generateYmd,
                            youbiStr: youbiStr,
                            holidayMap: _holidayMap),
              ),
              child: (_calendarDays[i] == '')
                  ? const Text('')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_calendarDays[i].padLeft(2, '0')),
                        const SizedBox(height: 5),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: context.screenSize.height / 3.5),
                          child: (DateTime.parse('$generateYmd 00:00:00')
                                      .isAfter(DateTime.now()) ||
                                  allSum == 0)
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        if (index > 0) ...<Widget>[
                                          Positioned(
                                            bottom: 0,
                                            child: getUpDownMark(
                                                aPrice: stockSum,
                                                bPrice: calendarCellSumDataMap[
                                                        beforeDate]!
                                                    .stockSum),
                                          ),
                                        ],
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: <Color>[
                                                    Colors.indigo
                                                        .withOpacity(0.8),
                                                    Colors.transparent
                                                  ],
                                                      stops: const <double>[
                                                    0.9,
                                                    1
                                                  ])),
                                              child: const Text('stock'),
                                            ),
                                            Text(stockCost
                                                .toString()
                                                .toCurrency()),
                                            Text(
                                                stockPrice
                                                    .toString()
                                                    .toCurrency(),
                                                style: const TextStyle(
                                                    color:
                                                        Colors.yellowAccent)),
                                            Text(
                                                stockSum
                                                    .toString()
                                                    .toCurrency(),
                                                style: const TextStyle(
                                                    color: Color(0xFFFBB6CE))),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Stack(
                                      children: <Widget>[
                                        if (index > 0) ...<Widget>[
                                          Positioned(
                                            bottom: 0,
                                            child: getUpDownMark(
                                                aPrice: shintakuSum,
                                                bPrice: calendarCellSumDataMap[
                                                        beforeDate]!
                                                    .shintakuSum),
                                          ),
                                        ],
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: <Color>[
                                                    Colors.indigo
                                                        .withOpacity(0.8),
                                                    Colors.transparent
                                                  ],
                                                      stops: const <double>[
                                                    0.7,
                                                    1
                                                  ])),
                                              child: const Text('shintaku'),
                                            ),
                                            Text(shintakuCost
                                                .toString()
                                                .toCurrency()),
                                            Text(
                                                shintakuPrice
                                                    .toString()
                                                    .toCurrency(),
                                                style: const TextStyle(
                                                    color:
                                                        Colors.yellowAccent)),
                                            Text(
                                                shintakuSum
                                                    .toString()
                                                    .toCurrency(),
                                                style: const TextStyle(
                                                    color: Color(0xFFFBB6CE))),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Stack(
                                      children: <Widget>[
                                        if (index > 0) ...<Widget>[
                                          Positioned(
                                            bottom: 0,
                                            child: getUpDownMark(
                                                aPrice: goldSum,
                                                bPrice: calendarCellSumDataMap[
                                                        beforeDate]!
                                                    .goldSum),
                                          ),
                                        ],
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: <Color>[
                                                    Colors.indigo
                                                        .withOpacity(0.8),
                                                    Colors.transparent
                                                  ],
                                                      stops: const <double>[
                                                    0.7,
                                                    1
                                                  ])),
                                              child: const Text('gold'),
                                            ),
                                            Text(goldCost
                                                .toString()
                                                .toCurrency()),
                                            Text(
                                                goldPrice
                                                    .toString()
                                                    .toCurrency(),
                                                style: const TextStyle(
                                                    color:
                                                        Colors.yellowAccent)),
                                            Text(
                                                goldSum.toString().toCurrency(),
                                                style: const TextStyle(
                                                    color: Color(0xFFFBB6CE))),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Stack(
                                      children: <Widget>[
                                        if (index > 0) ...<Widget>[
                                          Positioned(
                                            bottom: 0,
                                            child: getUpDownMark(
                                              aPrice: stockSum +
                                                  shintakuSum +
                                                  goldSum,
                                              bPrice: calendarCellSumDataMap[
                                                      beforeDate]!
                                                  .allSum,
                                            ),
                                          ),
                                        ],
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Text((stockCost +
                                                        shintakuCost +
                                                        goldCost)
                                                    .toString()
                                                    .toCurrency()),
                                                Text(
                                                    (stockPrice +
                                                            shintakuPrice +
                                                            goldPrice)
                                                        .toString()
                                                        .toCurrency(),
                                                    style: const TextStyle(
                                                        color: Colors
                                                            .yellowAccent)),
                                                Text(
                                                    (stockSum +
                                                            shintakuSum +
                                                            goldSum)
                                                        .toString()
                                                        .toCurrency(),
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFFFBB6CE))),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.orangeAccent
                                            .withOpacity(0.2),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(),
                                          Text(
                                            ((stockSum +
                                                        shintakuSum +
                                                        goldSum) -
                                                    calendarCellSumDataMap[
                                                            beforeDate]!
                                                        .allSum)
                                                .toString()
                                                .toCurrency(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
    }

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: list);
  }

  ///
  Future<void> _makeInvestNameList() async =>
      InvestNamesRepository().getInvestNameList(isar: widget.isar).then(
          (List<InvestName>? value) => setState(() => investNameList = value));

  ///
  Future<void> _makeInvestRecordList() async {
    await InvestRecordsRepository()
        .getInvestRecordList(isar: widget.isar)
        .then((List<InvestRecord>? value) {
      investRecordList = value;

      if (value != null) {
        value
          ..forEach((InvestRecord element) =>
              investRecordMap[element.date] = <InvestRecord>[])
          ..forEach((InvestRecord element) =>
              investRecordMap[element.date]?.add(element));
      }
    });
  }

  void makeCalendarCellSumDataMap() {
    final List<int> stockRelationalIds = <int>[];
    final List<int> shintakuRelationalIds = <int>[];

    investNameList?.forEach((InvestName element) {
      if (element.kind == InvestKind.stock.name) {
        stockRelationalIds.add(element.relationalId);
      }

      if (element.kind == InvestKind.shintaku.name) {
        shintakuRelationalIds.add(element.relationalId);
      }
    });

    calendarCellDateDataList = <String>[];

    final List<String> dateList = <String>[];
    for (final InvestRecord element in investRecordList!) {
      if (!dateList.contains(element.date)) {
        int stockCost = 0;
        int stockPrice = 0;
        int stockSum = 0;

        int shintakuCost = 0;
        int shintakuPrice = 0;
        int shintakuSum = 0;

        int goldCost = 0;
        int goldPrice = 0;
        int goldSum = 0;

        int allSum = 0;

        if (investRecordMap[element.date] != null) {
          for (final InvestRecord element in investRecordMap[element.date]!) {
            if (stockRelationalIds.contains(element.investId)) {
              stockCost += element.cost;
              stockPrice += element.price;
            }

            if (shintakuRelationalIds.contains(element.investId)) {
              shintakuCost += element.cost;
              shintakuPrice += element.price;
            }

            if (element.investId == 0) {
              goldCost += element.cost;
              goldPrice += element.price;
            }
          }

          stockSum = stockPrice - stockCost;
          shintakuSum = shintakuPrice - shintakuCost;
          goldSum = goldPrice - goldCost;

          allSum = stockSum + shintakuSum + goldSum;
        }

        calendarCellDateDataList.add(element.date);

        calendarCellSumDataMap[element.date] = CalendarCellSumData(
            date: element.date,
            stockSum: stockSum,
            shintakuSum: shintakuSum,
            goldSum: goldSum,
            allSum: allSum);
      }

      dateList.add(element.date);
    }
  }

  ///
  Widget getUpDownMark({required int aPrice, required int bPrice}) {
    if (aPrice > bPrice) {
      return Icon(Icons.arrow_upward,
          color: Colors.greenAccent.withOpacity(0.6));
    } else if (aPrice < bPrice) {
      return Icon(Icons.arrow_downward,
          color: Colors.redAccent.withOpacity(0.6));
    }

    return const Icon(Icons.crop_square, color: Colors.transparent);
  }
}
