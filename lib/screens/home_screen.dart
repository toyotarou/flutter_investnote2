import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../collections/invest_name.dart';
import '../enum/invest_kind.dart';
import '../extensions/extensions.dart';
import '../repository/invest_names_repository.dart';
import '../state/calendars/calendars_notifier.dart';
import '../state/holidays/holidays_notifier.dart';
import '../utilities/utilities.dart';
import 'components/daily_invest_display_alert.dart';
import 'components/invest_name_list_alert.dart';
import 'components/parts/back_ground_image.dart';
import 'components/parts/invest_dialog.dart';
import 'components/parts/menu_head_icon.dart';

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

  ///
  void _init() {
    _makeInvestNameList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    Future(_init);

    if (widget.baseYm != null) {
      Future(() {
        return ref.read(calendarProvider.notifier).setCalendarYearMonth(baseYm: widget.baseYm);
      });
    }

    final calendarState = ref.watch(calendarProvider);

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
                color: (DateTime.now().yyyymm == calendarState.baseYearMonth) ? Colors.grey.withOpacity(0.6) : Colors.white.withOpacity(0.8),
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
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
          ),
          Column(
            children: [
              Expanded(child: _getCalendar()),
            ],
          ),
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
                onTap: () {
                  InvestDialog(
                    context: context,
                    widget: InvestNameListAlert(isar: widget.isar, investKind: InvestKind.stock),
                  );
                },
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
                onTap: () {
                  InvestDialog(
                    context: context,
                    widget: InvestNameListAlert(isar: widget.isar, investKind: InvestKind.shintaku),
                  );
                },
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

    for (var i = week * 7; i < ((week + 1) * 7); i++) {
      final generateYmd =
          (_calendarDays[i] == '') ? '' : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month, _calendarDays[i].toInt()).yyyymmdd;

      final youbiStr =
          (_calendarDays[i] == '') ? '' : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month, _calendarDays[i].toInt()).youbiStr;

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
                          constraints: BoxConstraints(minHeight: context.screenSize.height / 5),
                          child: const Column(

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
}
