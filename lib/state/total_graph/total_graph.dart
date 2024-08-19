import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'total_graph.freezed.dart';

part 'total_graph.g.dart';

@freezed
class TotalGraphState with _$TotalGraphState {
  const factory TotalGraphState({
    @Default('blank') String selectedGraphName,
  }) = _TotalGraphState;
}

@Riverpod(keepAlive: true)
class TotalGraph extends _$TotalGraph {
  ///
  @override
  TotalGraphState build() {
    return const TotalGraphState();
  }

  ///
  void setSelectedGraphName({required String name}) =>
      state = state.copyWith(selectedGraphName: name);
}
