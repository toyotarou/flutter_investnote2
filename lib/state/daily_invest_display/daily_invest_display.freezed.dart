// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_invest_display.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DailyInvestDisplayState {
  String get selectedInvestName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DailyInvestDisplayStateCopyWith<DailyInvestDisplayState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyInvestDisplayStateCopyWith<$Res> {
  factory $DailyInvestDisplayStateCopyWith(DailyInvestDisplayState value,
          $Res Function(DailyInvestDisplayState) then) =
      _$DailyInvestDisplayStateCopyWithImpl<$Res, DailyInvestDisplayState>;
  @useResult
  $Res call({String selectedInvestName});
}

/// @nodoc
class _$DailyInvestDisplayStateCopyWithImpl<$Res,
        $Val extends DailyInvestDisplayState>
    implements $DailyInvestDisplayStateCopyWith<$Res> {
  _$DailyInvestDisplayStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedInvestName = null,
  }) {
    return _then(_value.copyWith(
      selectedInvestName: null == selectedInvestName
          ? _value.selectedInvestName
          : selectedInvestName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyInvestDisplayStateImplCopyWith<$Res>
    implements $DailyInvestDisplayStateCopyWith<$Res> {
  factory _$$DailyInvestDisplayStateImplCopyWith(
          _$DailyInvestDisplayStateImpl value,
          $Res Function(_$DailyInvestDisplayStateImpl) then) =
      __$$DailyInvestDisplayStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String selectedInvestName});
}

/// @nodoc
class __$$DailyInvestDisplayStateImplCopyWithImpl<$Res>
    extends _$DailyInvestDisplayStateCopyWithImpl<$Res,
        _$DailyInvestDisplayStateImpl>
    implements _$$DailyInvestDisplayStateImplCopyWith<$Res> {
  __$$DailyInvestDisplayStateImplCopyWithImpl(
      _$DailyInvestDisplayStateImpl _value,
      $Res Function(_$DailyInvestDisplayStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedInvestName = null,
  }) {
    return _then(_$DailyInvestDisplayStateImpl(
      selectedInvestName: null == selectedInvestName
          ? _value.selectedInvestName
          : selectedInvestName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DailyInvestDisplayStateImpl implements _DailyInvestDisplayState {
  const _$DailyInvestDisplayStateImpl({this.selectedInvestName = ''});

  @override
  @JsonKey()
  final String selectedInvestName;

  @override
  String toString() {
    return 'DailyInvestDisplayState(selectedInvestName: $selectedInvestName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyInvestDisplayStateImpl &&
            (identical(other.selectedInvestName, selectedInvestName) ||
                other.selectedInvestName == selectedInvestName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedInvestName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyInvestDisplayStateImplCopyWith<_$DailyInvestDisplayStateImpl>
      get copyWith => __$$DailyInvestDisplayStateImplCopyWithImpl<
          _$DailyInvestDisplayStateImpl>(this, _$identity);
}

abstract class _DailyInvestDisplayState implements DailyInvestDisplayState {
  const factory _DailyInvestDisplayState({final String selectedInvestName}) =
      _$DailyInvestDisplayStateImpl;

  @override
  String get selectedInvestName;
  @override
  @JsonKey(ignore: true)
  _$$DailyInvestDisplayStateImplCopyWith<_$DailyInvestDisplayStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
