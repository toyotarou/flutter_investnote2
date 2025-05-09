import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'calendars/calendars_notifier.dart';
import 'calendars/calendars_response_state.dart';
import 'daily_invest_display/daily_invest_display.dart';
import 'fund/fund.dart';
import 'holidays/holidays_notifier.dart';
import 'holidays/holidays_response_state.dart';
import 'invest_graph/invest_graph.dart';
import 'total_graph/total_graph.dart';

mixin ControllersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  //==========================================//

  CalendarsResponseState get calendarState => ref.watch(calendarProvider);

  CalendarNotifier get calendarNotifier => ref.read(calendarProvider.notifier);

//==========================================//

  DailyInvestDisplayState get dailyInvestDisplayState => ref.watch(dailyInvestDisplayProvider);

  DailyInvestDisplay get dailyInvestDisplayNotifier => ref.read(dailyInvestDisplayProvider.notifier);

//==========================================//

  FundState get fundState => ref.watch(fundProvider);

  Fund get fundNotifier => ref.read(fundProvider.notifier);

//==========================================//

  HolidaysResponseState get holidayState => ref.watch(holidayProvider);

  HolidayNotifier get holidayNotifier => ref.read(holidayProvider.notifier);

//==========================================//

  InvestGraphState get investGraphState => ref.watch(investGraphProvider);

  InvestGraph get investGraphNotifier => ref.read(investGraphProvider.notifier);

//==========================================//

  // InvestNamesResponseState get investNamesState => ref.watch(investNamesProvider);
  //
  // InvestName get investNamesNotifier => ref.read(investNamesProvider.notifier);

//==========================================//

  TotalGraphState get totalGraphState => ref.watch(totalGraphProvider);

  TotalGraph get totalGraphNotifier => ref.read(totalGraphProvider.notifier);

//==========================================//
}
