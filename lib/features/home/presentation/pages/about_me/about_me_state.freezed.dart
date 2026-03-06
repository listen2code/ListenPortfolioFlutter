// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'about_me_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AboutMeState {

 File? get imageFile; bool get isInitialLoaded;
/// Create a copy of AboutMeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AboutMeStateCopyWith<AboutMeState> get copyWith => _$AboutMeStateCopyWithImpl<AboutMeState>(this as AboutMeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AboutMeState&&(identical(other.imageFile, imageFile) || other.imageFile == imageFile)&&(identical(other.isInitialLoaded, isInitialLoaded) || other.isInitialLoaded == isInitialLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,imageFile,isInitialLoaded);

@override
String toString() {
  return 'AboutMeState(imageFile: $imageFile, isInitialLoaded: $isInitialLoaded)';
}


}

/// @nodoc
abstract mixin class $AboutMeStateCopyWith<$Res>  {
  factory $AboutMeStateCopyWith(AboutMeState value, $Res Function(AboutMeState) _then) = _$AboutMeStateCopyWithImpl;
@useResult
$Res call({
 File? imageFile, bool isInitialLoaded
});




}
/// @nodoc
class _$AboutMeStateCopyWithImpl<$Res>
    implements $AboutMeStateCopyWith<$Res> {
  _$AboutMeStateCopyWithImpl(this._self, this._then);

  final AboutMeState _self;
  final $Res Function(AboutMeState) _then;

/// Create a copy of AboutMeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageFile = freezed,Object? isInitialLoaded = null,}) {
  return _then(_self.copyWith(
imageFile: freezed == imageFile ? _self.imageFile : imageFile // ignore: cast_nullable_to_non_nullable
as File?,isInitialLoaded: null == isInitialLoaded ? _self.isInitialLoaded : isInitialLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AboutMeState].
extension AboutMeStatePatterns on AboutMeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AboutMeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AboutMeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AboutMeState value)  $default,){
final _that = this;
switch (_that) {
case _AboutMeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AboutMeState value)?  $default,){
final _that = this;
switch (_that) {
case _AboutMeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( File? imageFile,  bool isInitialLoaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AboutMeState() when $default != null:
return $default(_that.imageFile,_that.isInitialLoaded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( File? imageFile,  bool isInitialLoaded)  $default,) {final _that = this;
switch (_that) {
case _AboutMeState():
return $default(_that.imageFile,_that.isInitialLoaded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( File? imageFile,  bool isInitialLoaded)?  $default,) {final _that = this;
switch (_that) {
case _AboutMeState() when $default != null:
return $default(_that.imageFile,_that.isInitialLoaded);case _:
  return null;

}
}

}

/// @nodoc


class _AboutMeState extends AboutMeState {
  const _AboutMeState({this.imageFile, this.isInitialLoaded = false}): super._();
  

@override final  File? imageFile;
@override@JsonKey() final  bool isInitialLoaded;

/// Create a copy of AboutMeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AboutMeStateCopyWith<_AboutMeState> get copyWith => __$AboutMeStateCopyWithImpl<_AboutMeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AboutMeState&&(identical(other.imageFile, imageFile) || other.imageFile == imageFile)&&(identical(other.isInitialLoaded, isInitialLoaded) || other.isInitialLoaded == isInitialLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,imageFile,isInitialLoaded);

@override
String toString() {
  return 'AboutMeState(imageFile: $imageFile, isInitialLoaded: $isInitialLoaded)';
}


}

/// @nodoc
abstract mixin class _$AboutMeStateCopyWith<$Res> implements $AboutMeStateCopyWith<$Res> {
  factory _$AboutMeStateCopyWith(_AboutMeState value, $Res Function(_AboutMeState) _then) = __$AboutMeStateCopyWithImpl;
@override @useResult
$Res call({
 File? imageFile, bool isInitialLoaded
});




}
/// @nodoc
class __$AboutMeStateCopyWithImpl<$Res>
    implements _$AboutMeStateCopyWith<$Res> {
  __$AboutMeStateCopyWithImpl(this._self, this._then);

  final _AboutMeState _self;
  final $Res Function(_AboutMeState) _then;

/// Create a copy of AboutMeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageFile = freezed,Object? isInitialLoaded = null,}) {
  return _then(_AboutMeState(
imageFile: freezed == imageFile ? _self.imageFile : imageFile // ignore: cast_nullable_to_non_nullable
as File?,isInitialLoaded: null == isInitialLoaded ? _self.isInitialLoaded : isInitialLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
