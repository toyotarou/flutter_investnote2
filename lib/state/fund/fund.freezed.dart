// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fund.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FundState {
  List<FundModel> get fundList => throw _privateConstructorUsedError;
  Map<Fundname, List<FundModel>> get fundNameMap =>
      throw _privateConstructorUsedError;
  Map<String, List<FundModel>> get fundDateMap =>
      throw _privateConstructorUsedError;
  String get selectedFundName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FundStateCopyWith<FundState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FundStateCopyWith<$Res> {
  factory $FundStateCopyWith(FundState value, $Res Function(FundState) then) =
      _$FundStateCopyWithImpl<$Res, FundState>;
  @useResult
  $Res call(
      {List<FundModel> fundList,
      Map<Fundname, List<FundModel>> fundNameMap,
      Map<String, List<FundModel>> fundDateMap,
      String selectedFundName});
}

/// @nodoc
class _$FundStateCopyWithImpl<$Res, $Val extends FundState>
    implements $FundStateCopyWith<$Res> {
  _$FundStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fundList = null,
    Object? fundNameMap = null,
    Object? fundDateMap = null,
    Object? selectedFundName = null,
  }) {
    return _then(_value.copyWith(
      fundList: null == fundList
          ? _value.fundList
          : fundList // ignore: cast_nullable_to_non_nullable
              as List<FundModel>,
      fundNameMap: null == fundNameMap
          ? _value.fundNameMap
          : fundNameMap // ignore: cast_nullable_to_non_nullable
              as Map<Fundname, List<FundModel>>,
      fundDateMap: null == fundDateMap
          ? _value.fundDateMap
          : fundDateMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<FundModel>>,
      selectedFundName: null == selectedFundName
          ? _value.selectedFundName
          : selectedFundName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FundStateImplCopyWith<$Res>
    implements $FundStateCopyWith<$Res> {
  factory _$$FundStateImplCopyWith(
          _$FundStateImpl value, $Res Function(_$FundStateImpl) then) =
      __$$FundStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<FundModel> fundList,
      Map<Fundname, List<FundModel>> fundNameMap,
      Map<String, List<FundModel>> fundDateMap,
      String selectedFundName});
}

/// @nodoc
class __$$FundStateImplCopyWithImpl<$Res>
    extends _$FundStateCopyWithImpl<$Res, _$FundStateImpl>
    implements _$$FundStateImplCopyWith<$Res> {
  __$$FundStateImplCopyWithImpl(
      _$FundStateImpl _value, $Res Function(_$FundStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fundList = null,
    Object? fundNameMap = null,
    Object? fundDateMap = null,
    Object? selectedFundName = null,
  }) {
    return _then(_$FundStateImpl(
      fundList: null == fundList
          ? _value._fundList
          : fundList // ignore: cast_nullable_to_non_nullable
              as List<FundModel>,
      fundNameMap: null == fundNameMap
          ? _value._fundNameMap
          : fundNameMap // ignore: cast_nullable_to_non_nullable
              as Map<Fundname, List<FundModel>>,
      fundDateMap: null == fundDateMap
          ? _value._fundDateMap
          : fundDateMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<FundModel>>,
      selectedFundName: null == selectedFundName
          ? _value.selectedFundName
          : selectedFundName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FundStateImpl implements _FundState {
  const _$FundStateImpl(
      {final List<FundModel> fundList = const <FundModel>[],
      final Map<Fundname, List<FundModel>> fundNameMap =
          const <Fundname, List<FundModel>>{},
      final Map<String, List<FundModel>> fundDateMap =
          const <String, List<FundModel>>{},
      this.selectedFundName = ''})
      : _fundList = fundList,
        _fundNameMap = fundNameMap,
        _fundDateMap = fundDateMap;

  final List<FundModel> _fundList;
  @override
  @JsonKey()
  List<FundModel> get fundList {
    if (_fundList is EqualUnmodifiableListView) return _fundList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fundList);
  }

  final Map<Fundname, List<FundModel>> _fundNameMap;
  @override
  @JsonKey()
  Map<Fundname, List<FundModel>> get fundNameMap {
    if (_fundNameMap is EqualUnmodifiableMapView) return _fundNameMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fundNameMap);
  }

  final Map<String, List<FundModel>> _fundDateMap;
  @override
  @JsonKey()
  Map<String, List<FundModel>> get fundDateMap {
    if (_fundDateMap is EqualUnmodifiableMapView) return _fundDateMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fundDateMap);
  }

  @override
  @JsonKey()
  final String selectedFundName;

  @override
  String toString() {
    return 'FundState(fundList: $fundList, fundNameMap: $fundNameMap, fundDateMap: $fundDateMap, selectedFundName: $selectedFundName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FundStateImpl &&
            const DeepCollectionEquality().equals(other._fundList, _fundList) &&
            const DeepCollectionEquality()
                .equals(other._fundNameMap, _fundNameMap) &&
            const DeepCollectionEquality()
                .equals(other._fundDateMap, _fundDateMap) &&
            (identical(other.selectedFundName, selectedFundName) ||
                other.selectedFundName == selectedFundName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_fundList),
      const DeepCollectionEquality().hash(_fundNameMap),
      const DeepCollectionEquality().hash(_fundDateMap),
      selectedFundName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FundStateImplCopyWith<_$FundStateImpl> get copyWith =>
      __$$FundStateImplCopyWithImpl<_$FundStateImpl>(this, _$identity);
}

abstract class _FundState implements FundState {
  const factory _FundState(
      {final List<FundModel> fundList,
      final Map<Fundname, List<FundModel>> fundNameMap,
      final Map<String, List<FundModel>> fundDateMap,
      final String selectedFundName}) = _$FundStateImpl;

  @override
  List<FundModel> get fundList;
  @override
  Map<Fundname, List<FundModel>> get fundNameMap;
  @override
  Map<String, List<FundModel>> get fundDateMap;
  @override
  String get selectedFundName;
  @override
  @JsonKey(ignore: true)
  _$$FundStateImplCopyWith<_$FundStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
