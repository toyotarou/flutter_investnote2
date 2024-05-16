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
import '../state/holidays/holidays_notifier.dart';
import '../utilities/utilities.dart';
import 'components/daily_invest_display_alert.dart';
import 'components/invest_name_list_alert.dart';
import 'components/parts/back_ground_image.dart';
import 'components/parts/invest_dialog.dart';
import 'components/parts/menu_head_icon.dart';

class CalendarCellSumData {
  CalendarCellSumData({required this.date, required this.stockSum, required this.shintakuSum, required this.goldSum, required this.allSum});

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
  final List<String> _youbiList = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  List<String> _calendarDays = [];

  Map<String, String> _holidayMap = {};

  final Utility _utility = Utility();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<InvestName>? investNameList = [];

  List<InvestRecord>? investRecordList = [];

  Map<String, List<InvestRecord>> investRecordMap = {};

  List<CalendarCellSumData> calendarCellSumDataList = [];

  ///
  void _init() {
    _makeInvestNameList();

    _makeInvestRecordList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    Future(_init);

    if (widget.baseYm != null) {
      Future(() => ref.read(calendarProvider.notifier).setCalendarYearMonth(baseYm: widget.baseYm));
    }

    final calendarState = ref.watch(calendarProvider);

    if (investRecordList!.isNotEmpty) {
      makeCalendarCellSumDataList();
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          children: [
            Text(calendarState.baseYearMonth),
            const SizedBox(width: 10),
            IconButton(
              onPressed: _goPrevMonth,
              icon: Icon(Icons.arrow_back_ios, color: Colors.white.withOpacity(0.8), size: 14),
            ),
            IconButton(
              onPressed: (DateTime.now().yyyymm == calendarState.baseYearMonth) ? null : _goNextMonth,
              icon: Icon(
                Icons.arrow_forward_ios,
                color:
                    (DateTime.now().yyyymm == calendarState.baseYearMonth) ? Colors.grey.withOpacity(0.6) : Colors.white.withOpacity(0.8),
                size: 14,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
            icon: Icon(Icons.settings, color: Colors.white.withOpacity(0.6), size: 20),
          )
        ],
      ),
      body: Stack(
        children: [
          const BackGroundImage(),
          Container(
              width: context.screenSize.width,
              height: context.screenSize.height,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5))),
          Column(children: [Expanded(child: _getCalendar())]),
        ],
      ),
      endDrawer: _dispDrawer(),
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
            children: [
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () => InvestDialog(context: context, widget: InvestNameListAlert(isar: widget.isar, investKind: InvestKind.stock)),
                child: Row(
                  children: [
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('株式名称登録'),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () =>
                    InvestDialog(context: context, widget: InvestNameListAlert(isar: widget.isar, investKind: InvestKind.shintaku)),
                child: Row(
                  children: [
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('信託名称登録'),
                      ),
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
  void _goPrevMonth() {
    final calendarState = ref.watch(calendarProvider);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(isar: widget.isar, baseYm: calendarState.prevYearMonth)),
    );
  }

  ///
  void _goNextMonth() {
    final calendarState = ref.watch(calendarProvider);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(isar: widget.isar, baseYm: calendarState.nextYearMonth)),
    );
  }

  ///
  Widget _getCalendar() {
    final holidayState = ref.watch(holidayProvider);

    if (holidayState.holidayMap.value != null) {
      _holidayMap = holidayState.holidayMap.value!;
    }

    final calendarState = ref.watch(calendarProvider);

    _calendarMonthFirst = DateTime.parse('${calendarState.baseYearMonth}-01 00:00:00');

    final monthEnd = DateTime.parse('${calendarState.nextYearMonth}-00 00:00:00');

    final diff = monthEnd.difference(_calendarMonthFirst).inDays;
    final monthDaysNum = diff + 1;

    final youbi = _calendarMonthFirst.youbiStr;
    final youbiNum = _youbiList.indexWhere((element) => element == youbi);

    final weekNum = ((monthDaysNum + youbiNum) <= 35) ? 5 : 6;

    _calendarDays = List.generate(weekNum * 7, (index) => '');

    for (var i = 0; i < (weekNum * 7); i++) {
      if (i >= youbiNum) {
        final gendate = _calendarMonthFirst.add(Duration(days: i - youbiNum));

        if (_calendarMonthFirst.month == gendate.month) {
          _calendarDays[i] = gendate.day.toString();
        }
      }
    }

    final list = <Widget>[];
    for (var i = 0; i < weekNum; i++) {
      list.add(_getCalendarRow(week: i));
    }

    return DefaultTextStyle(style: const TextStyle(fontSize: 10), child: SingleChildScrollView(child: Column(children: list)));
  }

  ///
  Widget _getCalendarRow({required int week}) {
    final list = <Widget>[];

    final stockIds = <int>[];
    final shintakuIds = <int>[];

    investNameList?.forEach((element) {
      if (element.kind == InvestKind.stock.name) {
        stockIds.add(element.id);
      }

      if (element.kind == InvestKind.shintaku.name) {
        shintakuIds.add(element.id);
      }
    });

    for (var i = week * 7; i < ((week + 1) * 7); i++) {
      final generateYmd =
          (_calendarDays[i] == '') ? '' : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month, _calendarDays[i].toInt()).yyyymmdd;

      final youbiStr =
          (_calendarDays[i] == '') ? '' : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month, _calendarDays[i].toInt()).youbiStr;

      //////////////////////////////////////////////////

      var stockCost = 0;
      var stockPrice = 0;
      var stockSum = 0;

      var shintakuCost = 0;
      var shintakuPrice = 0;
      var shintakuSum = 0;

      var goldCost = 0;
      var goldPrice = 0;
      var goldSum = 0;

      if (investRecordMap[generateYmd] != null) {
        investRecordMap[generateYmd]!.forEach((element) {
          if (stockIds.contains(element.investId)) {
            stockCost += element.cost;
            stockPrice += element.price;
          }

          if (shintakuIds.contains(element.investId)) {
            shintakuCost += element.cost;
            shintakuPrice += element.price;
          }

          if (element.investId == 0) {
            goldCost += element.cost;
            goldPrice += element.price;
          }
        });

        stockSum = stockPrice - stockCost;
        shintakuSum = shintakuPrice - shintakuCost;
        goldSum = goldPrice - goldCost;
      }

      var allSum = 0;
      [stockCost, stockPrice, shintakuCost, shintakuPrice, goldCost, goldPrice].forEach((element) {
        allSum += element;
      });

      //////////////////////////////////////////////////

      final index = calendarCellSumDataList.indexWhere((element) => element.date == generateYmd);

      list.add(
        Expanded(
          child: GestureDetector(
            onTap: ((_calendarDays[i] == '') || DateTime.parse('$generateYmd 00:00:00').isAfter(DateTime.now()))
                ? null
                : () => InvestDialog(
                      context: context,
                      widget: DailyInvestDisplayAlert(
                        date: DateTime.parse('$generateYmd 00:00:00'),
                        isar: widget.isar,
                        investNameList: investNameList ?? [],
                        allInvestRecord: investRecordList ?? [],
                      ),
                    ),
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
                    : (DateTime.parse('$generateYmd 00:00:00').isAfter(DateTime.now()))
                        ? Colors.white.withOpacity(0.1)
                        : _utility.getYoubiColor(date: generateYmd, youbiStr: youbiStr, holidayMap: _holidayMap),
              ),
              child: (_calendarDays[i] == '')
                  ? const Text('')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_calendarDays[i].padLeft(2, '0')),
                        const SizedBox(height: 5),
                        ConstrainedBox(
                          constraints: BoxConstraints(minHeight: context.screenSize.height / 4),
                          child: (DateTime.parse('$generateYmd 00:00:00').isAfter(DateTime.now()) || allSum == 0)
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Stack(
                                      children: [
                                        if (index != 0) ...[
                                          Positioned(
                                            bottom: 0,
                                            child: getUpDownMark(aPrice: stockSum, bPrice: calendarCellSumDataList[index - 1].stockSum),
                                          ),
                                        ],
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [Colors.indigo.withOpacity(0.8), Colors.transparent], stops: const [0.9, 1])),
                                              child: const Text('stock'),
                                            ),
                                            Text(stockCost.toString().toCurrency()),
                                            Text(stockPrice.toString().toCurrency(), style: const TextStyle(color: Colors.yellowAccent)),
                                            Text(stockSum.toString().toCurrency(), style: const TextStyle(color: Color(0xFFFBB6CE))),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Stack(
                                      children: [
                                        if (index != 0) ...[
                                          Positioned(
                                            bottom: 0,
                                            child:
                                                getUpDownMark(aPrice: shintakuSum, bPrice: calendarCellSumDataList[index - 1].shintakuSum),
                                          ),
                                        ],
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [Colors.indigo.withOpacity(0.8), Colors.transparent], stops: const [0.7, 1])),
                                              child: const Text('shintaku'),
                                            ),
                                            Text(shintakuCost.toString().toCurrency()),
                                            Text(shintakuPrice.toString().toCurrency(), style: const TextStyle(color: Colors.yellowAccent)),
                                            Text(shintakuSum.toString().toCurrency(), style: const TextStyle(color: Color(0xFFFBB6CE))),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Stack(
                                      children: [
                                        if (index != 0) ...[
                                          Positioned(
                                            bottom: 0,
                                            child: getUpDownMark(aPrice: goldSum, bPrice: calendarCellSumDataList[index - 1].goldSum),
                                          ),
                                        ],
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [Colors.indigo.withOpacity(0.8), Colors.transparent], stops: const [0.7, 1])),
                                              child: const Text('gold'),
                                            ),
                                            Text(goldCost.toString().toCurrency()),
                                            Text(goldPrice.toString().toCurrency(), style: const TextStyle(color: Colors.yellowAccent)),
                                            Text(goldSum.toString().toCurrency(), style: const TextStyle(color: Color(0xFFFBB6CE))),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Stack(
                                      children: [
                                        if (index != 0) ...[
                                          Positioned(
                                            bottom: 0,
                                            child: getUpDownMark(
                                              aPrice: stockSum + shintakuSum + goldSum,
                                              bPrice: calendarCellSumDataList[index - 1].allSum,
                                            ),
                                          ),
                                        ],
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text((stockCost + shintakuCost + goldCost).toString().toCurrency()),
                                            Text((stockPrice + shintakuPrice + goldPrice).toString().toCurrency(),
                                                style: const TextStyle(color: Colors.yellowAccent)),
                                            Text((stockSum + shintakuSum + goldSum).toString().toCurrency(),
                                                style: const TextStyle(color: Color(0xFFFBB6CE))),
                                          ],
                                        ),
                                      ],
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
      InvestNamesRepository().getInvestNameList(isar: widget.isar).then((value) => setState(() => investNameList = value));

  ///
  Future<void> _makeInvestRecordList() async {
    await InvestRecordsRepository().getInvestRecordList(isar: widget.isar).then((value) {
      investRecordList = value;

      if (value != null) {
        value
          ..forEach((element) => investRecordMap[element.date] = [])
          ..forEach((element) => investRecordMap[element.date]?.add(element));
      }
    });
  }

  void makeCalendarCellSumDataList() {
    final stockIds = <int>[];
    final shintakuIds = <int>[];

    investNameList?.forEach((element) {
      if (element.kind == InvestKind.stock.name) {
        stockIds.add(element.id);
      }

      if (element.kind == InvestKind.shintaku.name) {
        shintakuIds.add(element.id);
      }
    });

    final dateList = <String>[];
    investRecordList!.forEach((element) {
      if (!dateList.contains(element.date)) {
        var stockCost = 0;
        var stockPrice = 0;
        var stockSum = 0;

        var shintakuCost = 0;
        var shintakuPrice = 0;
        var shintakuSum = 0;

        var goldCost = 0;
        var goldPrice = 0;
        var goldSum = 0;

        var allSum = 0;

        if (investRecordMap[element.date] != null) {
          investRecordMap[element.date]!.forEach((element) {
            if (stockIds.contains(element.investId)) {
              stockCost += element.cost;
              stockPrice += element.price;
            }

            if (shintakuIds.contains(element.investId)) {
              shintakuCost += element.cost;
              shintakuPrice += element.price;
            }

            if (element.investId == 0) {
              goldCost += element.cost;
              goldPrice += element.price;
            }
          });

          stockSum = stockPrice - stockCost;
          shintakuSum = shintakuPrice - shintakuCost;
          goldSum = goldPrice - goldCost;

          allSum = stockSum + shintakuSum + goldSum;
        }

        calendarCellSumDataList
            .add(CalendarCellSumData(date: element.date, stockSum: stockSum, shintakuSum: shintakuSum, goldSum: goldSum, allSum: allSum));
      }

      dateList.add(element.date);
    });
  }

  ///
  Widget getUpDownMark({required int aPrice, required int bPrice}) {
    if (aPrice > bPrice) {
      return Icon(Icons.arrow_upward, color: Colors.greenAccent.withOpacity(0.6));
    } else if (aPrice < bPrice) {
      return Icon(Icons.arrow_downward, color: Colors.redAccent.withOpacity(0.6));
    }

    return const Icon(Icons.crop_square, color: Colors.transparent);
  }
}
