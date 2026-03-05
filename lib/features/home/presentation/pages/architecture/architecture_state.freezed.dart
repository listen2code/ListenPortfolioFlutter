// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'architecture_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ArchitectureState {

 bool get isInitialLoaded;
/// Create a copy of ArchitectureState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchitectureStateCopyWith<ArchitectureState> get copyWith => _$ArchitectureStateCopyWithImpl<ArchitectureState>(this as ArchitectureState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchitectureState&&(identical(other.isInitialLoaded, isInitialLoaded) || other.isInitialLoaded == isInitialLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,isInitialLoaded);

@override
String toString() {
  return 'ArchitectureState(isInitialLoaded: $isInitialLoaded)';
}


}

/// @nodoc
abstract mixin class $ArchitectureStateCopyWith<$Res>  {
  factory $ArchitectureStateCopyWith(ArchitectureState value, $Res Function(ArchitectureState) _then) = _$ArchitectureStateCopyWithImpl;
@useResult
$Res call({
 bool isInitialLoaded
});




}
/// @nodoc
class _$ArchitectureStateCopyWithImpl<$Res>
    implements $ArchitectureStateCopyWith<$Res> {
  _$ArchitectureStateCopyWithImpl(this._self, this._then);

  final ArchitectureState _self;
  final $Res Function(ArchitectureState) _then;

/// Create a copy of ArchitectureState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isInitialLoaded = null,}) {
  return _then(_self.copyWith(
isInitialLoaded: null == isInitialLoaded ? _self.isInitialLoaded : isInitialLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchitectureState].
extension ArchitectureStatePatterns on ArchitectureState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchitectureState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchitectureState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchitectureState value)  $default,){
final _that = this;
switch (_that) {
case _ArchitectureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchitectureState value)?  $default,){
final _that = this;
switch (_that) {
case _ArchitectureState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isInitialLoaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchitectureState() when $default != null:
return $default(_that.isInitialLoaded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isInitialLoaded)  $default,) {final _that = this;
switch (_that) {
case _ArchitectureState():
return $default(_that.isInitialLoaded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isInitialLoaded)?  $default,) {final _that = this;
switch (_that) {
case _ArchitectureState() when $default != null:
return $default(_that.isInitialLoaded);case _:
  return null;

}
}

}

/// @nodoc


class _ArchitectureState extends ArchitectureState {
  const _ArchitectureState({this.isInitialLoaded = false}): super._();
  

@override@JsonKey() final  bool isInitialLoaded;

/// Create a copy of ArchitectureState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchitectureStateCopyWith<_ArchitectureState> get copyWith => __$ArchitectureStateCopyWithImpl<_ArchitectureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchitectureState&&(identical(other.isInitialLoaded, isInitialLoaded) || other.isInitialLoaded == isInitialLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,isInitialLoaded);

@override
String toString() {
  return 'ArchitectureState(isInitialLoaded: $isInitialLoaded)';
}


}

/// @nodoc
abstract mixin class _$ArchitectureStateCopyWith<$Res> implements $ArchitectureStateCopyWith<$Res> {
  factory _$ArchitectureStateCopyWith(_ArchitectureState value, $Res Function(_ArchitectureState) _then) = __$ArchitectureStateCopyWithImpl;
@override @useResult
$Res call({
 bool isInitialLoaded
});




}
/// @nodoc
class __$ArchitectureStateCopyWithImpl<$Res>
    implements _$ArchitectureStateCopyWith<$Res> {
  __$ArchitectureStateCopyWithImpl(this._self, this._then);

  final _ArchitectureState _self;
  final $Res Function(_ArchitectureState) _then;

/// Create a copy of ArchitectureState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isInitialLoaded = null,}) {
  return _then(_ArchitectureState(
isInitialLoaded: null == isInitialLoaded ? _self.isInitialLoaded : isInitialLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
