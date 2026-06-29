// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playback_tape_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlaybackTapeMetadata {

 String get key; String get name; int get timestamp; int get steps;
/// Create a copy of PlaybackTapeMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaybackTapeMetadataCopyWith<PlaybackTapeMetadata> get copyWith => _$PlaybackTapeMetadataCopyWithImpl<PlaybackTapeMetadata>(this as PlaybackTapeMetadata, _$identity);

  /// Serializes this PlaybackTapeMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaybackTapeMetadata&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.steps, steps) || other.steps == steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,name,timestamp,steps);

@override
String toString() {
  return 'PlaybackTapeMetadata(key: $key, name: $name, timestamp: $timestamp, steps: $steps)';
}


}

/// @nodoc
abstract mixin class $PlaybackTapeMetadataCopyWith<$Res>  {
  factory $PlaybackTapeMetadataCopyWith(PlaybackTapeMetadata value, $Res Function(PlaybackTapeMetadata) _then) = _$PlaybackTapeMetadataCopyWithImpl;
@useResult
$Res call({
 String key, String name, int timestamp, int steps
});




}
/// @nodoc
class _$PlaybackTapeMetadataCopyWithImpl<$Res>
    implements $PlaybackTapeMetadataCopyWith<$Res> {
  _$PlaybackTapeMetadataCopyWithImpl(this._self, this._then);

  final PlaybackTapeMetadata _self;
  final $Res Function(PlaybackTapeMetadata) _then;

/// Create a copy of PlaybackTapeMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,Object? timestamp = null,Object? steps = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaybackTapeMetadata].
extension PlaybackTapeMetadataPatterns on PlaybackTapeMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaybackTapeMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaybackTapeMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaybackTapeMetadata value)  $default,){
final _that = this;
switch (_that) {
case _PlaybackTapeMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaybackTapeMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _PlaybackTapeMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String name,  int timestamp,  int steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaybackTapeMetadata() when $default != null:
return $default(_that.key,_that.name,_that.timestamp,_that.steps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String name,  int timestamp,  int steps)  $default,) {final _that = this;
switch (_that) {
case _PlaybackTapeMetadata():
return $default(_that.key,_that.name,_that.timestamp,_that.steps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String name,  int timestamp,  int steps)?  $default,) {final _that = this;
switch (_that) {
case _PlaybackTapeMetadata() when $default != null:
return $default(_that.key,_that.name,_that.timestamp,_that.steps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlaybackTapeMetadata implements PlaybackTapeMetadata {
  const _PlaybackTapeMetadata({required this.key, required this.name, required this.timestamp, required this.steps});
  factory _PlaybackTapeMetadata.fromJson(Map<String, dynamic> json) => _$PlaybackTapeMetadataFromJson(json);

@override final  String key;
@override final  String name;
@override final  int timestamp;
@override final  int steps;

/// Create a copy of PlaybackTapeMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaybackTapeMetadataCopyWith<_PlaybackTapeMetadata> get copyWith => __$PlaybackTapeMetadataCopyWithImpl<_PlaybackTapeMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaybackTapeMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaybackTapeMetadata&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.steps, steps) || other.steps == steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,name,timestamp,steps);

@override
String toString() {
  return 'PlaybackTapeMetadata(key: $key, name: $name, timestamp: $timestamp, steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$PlaybackTapeMetadataCopyWith<$Res> implements $PlaybackTapeMetadataCopyWith<$Res> {
  factory _$PlaybackTapeMetadataCopyWith(_PlaybackTapeMetadata value, $Res Function(_PlaybackTapeMetadata) _then) = __$PlaybackTapeMetadataCopyWithImpl;
@override @useResult
$Res call({
 String key, String name, int timestamp, int steps
});




}
/// @nodoc
class __$PlaybackTapeMetadataCopyWithImpl<$Res>
    implements _$PlaybackTapeMetadataCopyWith<$Res> {
  __$PlaybackTapeMetadataCopyWithImpl(this._self, this._then);

  final _PlaybackTapeMetadata _self;
  final $Res Function(_PlaybackTapeMetadata) _then;

/// Create a copy of PlaybackTapeMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,Object? timestamp = null,Object? steps = null,}) {
  return _then(_PlaybackTapeMetadata(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
