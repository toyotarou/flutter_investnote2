import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enum/stock_frame.dart';

part 'stock_names_response_state.freezed.dart';

@freezed
class StockNamesResponseState with _$StockNamesResponseState {
  const factory StockNamesResponseState({
    @Default(StockFrame.blank) StockFrame stockFrame,
  }) = _StockNamesResponseState;
}
