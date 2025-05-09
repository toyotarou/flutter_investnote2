import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enum/shintaku_frame.dart';
import '../../enum/stock_frame.dart';

part 'invest_names_response_state.freezed.dart';

@freezed
class InvestNamesResponseState with _$InvestNamesResponseState {
  const factory InvestNamesResponseState({
    @Default(StockFrame.blank) StockFrame stockFrame,
    @Default(ShintakuFrame.blank) ShintakuFrame shintakuFrame,
  }) = _InvestNamesResponseState;
}
