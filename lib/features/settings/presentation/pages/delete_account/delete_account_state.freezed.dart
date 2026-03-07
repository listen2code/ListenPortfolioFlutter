// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_account_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeleteAccountState {

 bool get isConfirmed;
/// Create a copy of DeleteAccountState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteAccountStateCopyWith<DeleteAccountState> get copyWith => _$DeleteAccountStateCopyWithImpl<DeleteAccountState>(this as DeleteAccountState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAccountState&&(identical(other.isConfirmed, isConfirmed) || other.isConfirmed == isConfirmed));
}


@override
int get hashCode => Object.hash(runtimeType,isConfirmed);

@override
String toString() {
  return 'DeleteAccountState(isConfirmed: $isConfirmed)';
}


}

/// @nodoc
abstract mixin class $DeleteAccountStateCopyWith<$Res>  {
  factory $DeleteAccountStateCopyWith(DeleteAccountState value, $Res Function(DeleteAccountState) _then) = _$DeleteAccountStateCopyWithImpl;
@useResult
$Res call({
 bool isConfirmed
});




}
/// @nodoc
class _$DeleteAccountStateCopyWithImpl<$Res>
    implements $DeleteAccountStateCopyWith<$Res> {
  _$DeleteAccountStateCopyWithImpl(this._self, this._then);

  final DeleteAccountState _self;
  final $Res Function(DeleteAccountState) _then;

/// Create a copy of DeleteAccountState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isConfirmed = null,}) {
  return _then(_self.copyWith(
isConfirmed: null == isConfirmed ? _self.isConfirmed : isConfirmed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DeleteAccountState].
extension DeleteAccountStatePatterns on DeleteAccountState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeleteAccountState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeleteAccountState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeleteAccountState value)  $default,){
final _that = this;
switch (_that) {
case _DeleteAccountState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeleteAccountState value)?  $default,){
final _that = this;
switch (_that) {
case _DeleteAccountState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isConfirmed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeleteAccountState() when $default != null:
return $default(_that.isConfirmed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isConfirmed)  $default,) {final _that = this;
switch (_that) {
case _DeleteAccountState():
return $default(_that.isConfirmed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isConfirmed)?  $default,) {final _that = this;
switch (_that) {
case _DeleteAccountState() when $default != null:
return $default(_that.isConfirmed);case _:
  return null;

}
}

}

/// @nodoc


class _DeleteAccountState extends DeleteAccountState {
  const _DeleteAccountState({this.isConfirmed = false}): super._();
  

@override@JsonKey() final  bool isConfirmed;

/// Create a copy of DeleteAccountState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteAccountStateCopyWith<_DeleteAccountState> get copyWith => __$DeleteAccountStateCopyWithImpl<_DeleteAccountState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteAccountState&&(identical(other.isConfirmed, isConfirmed) || other.isConfirmed == isConfirmed));
}


@override
int get hashCode => Object.hash(runtimeType,isConfirmed);

@override
String toString() {
  return 'DeleteAccountState(isConfirmed: $isConfirmed)';
}


}

/// @nodoc
abstract mixin class _$DeleteAccountStateCopyWith<$Res> implements $DeleteAccountStateCopyWith<$Res> {
  factory _$DeleteAccountStateCopyWith(_DeleteAccountState value, $Res Function(_DeleteAccountState) _then) = __$DeleteAccountStateCopyWithImpl;
@override @useResult
$Res call({
 bool isConfirmed
});




}
/// @nodoc
class __$DeleteAccountStateCopyWithImpl<$Res>
    implements _$DeleteAccountStateCopyWith<$Res> {
  __$DeleteAccountStateCopyWithImpl(this._self, this._then);

  final _DeleteAccountState _self;
  final $Res Function(_DeleteAccountState) _then;

/// Create a copy of DeleteAccountState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isConfirmed = null,}) {
  return _then(_DeleteAccountState(
isConfirmed: null == isConfirmed ? _self.isConfirmed : isConfirmed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
