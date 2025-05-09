import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../extensions/extensions.dart';
import '../../model/toushi_shintaku.dart';
import '../../utilities/utilities.dart';

part 'toushi_shintaku.freezed.dart';

part 'toushi_shintaku.g.dart';

@freezed
class ToushiShintakuState with _$ToushiShintakuState {
  const factory ToushiShintakuState({
    @Default(<ToushiShintakuModel>[]) List<ToushiShintakuModel> toushiShintakuList,
    @Default(<String, List<ToushiShintakuModel>>{}) Map<String, List<ToushiShintakuModel>> toushiShintakuMap,
    @Default('') String targetDate,
    @Default('') String selectedToushiShintakuName,
  }) = _ToushiShintakuState;
}

@Riverpod(keepAlive: true)
class ToushiShintaku extends _$ToushiShintaku {
  final Utility utility = Utility();

  @override
  ToushiShintakuState build() => const ToushiShintakuState();

  //============================================== api

  ///
  Future<ToushiShintakuState> fetchAllToushiShintaku() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.postByPath(
        path: 'http://toyohide.work/BrainLog/api/getDataShintaku',
        body: <String, dynamic>{'date': state.targetDate},
      );

      final List<ToushiShintakuModel> list = <ToushiShintakuModel>[];
      final Map<String, List<ToushiShintakuModel>> map = <String, List<ToushiShintakuModel>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data']['record'].length.toString().toInt(); i++) {
        final ToushiShintakuModel val =
            // ignore: avoid_dynamic_calls
            ToushiShintakuModel.fromJson(value['data']['record'][i] as Map<String, dynamic>);

        list.add(val);

        map[val.date] = <ToushiShintakuModel>[];
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data']['record'].length.toString().toInt(); i++) {
        final ToushiShintakuModel val =
            // ignore: avoid_dynamic_calls
            ToushiShintakuModel.fromJson(value['data']['record'][i] as Map<String, dynamic>);

        map[val.date]?.add(val);
      }

      return state.copyWith(toushiShintakuList: list, toushiShintakuMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllToushiShintaku() async {
    try {
      final ToushiShintakuState newState = await fetchAllToushiShintaku();

      state = newState;
    } catch (_) {}
  }

//============================================== api

  ///
  void setTargetDate({required String date}) => state = state.copyWith(targetDate: date);

  ///
  void setSelectedToushiShintakuName({required String name}) =>
      state = state.copyWith(selectedToushiShintakuName: name);
}
