// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playback_tape_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlaybackTapeListState {

 bool get isLoading; List<PlaybackTapeMetadata> get tapes;
/// Create a copy of PlaybackTapeListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaybackTapeListStateCopyWith<PlaybackTapeListState> get copyWith => _$PlaybackTapeListStateCopyWithImpl<PlaybackTapeListState>(this as PlaybackTapeListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaybackTapeListState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.tapes, tapes));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(tapes));

@override
String toString() {
  return 'PlaybackTapeListState(isLoading: $isLoading, tapes: $tapes)';
}


}

/// @nodoc
abstract mixin class $PlaybackTapeListStateCopyWith<$Res>  {
  factory $PlaybackTapeListStateCopyWith(PlaybackTapeListState value, $Res Function(PlaybackTapeListState) _then) = _$PlaybackTapeListStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<PlaybackTapeMetadata> tapes
});




}
/// @nodoc
class _$PlaybackTapeListStateCopyWithImpl<$Res>
    implements $PlaybackTapeListStateCopyWith<$Res> {
  _$PlaybackTapeListStateCopyWithImpl(this._self, this._then);

  final PlaybackTapeListState _self;
  final $Res Function(PlaybackTapeListState) _then;

/// Create a copy of PlaybackTapeListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? tapes = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,tapes: null == tapes ? _self.tapes : tapes // ignore: cast_nullable_to_non_nullable
as List<PlaybackTapeMetadata>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaybackTapeListState].
extension PlaybackTapeListStatePatterns on PlaybackTapeListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaybackTapeListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaybackTapeListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaybackTapeListState value)  $default,){
final _that = this;
switch (_that) {
case _PlaybackTapeListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaybackTapeListState value)?  $default,){
final _that = this;
switch (_that) {
case _PlaybackTapeListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<PlaybackTapeMetadata> tapes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaybackTapeListState() when $default != null:
return $default(_that.isLoading,_that.tapes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<PlaybackTapeMetadata> tapes)  $default,) {final _that = this;
switch (_that) {
case _PlaybackTapeListState():
return $default(_that.isLoading,_that.tapes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<PlaybackTapeMetadata> tapes)?  $default,) {final _that = this;
switch (_that) {
case _PlaybackTapeListState() when $default != null:
return $default(_that.isLoading,_that.tapes);case _:
  return null;

}
}

}

/// @nodoc


class _PlaybackTapeListState extends PlaybackTapeListState {
  const _PlaybackTapeListState({this.isLoading = true, final  List<PlaybackTapeMetadata> tapes = const []}): _tapes = tapes,super._();
  

@override@JsonKey() final  bool isLoading;
 final  List<PlaybackTapeMetadata> _tapes;
@override@JsonKey() List<PlaybackTapeMetadata> get tapes {
  if (_tapes is EqualUnmodifiableListView) return _tapes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tapes);
}


/// Create a copy of PlaybackTapeListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaybackTapeListStateCopyWith<_PlaybackTapeListState> get copyWith => __$PlaybackTapeListStateCopyWithImpl<_PlaybackTapeListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaybackTapeListState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._tapes, _tapes));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_tapes));

@override
String toString() {
  return 'PlaybackTapeListState(isLoading: $isLoading, tapes: $tapes)';
}


}

/// @nodoc
abstract mixin class _$PlaybackTapeListStateCopyWith<$Res> implements $PlaybackTapeListStateCopyWith<$Res> {
  factory _$PlaybackTapeListStateCopyWith(_PlaybackTapeListState value, $Res Function(_PlaybackTapeListState) _then) = __$PlaybackTapeListStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<PlaybackTapeMetadata> tapes
});




}
/// @nodoc
class __$PlaybackTapeListStateCopyWithImpl<$Res>
    implements _$PlaybackTapeListStateCopyWith<$Res> {
  __$PlaybackTapeListStateCopyWithImpl(this._self, this._then);

  final _PlaybackTapeListState _self;
  final $Res Function(_PlaybackTapeListState) _then;

/// Create a copy of PlaybackTapeListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? tapes = null,}) {
  return _then(_PlaybackTapeListState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,tapes: null == tapes ? _self._tapes : tapes // ignore: cast_nullable_to_non_nullable
as List<PlaybackTapeMetadata>,
  ));
}


}

// dart format on
