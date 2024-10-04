// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'total_graph.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TotalGraphState {
  String get selectedGraphName => throw _privateConstructorUsedError;
  int get selectedStartMonth => throw _privateConstructorUsedError;
  int get selectedEndMonth => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TotalGraphStateCopyWith<TotalGraphState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TotalGraphStateCopyWith<$Res> {
  factory $TotalGraphStateCopyWith(
          TotalGraphState value, $Res Function(TotalGraphState) then) =
      _$TotalGraphStateCopyWithImpl<$Res, TotalGraphState>;
  @useResult
  $Res call(
      {String selectedGraphName, int selectedStartMonth, int selectedEndMonth});
}

/// @nodoc
class _$TotalGraphStateCopyWithImpl<$Res, $Val extends TotalGraphState>
    implements $TotalGraphStateCopyWith<$Res> {
  _$TotalGraphStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedGraphName = null,
    Object? selectedStartMonth = null,
    Object? selectedEndMonth = null,
  }) {
    return _then(_value.copyWith(
      selectedGraphName: null == selectedGraphName
          ? _value.selectedGraphName
          : selectedGraphName // ignore: cast_nullable_to_non_nullable
              as String,
      selectedStartMonth: null == selectedStartMonth
          ? _value.selectedStartMonth
          : selectedStartMonth // ignore: cast_nullable_to_non_nullable
              as int,
      selectedEndMonth: null == selectedEndMonth
          ? _value.selectedEndMonth
          : selectedEndMonth // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TotalGraphStateImplCopyWith<$Res>
    implements $TotalGraphStateCopyWith<$Res> {
  factory _$$TotalGraphStateImplCopyWith(_$TotalGraphStateImpl value,
          $Res Function(_$TotalGraphStateImpl) then) =
      __$$TotalGraphStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String selectedGraphName, int selectedStartMonth, int selectedEndMonth});
}

/// @nodoc
class __$$TotalGraphStateImplCopyWithImpl<$Res>
    extends _$TotalGraphStateCopyWithImpl<$Res, _$TotalGraphStateImpl>
    implements _$$TotalGraphStateImplCopyWith<$Res> {
  __$$TotalGraphStateImplCopyWithImpl(
      _$TotalGraphStateImpl _value, $Res Function(_$TotalGraphStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedGraphName = null,
    Object? selectedStartMonth = null,
    Object? selectedEndMonth = null,
  }) {
    return _then(_$TotalGraphStateImpl(
      selectedGraphName: null == selectedGraphName
          ? _value.selectedGraphName
          : selectedGraphName // ignore: cast_nullable_to_non_nullable
              as String,
      selectedStartMonth: null == selectedStartMonth
          ? _value.selectedStartMonth
          : selectedStartMonth // ignore: cast_nullable_to_non_nullable
              as int,
      selectedEndMonth: null == selectedEndMonth
          ? _value.selectedEndMonth
          : selectedEndMonth // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$TotalGraphStateImpl implements _TotalGraphState {
  const _$TotalGraphStateImpl(
      {this.selectedGraphName = 'blank',
      this.selectedStartMonth = 0,
      this.selectedEndMonth = 0});

  @override
  @JsonKey()
  final String selectedGraphName;
  @override
  @JsonKey()
  final int selectedStartMonth;
  @override
  @JsonKey()
  final int selectedEndMonth;

  @override
  String toString() {
    return 'TotalGraphState(selectedGraphName: $selectedGraphName, selectedStartMonth: $selectedStartMonth, selectedEndMonth: $selectedEndMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TotalGraphStateImpl &&
            (identical(other.selectedGraphName, selectedGraphName) ||
                other.selectedGraphName == selectedGraphName) &&
            (identical(other.selectedStartMonth, selectedStartMonth) ||
                other.selectedStartMonth == selectedStartMonth) &&
            (identical(other.selectedEndMonth, selectedEndMonth) ||
                other.selectedEndMonth == selectedEndMonth));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, selectedGraphName, selectedStartMonth, selectedEndMonth);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TotalGraphStateImplCopyWith<_$TotalGraphStateImpl> get copyWith =>
      __$$TotalGraphStateImplCopyWithImpl<_$TotalGraphStateImpl>(
          this, _$identity);
}

abstract class _TotalGraphState implements TotalGraphState {
  const factory _TotalGraphState(
      {final String selectedGraphName,
      final int selectedStartMonth,
      final int selectedEndMonth}) = _$TotalGraphStateImpl;

  @override
  String get selectedGraphName;
  @override
  int get selectedStartMonth;
  @override
  int get selectedEndMonth;
  @override
  @JsonKey(ignore: true)
  _$$TotalGraphStateImplCopyWith<_$TotalGraphStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
