// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playback_tape_list_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlaybackTapeListIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaybackTapeListIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlaybackTapeListIntent()';
}


}

/// @nodoc
class $PlaybackTapeListIntentCopyWith<$Res>  {
$PlaybackTapeListIntentCopyWith(PlaybackTapeListIntent _, $Res Function(PlaybackTapeListIntent) __);
}


/// Adds pattern-matching-related methods to [PlaybackTapeListIntent].
extension PlaybackTapeListIntentPatterns on PlaybackTapeListIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadTapes value)?  loadTapes,TResult Function( _DeleteTape value)?  deleteTape,TResult Function( _StartPlayback value)?  startPlayback,TResult Function( _ShowTapeDetails value)?  showTapeDetails,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadTapes() when loadTapes != null:
return loadTapes(_that);case _DeleteTape() when deleteTape != null:
return deleteTape(_that);case _StartPlayback() when startPlayback != null:
return startPlayback(_that);case _ShowTapeDetails() when showTapeDetails != null:
return showTapeDetails(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadTapes value)  loadTapes,required TResult Function( _DeleteTape value)  deleteTape,required TResult Function( _StartPlayback value)  startPlayback,required TResult Function( _ShowTapeDetails value)  showTapeDetails,}){
final _that = this;
switch (_that) {
case _LoadTapes():
return loadTapes(_that);case _DeleteTape():
return deleteTape(_that);case _StartPlayback():
return startPlayback(_that);case _ShowTapeDetails():
return showTapeDetails(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadTapes value)?  loadTapes,TResult? Function( _DeleteTape value)?  deleteTape,TResult? Function( _StartPlayback value)?  startPlayback,TResult? Function( _ShowTapeDetails value)?  showTapeDetails,}){
final _that = this;
switch (_that) {
case _LoadTapes() when loadTapes != null:
return loadTapes(_that);case _DeleteTape() when deleteTape != null:
return deleteTape(_that);case _StartPlayback() when startPlayback != null:
return startPlayback(_that);case _ShowTapeDetails() when showTapeDetails != null:
return showTapeDetails(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadTapes,TResult Function( String tapeKey)?  deleteTape,TResult Function( String tapeKey)?  startPlayback,TResult Function( String tapeKey,  String tapeName)?  showTapeDetails,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadTapes() when loadTapes != null:
return loadTapes();case _DeleteTape() when deleteTape != null:
return deleteTape(_that.tapeKey);case _StartPlayback() when startPlayback != null:
return startPlayback(_that.tapeKey);case _ShowTapeDetails() when showTapeDetails != null:
return showTapeDetails(_that.tapeKey,_that.tapeName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadTapes,required TResult Function( String tapeKey)  deleteTape,required TResult Function( String tapeKey)  startPlayback,required TResult Function( String tapeKey,  String tapeName)  showTapeDetails,}) {final _that = this;
switch (_that) {
case _LoadTapes():
return loadTapes();case _DeleteTape():
return deleteTape(_that.tapeKey);case _StartPlayback():
return startPlayback(_that.tapeKey);case _ShowTapeDetails():
return showTapeDetails(_that.tapeKey,_that.tapeName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadTapes,TResult? Function( String tapeKey)?  deleteTape,TResult? Function( String tapeKey)?  startPlayback,TResult? Function( String tapeKey,  String tapeName)?  showTapeDetails,}) {final _that = this;
switch (_that) {
case _LoadTapes() when loadTapes != null:
return loadTapes();case _DeleteTape() when deleteTape != null:
return deleteTape(_that.tapeKey);case _StartPlayback() when startPlayback != null:
return startPlayback(_that.tapeKey);case _ShowTapeDetails() when showTapeDetails != null:
return showTapeDetails(_that.tapeKey,_that.tapeName);case _:
  return null;

}
}

}

/// @nodoc


class _LoadTapes extends PlaybackTapeListIntent {
  const _LoadTapes(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadTapes);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlaybackTapeListIntent.loadTapes()';
}


}




/// @nodoc


class _DeleteTape extends PlaybackTapeListIntent {
  const _DeleteTape(this.tapeKey): super._();
  

 final  String tapeKey;

/// Create a copy of PlaybackTapeListIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteTapeCopyWith<_DeleteTape> get copyWith => __$DeleteTapeCopyWithImpl<_DeleteTape>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteTape&&(identical(other.tapeKey, tapeKey) || other.tapeKey == tapeKey));
}


@override
int get hashCode => Object.hash(runtimeType,tapeKey);

@override
String toString() {
  return 'PlaybackTapeListIntent.deleteTape(tapeKey: $tapeKey)';
}


}

/// @nodoc
abstract mixin class _$DeleteTapeCopyWith<$Res> implements $PlaybackTapeListIntentCopyWith<$Res> {
  factory _$DeleteTapeCopyWith(_DeleteTape value, $Res Function(_DeleteTape) _then) = __$DeleteTapeCopyWithImpl;
@useResult
$Res call({
 String tapeKey
});




}
/// @nodoc
class __$DeleteTapeCopyWithImpl<$Res>
    implements _$DeleteTapeCopyWith<$Res> {
  __$DeleteTapeCopyWithImpl(this._self, this._then);

  final _DeleteTape _self;
  final $Res Function(_DeleteTape) _then;

/// Create a copy of PlaybackTapeListIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tapeKey = null,}) {
  return _then(_DeleteTape(
null == tapeKey ? _self.tapeKey : tapeKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _StartPlayback extends PlaybackTapeListIntent {
  const _StartPlayback(this.tapeKey): super._();
  

 final  String tapeKey;

/// Create a copy of PlaybackTapeListIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartPlaybackCopyWith<_StartPlayback> get copyWith => __$StartPlaybackCopyWithImpl<_StartPlayback>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartPlayback&&(identical(other.tapeKey, tapeKey) || other.tapeKey == tapeKey));
}


@override
int get hashCode => Object.hash(runtimeType,tapeKey);

@override
String toString() {
  return 'PlaybackTapeListIntent.startPlayback(tapeKey: $tapeKey)';
}


}

/// @nodoc
abstract mixin class _$StartPlaybackCopyWith<$Res> implements $PlaybackTapeListIntentCopyWith<$Res> {
  factory _$StartPlaybackCopyWith(_StartPlayback value, $Res Function(_StartPlayback) _then) = __$StartPlaybackCopyWithImpl;
@useResult
$Res call({
 String tapeKey
});




}
/// @nodoc
class __$StartPlaybackCopyWithImpl<$Res>
    implements _$StartPlaybackCopyWith<$Res> {
  __$StartPlaybackCopyWithImpl(this._self, this._then);

  final _StartPlayback _self;
  final $Res Function(_StartPlayback) _then;

/// Create a copy of PlaybackTapeListIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tapeKey = null,}) {
  return _then(_StartPlayback(
null == tapeKey ? _self.tapeKey : tapeKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ShowTapeDetails extends PlaybackTapeListIntent {
  const _ShowTapeDetails(this.tapeKey, this.tapeName): super._();
  

 final  String tapeKey;
 final  String tapeName;

/// Create a copy of PlaybackTapeListIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShowTapeDetailsCopyWith<_ShowTapeDetails> get copyWith => __$ShowTapeDetailsCopyWithImpl<_ShowTapeDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShowTapeDetails&&(identical(other.tapeKey, tapeKey) || other.tapeKey == tapeKey)&&(identical(other.tapeName, tapeName) || other.tapeName == tapeName));
}


@override
int get hashCode => Object.hash(runtimeType,tapeKey,tapeName);

@override
String toString() {
  return 'PlaybackTapeListIntent.showTapeDetails(tapeKey: $tapeKey, tapeName: $tapeName)';
}


}

/// @nodoc
abstract mixin class _$ShowTapeDetailsCopyWith<$Res> implements $PlaybackTapeListIntentCopyWith<$Res> {
  factory _$ShowTapeDetailsCopyWith(_ShowTapeDetails value, $Res Function(_ShowTapeDetails) _then) = __$ShowTapeDetailsCopyWithImpl;
@useResult
$Res call({
 String tapeKey, String tapeName
});




}
/// @nodoc
class __$ShowTapeDetailsCopyWithImpl<$Res>
    implements _$ShowTapeDetailsCopyWith<$Res> {
  __$ShowTapeDetailsCopyWithImpl(this._self, this._then);

  final _ShowTapeDetails _self;
  final $Res Function(_ShowTapeDetails) _then;

/// Create a copy of PlaybackTapeListIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tapeKey = null,Object? tapeName = null,}) {
  return _then(_ShowTapeDetails(
null == tapeKey ? _self.tapeKey : tapeKey // ignore: cast_nullable_to_non_nullable
as String,null == tapeName ? _self.tapeName : tapeName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
