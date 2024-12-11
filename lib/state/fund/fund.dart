//
//
//
//
// http://49.212.175.205:3000/api/v1/fund
//
//
//
//

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../extensions/extensions.dart';
import '../../model/fund.dart';
import '../../utilities/utilities.dart';

part 'fund.freezed.dart';

part 'fund.g.dart';

@freezed
class FundState with _$FundState {
  const factory FundState({
    @Default(<FundModel>[]) List<FundModel> fundList,
    @Default(<Fundname, List<FundModel>>{}) Map<Fundname, List<FundModel>> fundNameMap,
    @Default(<String, List<FundModel>>{}) Map<String, List<FundModel>> fundDateMap,
    @Default('') String selectedFundName,
  }) = _FundState;
}

@Riverpod(keepAlive: true)
class Fund extends _$Fund {
  final Utility utility = Utility();

  @override
  FundState build() => const FundState();

  ///
  Future<void> getAllFund() async {
    final HttpClient client = ref.read(httpClientProvider);

    // ignore: always_specify_types
    await client.get(path: 'fund').then((value) {
      final List<FundModel> list = <FundModel>[];
      final Map<Fundname, List<FundModel>> map = <Fundname, List<FundModel>>{};
      final Map<String, List<FundModel>> map2 = <String, List<FundModel>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value.length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final FundModel val = FundModel.fromJson(value[i] as Map<String, dynamic>);

        list.add(val);
        map[val.fundname] = <FundModel>[];
        map2['${val.year}-${val.month}-${val.day}'] = <FundModel>[];
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value.length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final FundModel val = FundModel.fromJson(value[i] as Map<String, dynamic>);

        map[val.fundname]?.add(val);
        map2['${val.year}-${val.month}-${val.day}']?.add(val);
      }

      state = state.copyWith(fundList: list, fundNameMap: map, fundDateMap: map2);
      // ignore: always_specify_types
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }

  ///
  void setSelectedFundName({required String name}) => state = state.copyWith(selectedFundName: name);
}
