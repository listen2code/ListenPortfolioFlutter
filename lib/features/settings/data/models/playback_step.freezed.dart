// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playback_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlaybackStep {

 String get type; String get viewModelTag; String get name; String? get route; int get timestamp;
/// Create a copy of PlaybackStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaybackStepCopyWith<PlaybackStep> get copyWith => _$PlaybackStepCopyWithImpl<PlaybackStep>(this as PlaybackStep, _$identity);

  /// Serializes this PlaybackStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaybackStep&&(identical(other.type, type) || other.type == type)&&(identical(other.viewModelTag, viewModelTag) || other.viewModelTag == viewModelTag)&&(identical(other.name, name) || other.name == name)&&(identical(other.route, route) || other.route == route)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,viewModelTag,name,route,timestamp);

@override
String toString() {
  return 'PlaybackStep(type: $type, viewModelTag: $viewModelTag, name: $name, route: $route, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $PlaybackStepCopyWith<$Res>  {
  factory $PlaybackStepCopyWith(PlaybackStep value, $Res Function(PlaybackStep) _then) = _$PlaybackStepCopyWithImpl;
@useResult
$Res call({
 String type, String viewModelTag, String name, String? route, int timestamp
});




}
/// @nodoc
class _$PlaybackStepCopyWithImpl<$Res>
    implements $PlaybackStepCopyWith<$Res> {
  _$PlaybackStepCopyWithImpl(this._self, this._then);

  final PlaybackStep _self;
  final $Res Function(PlaybackStep) _then;

/// Create a copy of PlaybackStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? viewModelTag = null,Object? name = null,Object? route = freezed,Object? timestamp = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,viewModelTag: null == viewModelTag ? _self.viewModelTag : viewModelTag // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,route: freezed == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaybackStep].
extension PlaybackStepPatterns on PlaybackStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaybackStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaybackStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaybackStep value)  $default,){
final _that = this;
switch (_that) {
case _PlaybackStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaybackStep value)?  $default,){
final _that = this;
switch (_that) {
case _PlaybackStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String viewModelTag,  String name,  String? route,  int timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaybackStep() when $default != null:
return $default(_that.type,_that.viewModelTag,_that.name,_that.route,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String viewModelTag,  String name,  String? route,  int timestamp)  $default,) {final _that = this;
switch (_that) {
case _PlaybackStep():
return $default(_that.type,_that.viewModelTag,_that.name,_that.route,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String viewModelTag,  String name,  String? route,  int timestamp)?  $default,) {final _that = this;
switch (_that) {
case _PlaybackStep() when $default != null:
return $default(_that.type,_that.viewModelTag,_that.name,_that.route,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlaybackStep implements PlaybackStep {
  const _PlaybackStep({required this.type, required this.viewModelTag, required this.name, this.route, required this.timestamp});
  factory _PlaybackStep.fromJson(Map<String, dynamic> json) => _$PlaybackStepFromJson(json);

@override final  String type;
@override final  String viewModelTag;
@override final  String name;
@override final  String? route;
@override final  int timestamp;

/// Create a copy of PlaybackStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaybackStepCopyWith<_PlaybackStep> get copyWith => __$PlaybackStepCopyWithImpl<_PlaybackStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaybackStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaybackStep&&(identical(other.type, type) || other.type == type)&&(identical(other.viewModelTag, viewModelTag) || other.viewModelTag == viewModelTag)&&(identical(other.name, name) || other.name == name)&&(identical(other.route, route) || other.route == route)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,viewModelTag,name,route,timestamp);

@override
String toString() {
  return 'PlaybackStep(type: $type, viewModelTag: $viewModelTag, name: $name, route: $route, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$PlaybackStepCopyWith<$Res> implements $PlaybackStepCopyWith<$Res> {
  factory _$PlaybackStepCopyWith(_PlaybackStep value, $Res Function(_PlaybackStep) _then) = __$PlaybackStepCopyWithImpl;
@override @useResult
$Res call({
 String type, String viewModelTag, String name, String? route, int timestamp
});




}
/// @nodoc
class __$PlaybackStepCopyWithImpl<$Res>
    implements _$PlaybackStepCopyWith<$Res> {
  __$PlaybackStepCopyWithImpl(this._self, this._then);

  final _PlaybackStep _self;
  final $Res Function(_PlaybackStep) _then;

/// Create a copy of PlaybackStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? viewModelTag = null,Object? name = null,Object? route = freezed,Object? timestamp = null,}) {
  return _then(_PlaybackStep(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,viewModelTag: null == viewModelTag ? _self.viewModelTag : viewModelTag // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,route: freezed == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
