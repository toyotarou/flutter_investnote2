// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invest_names_response_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InvestNamesResponseState {
  StockFrame get stockFrame => throw _privateConstructorUsedError;
  ShintakuFrame get shintakuFrame => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InvestNamesResponseStateCopyWith<InvestNamesResponseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvestNamesResponseStateCopyWith<$Res> {
  factory $InvestNamesResponseStateCopyWith(InvestNamesResponseState value,
          $Res Function(InvestNamesResponseState) then) =
      _$InvestNamesResponseStateCopyWithImpl<$Res, InvestNamesResponseState>;
  @useResult
  $Res call({StockFrame stockFrame, ShintakuFrame shintakuFrame});
}

/// @nodoc
class _$InvestNamesResponseStateCopyWithImpl<$Res,
        $Val extends InvestNamesResponseState>
    implements $InvestNamesResponseStateCopyWith<$Res> {
  _$InvestNamesResponseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stockFrame = null,
    Object? shintakuFrame = null,
  }) {
    return _then(_value.copyWith(
      stockFrame: null == stockFrame
          ? _value.stockFrame
          : stockFrame // ignore: cast_nullable_to_non_nullable
              as StockFrame,
      shintakuFrame: null == shintakuFrame
          ? _value.shintakuFrame
          : shintakuFrame // ignore: cast_nullable_to_non_nullable
              as ShintakuFrame,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvestNamesResponseStateImplCopyWith<$Res>
    implements $InvestNamesResponseStateCopyWith<$Res> {
  factory _$$InvestNamesResponseStateImplCopyWith(
          _$InvestNamesResponseStateImpl value,
          $Res Function(_$InvestNamesResponseStateImpl) then) =
      __$$InvestNamesResponseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({StockFrame stockFrame, ShintakuFrame shintakuFrame});
}

/// @nodoc
class __$$InvestNamesResponseStateImplCopyWithImpl<$Res>
    extends _$InvestNamesResponseStateCopyWithImpl<$Res,
        _$InvestNamesResponseStateImpl>
    implements _$$InvestNamesResponseStateImplCopyWith<$Res> {
  __$$InvestNamesResponseStateImplCopyWithImpl(
      _$InvestNamesResponseStateImpl _value,
      $Res Function(_$InvestNamesResponseStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stockFrame = null,
    Object? shintakuFrame = null,
  }) {
    return _then(_$InvestNamesResponseStateImpl(
      stockFrame: null == stockFrame
          ? _value.stockFrame
          : stockFrame // ignore: cast_nullable_to_non_nullable
              as StockFrame,
      shintakuFrame: null == shintakuFrame
          ? _value.shintakuFrame
          : shintakuFrame // ignore: cast_nullable_to_non_nullable
              as ShintakuFrame,
    ));
  }
}

/// @nodoc

class _$InvestNamesResponseStateImpl implements _InvestNamesResponseState {
  const _$InvestNamesResponseStateImpl(
      {this.stockFrame = StockFrame.blank,
      this.shintakuFrame = ShintakuFrame.blank});

  @override
  @JsonKey()
  final StockFrame stockFrame;
  @override
  @JsonKey()
  final ShintakuFrame shintakuFrame;

  @override
  String toString() {
    return 'InvestNamesResponseState(stockFrame: $stockFrame, shintakuFrame: $shintakuFrame)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvestNamesResponseStateImpl &&
            (identical(other.stockFrame, stockFrame) ||
                other.stockFrame == stockFrame) &&
            (identical(other.shintakuFrame, shintakuFrame) ||
                other.shintakuFrame == shintakuFrame));
  }

  @override
  int get hashCode => Object.hash(runtimeType, stockFrame, shintakuFrame);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvestNamesResponseStateImplCopyWith<_$InvestNamesResponseStateImpl>
      get copyWith => __$$InvestNamesResponseStateImplCopyWithImpl<
          _$InvestNamesResponseStateImpl>(this, _$identity);
}

abstract class _InvestNamesResponseState implements InvestNamesResponseState {
  const factory _InvestNamesResponseState(
      {final StockFrame stockFrame,
      final ShintakuFrame shintakuFrame}) = _$InvestNamesResponseStateImpl;

  @override
  StockFrame get stockFrame;
  @override
  ShintakuFrame get shintakuFrame;
  @override
  @JsonKey(ignore: true)
  _$$InvestNamesResponseStateImplCopyWith<_$InvestNamesResponseStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
