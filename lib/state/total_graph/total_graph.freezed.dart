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
  $Res call({String selectedGraphName});
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
  }) {
    return _then(_value.copyWith(
      selectedGraphName: null == selectedGraphName
          ? _value.selectedGraphName
          : selectedGraphName // ignore: cast_nullable_to_non_nullable
              as String,
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
  $Res call({String selectedGraphName});
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
  }) {
    return _then(_$TotalGraphStateImpl(
      selectedGraphName: null == selectedGraphName
          ? _value.selectedGraphName
          : selectedGraphName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TotalGraphStateImpl implements _TotalGraphState {
  const _$TotalGraphStateImpl({this.selectedGraphName = 'blank'});

  @override
  @JsonKey()
  final String selectedGraphName;

  @override
  String toString() {
    return 'TotalGraphState(selectedGraphName: $selectedGraphName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TotalGraphStateImpl &&
            (identical(other.selectedGraphName, selectedGraphName) ||
                other.selectedGraphName == selectedGraphName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedGraphName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TotalGraphStateImplCopyWith<_$TotalGraphStateImpl> get copyWith =>
      __$$TotalGraphStateImplCopyWithImpl<_$TotalGraphStateImpl>(
          this, _$identity);
}

abstract class _TotalGraphState implements TotalGraphState {
  const factory _TotalGraphState({final String selectedGraphName}) =
      _$TotalGraphStateImpl;

  @override
  String get selectedGraphName;
  @override
  @JsonKey(ignore: true)
  _$$TotalGraphStateImplCopyWith<_$TotalGraphStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
