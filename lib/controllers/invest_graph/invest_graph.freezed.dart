// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invest_graph.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InvestGraphState {
  bool get wideGraphDisplay => throw _privateConstructorUsedError;
  int get selectedGraphId => throw _privateConstructorUsedError;
  String get selectedGraphName => throw _privateConstructorUsedError;
  Color? get selectedGraphColor => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InvestGraphStateCopyWith<InvestGraphState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvestGraphStateCopyWith<$Res> {
  factory $InvestGraphStateCopyWith(
          InvestGraphState value, $Res Function(InvestGraphState) then) =
      _$InvestGraphStateCopyWithImpl<$Res, InvestGraphState>;
  @useResult
  $Res call(
      {bool wideGraphDisplay,
      int selectedGraphId,
      String selectedGraphName,
      Color? selectedGraphColor});
}

/// @nodoc
class _$InvestGraphStateCopyWithImpl<$Res, $Val extends InvestGraphState>
    implements $InvestGraphStateCopyWith<$Res> {
  _$InvestGraphStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wideGraphDisplay = null,
    Object? selectedGraphId = null,
    Object? selectedGraphName = null,
    Object? selectedGraphColor = freezed,
  }) {
    return _then(_value.copyWith(
      wideGraphDisplay: null == wideGraphDisplay
          ? _value.wideGraphDisplay
          : wideGraphDisplay // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedGraphId: null == selectedGraphId
          ? _value.selectedGraphId
          : selectedGraphId // ignore: cast_nullable_to_non_nullable
              as int,
      selectedGraphName: null == selectedGraphName
          ? _value.selectedGraphName
          : selectedGraphName // ignore: cast_nullable_to_non_nullable
              as String,
      selectedGraphColor: freezed == selectedGraphColor
          ? _value.selectedGraphColor
          : selectedGraphColor // ignore: cast_nullable_to_non_nullable
              as Color?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvestGraphStateImplCopyWith<$Res>
    implements $InvestGraphStateCopyWith<$Res> {
  factory _$$InvestGraphStateImplCopyWith(_$InvestGraphStateImpl value,
          $Res Function(_$InvestGraphStateImpl) then) =
      __$$InvestGraphStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool wideGraphDisplay,
      int selectedGraphId,
      String selectedGraphName,
      Color? selectedGraphColor});
}

/// @nodoc
class __$$InvestGraphStateImplCopyWithImpl<$Res>
    extends _$InvestGraphStateCopyWithImpl<$Res, _$InvestGraphStateImpl>
    implements _$$InvestGraphStateImplCopyWith<$Res> {
  __$$InvestGraphStateImplCopyWithImpl(_$InvestGraphStateImpl _value,
      $Res Function(_$InvestGraphStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wideGraphDisplay = null,
    Object? selectedGraphId = null,
    Object? selectedGraphName = null,
    Object? selectedGraphColor = freezed,
  }) {
    return _then(_$InvestGraphStateImpl(
      wideGraphDisplay: null == wideGraphDisplay
          ? _value.wideGraphDisplay
          : wideGraphDisplay // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedGraphId: null == selectedGraphId
          ? _value.selectedGraphId
          : selectedGraphId // ignore: cast_nullable_to_non_nullable
              as int,
      selectedGraphName: null == selectedGraphName
          ? _value.selectedGraphName
          : selectedGraphName // ignore: cast_nullable_to_non_nullable
              as String,
      selectedGraphColor: freezed == selectedGraphColor
          ? _value.selectedGraphColor
          : selectedGraphColor // ignore: cast_nullable_to_non_nullable
              as Color?,
    ));
  }
}

/// @nodoc

class _$InvestGraphStateImpl implements _InvestGraphState {
  const _$InvestGraphStateImpl(
      {this.wideGraphDisplay = true,
      this.selectedGraphId = 0,
      this.selectedGraphName = '',
      this.selectedGraphColor});

  @override
  @JsonKey()
  final bool wideGraphDisplay;
  @override
  @JsonKey()
  final int selectedGraphId;
  @override
  @JsonKey()
  final String selectedGraphName;
  @override
  final Color? selectedGraphColor;

  @override
  String toString() {
    return 'InvestGraphState(wideGraphDisplay: $wideGraphDisplay, selectedGraphId: $selectedGraphId, selectedGraphName: $selectedGraphName, selectedGraphColor: $selectedGraphColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvestGraphStateImpl &&
            (identical(other.wideGraphDisplay, wideGraphDisplay) ||
                other.wideGraphDisplay == wideGraphDisplay) &&
            (identical(other.selectedGraphId, selectedGraphId) ||
                other.selectedGraphId == selectedGraphId) &&
            (identical(other.selectedGraphName, selectedGraphName) ||
                other.selectedGraphName == selectedGraphName) &&
            (identical(other.selectedGraphColor, selectedGraphColor) ||
                other.selectedGraphColor == selectedGraphColor));
  }

  @override
  int get hashCode => Object.hash(runtimeType, wideGraphDisplay,
      selectedGraphId, selectedGraphName, selectedGraphColor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvestGraphStateImplCopyWith<_$InvestGraphStateImpl> get copyWith =>
      __$$InvestGraphStateImplCopyWithImpl<_$InvestGraphStateImpl>(
          this, _$identity);
}

abstract class _InvestGraphState implements InvestGraphState {
  const factory _InvestGraphState(
      {final bool wideGraphDisplay,
      final int selectedGraphId,
      final String selectedGraphName,
      final Color? selectedGraphColor}) = _$InvestGraphStateImpl;

  @override
  bool get wideGraphDisplay;
  @override
  int get selectedGraphId;
  @override
  String get selectedGraphName;
  @override
  Color? get selectedGraphColor;
  @override
  @JsonKey(ignore: true)
  _$$InvestGraphStateImplCopyWith<_$InvestGraphStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
