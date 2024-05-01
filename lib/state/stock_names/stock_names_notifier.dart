import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:invest_note/enum/stock_frame.dart';
import 'package:invest_note/state/stock_names/stock_names_response_state.dart';

final stockNamesProvider = StateNotifierProvider.autoDispose<StockNamesNotifier, StockNamesResponseState>((ref) {
  return StockNamesNotifier(const StockNamesResponseState());
});

class StockNamesNotifier extends StateNotifier<StockNamesResponseState> {
  StockNamesNotifier(super.state);

  ///
  Future<void> setStockFrame({required StockFrame stockFrame}) async => state = state.copyWith(stockFrame: stockFrame);
}
