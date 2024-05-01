// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_names_response_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StockNamesResponseState {
  StockFrame get stockFrame => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StockNamesResponseStateCopyWith<StockNamesResponseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockNamesResponseStateCopyWith<$Res> {
  factory $StockNamesResponseStateCopyWith(StockNamesResponseState value,
          $Res Function(StockNamesResponseState) then) =
      _$StockNamesResponseStateCopyWithImpl<$Res, StockNamesResponseState>;
  @useResult
  $Res call({StockFrame stockFrame});
}

/// @nodoc
class _$StockNamesResponseStateCopyWithImpl<$Res,
        $Val extends StockNamesResponseState>
    implements $StockNamesResponseStateCopyWith<$Res> {
  _$StockNamesResponseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stockFrame = null,
  }) {
    return _then(_value.copyWith(
      stockFrame: null == stockFrame
          ? _value.stockFrame
          : stockFrame // ignore: cast_nullable_to_non_nullable
              as StockFrame,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockNamesResponseStateImplCopyWith<$Res>
    implements $StockNamesResponseStateCopyWith<$Res> {
  factory _$$StockNamesResponseStateImplCopyWith(
          _$StockNamesResponseStateImpl value,
          $Res Function(_$StockNamesResponseStateImpl) then) =
      __$$StockNamesResponseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({StockFrame stockFrame});
}

/// @nodoc
class __$$StockNamesResponseStateImplCopyWithImpl<$Res>
    extends _$StockNamesResponseStateCopyWithImpl<$Res,
        _$StockNamesResponseStateImpl>
    implements _$$StockNamesResponseStateImplCopyWith<$Res> {
  __$$StockNamesResponseStateImplCopyWithImpl(
      _$StockNamesResponseStateImpl _value,
      $Res Function(_$StockNamesResponseStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stockFrame = null,
  }) {
    return _then(_$StockNamesResponseStateImpl(
      stockFrame: null == stockFrame
          ? _value.stockFrame
          : stockFrame // ignore: cast_nullable_to_non_nullable
              as StockFrame,
    ));
  }
}

/// @nodoc

class _$StockNamesResponseStateImpl implements _StockNamesResponseState {
  const _$StockNamesResponseStateImpl({this.stockFrame = StockFrame.blank});

  @override
  @JsonKey()
  final StockFrame stockFrame;

  @override
  String toString() {
    return 'StockNamesResponseState(stockFrame: $stockFrame)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockNamesResponseStateImpl &&
            (identical(other.stockFrame, stockFrame) ||
                other.stockFrame == stockFrame));
  }

  @override
  int get hashCode => Object.hash(runtimeType, stockFrame);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockNamesResponseStateImplCopyWith<_$StockNamesResponseStateImpl>
      get copyWith => __$$StockNamesResponseStateImplCopyWithImpl<
          _$StockNamesResponseStateImpl>(this, _$identity);
}

abstract class _StockNamesResponseState implements StockNamesResponseState {
  const factory _StockNamesResponseState({final StockFrame stockFrame}) =
      _$StockNamesResponseStateImpl;

  @override
  StockFrame get stockFrame;
  @override
  @JsonKey(ignore: true)
  _$$StockNamesResponseStateImplCopyWith<_$StockNamesResponseStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
