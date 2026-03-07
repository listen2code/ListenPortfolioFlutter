// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crash_log_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CrashLogListState {

 List<File> get logs; bool get isLoading;
/// Create a copy of CrashLogListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrashLogListStateCopyWith<CrashLogListState> get copyWith => _$CrashLogListStateCopyWithImpl<CrashLogListState>(this as CrashLogListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrashLogListState&&const DeepCollectionEquality().equals(other.logs, logs)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(logs),isLoading);

@override
String toString() {
  return 'CrashLogListState(logs: $logs, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $CrashLogListStateCopyWith<$Res>  {
  factory $CrashLogListStateCopyWith(CrashLogListState value, $Res Function(CrashLogListState) _then) = _$CrashLogListStateCopyWithImpl;
@useResult
$Res call({
 List<File> logs, bool isLoading
});




}
/// @nodoc
class _$CrashLogListStateCopyWithImpl<$Res>
    implements $CrashLogListStateCopyWith<$Res> {
  _$CrashLogListStateCopyWithImpl(this._self, this._then);

  final CrashLogListState _self;
  final $Res Function(CrashLogListState) _then;

/// Create a copy of CrashLogListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? logs = null,Object? isLoading = null,}) {
  return _then(_self.copyWith(
logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as List<File>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CrashLogListState].
extension CrashLogListStatePatterns on CrashLogListState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrashLogListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrashLogListState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrashLogListState value)  $default,){
final _that = this;
switch (_that) {
case _CrashLogListState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrashLogListState value)?  $default,){
final _that = this;
switch (_that) {
case _CrashLogListState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<File> logs,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrashLogListState() when $default != null:
return $default(_that.logs,_that.isLoading);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<File> logs,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _CrashLogListState():
return $default(_that.logs,_that.isLoading);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<File> logs,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _CrashLogListState() when $default != null:
return $default(_that.logs,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _CrashLogListState extends CrashLogListState {
  const _CrashLogListState({final  List<File> logs = const [], this.isLoading = true}): _logs = logs,super._();
  

 final  List<File> _logs;
@override@JsonKey() List<File> get logs {
  if (_logs is EqualUnmodifiableListView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_logs);
}

@override@JsonKey() final  bool isLoading;

/// Create a copy of CrashLogListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrashLogListStateCopyWith<_CrashLogListState> get copyWith => __$CrashLogListStateCopyWithImpl<_CrashLogListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrashLogListState&&const DeepCollectionEquality().equals(other._logs, _logs)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_logs),isLoading);

@override
String toString() {
  return 'CrashLogListState(logs: $logs, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$CrashLogListStateCopyWith<$Res> implements $CrashLogListStateCopyWith<$Res> {
  factory _$CrashLogListStateCopyWith(_CrashLogListState value, $Res Function(_CrashLogListState) _then) = __$CrashLogListStateCopyWithImpl;
@override @useResult
$Res call({
 List<File> logs, bool isLoading
});




}
/// @nodoc
class __$CrashLogListStateCopyWithImpl<$Res>
    implements _$CrashLogListStateCopyWith<$Res> {
  __$CrashLogListStateCopyWithImpl(this._self, this._then);

  final _CrashLogListState _self;
  final $Res Function(_CrashLogListState) _then;

/// Create a copy of CrashLogListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? logs = null,Object? isLoading = null,}) {
  return _then(_CrashLogListState(
logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as List<File>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
