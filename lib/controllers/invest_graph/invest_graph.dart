import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'invest_graph.freezed.dart';

part 'invest_graph.g.dart';

@freezed
class InvestGraphState with _$InvestGraphState {
  const factory InvestGraphState({
    @Default(true) bool wideGraphDisplay,
    @Default(0) int selectedGraphId,
    @Default('') String selectedGraphName,
    Color? selectedGraphColor,
  }) = _InvestGraphState;
}

@Riverpod(keepAlive: true)
class InvestGraph extends _$InvestGraph {
  ///
  @override
  InvestGraphState build() {
    return const InvestGraphState();
  }

  ///
  void setWideGraphDisplay({required bool flag}) => state = state.copyWith(wideGraphDisplay: flag);

  ///
  void setSelectedGraphId({required int id}) => state = state.copyWith(selectedGraphId: id);

  ///
  void setSelectedGraphName({required String name}) => state = state.copyWith(selectedGraphName: name);

  ///
  void setSelectedGraphColor({required Color color}) => state = state.copyWith(selectedGraphColor: color);
}
