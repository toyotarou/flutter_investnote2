import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../enum/shintaku_frame.dart';
import '../../enum/stock_frame.dart';
import 'invest_names_response_state.dart';

final investNamesProvider = StateNotifierProvider.autoDispose<InvestNamesNotifier, InvestNamesResponseState>((ref) {
  return InvestNamesNotifier(const InvestNamesResponseState());
});

class InvestNamesNotifier extends StateNotifier<InvestNamesResponseState> {
  InvestNamesNotifier(super.state);

  ///
  Future<void> setStockFrame({required StockFrame stockFrame}) async => state = state.copyWith(stockFrame: stockFrame);

  ///
  Future<void> setShintakuFrame({required ShintakuFrame shintakuFrame}) async => state = state.copyWith(shintakuFrame: shintakuFrame);
}
