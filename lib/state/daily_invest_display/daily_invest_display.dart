import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_invest_display.freezed.dart';

part 'daily_invest_display.g.dart';

@freezed
class DailyInvestDisplayState with _$DailyInvestDisplayState {
  const factory DailyInvestDisplayState({
    @Default('') String selectedInvestName,
  }) = _DailyInvestDisplayState;
}

@Riverpod(keepAlive: true)
class DailyInvestDisplay extends _$DailyInvestDisplay {
  @override
  DailyInvestDisplayState build() {
    return const DailyInvestDisplayState();
  }

  ///
  Future<void> setSelectedInvestName(
          {required String selectedInvestName}) async =>
      state = state.copyWith(selectedInvestName: selectedInvestName);
}
