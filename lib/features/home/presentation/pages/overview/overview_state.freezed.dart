// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overview_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OverviewState {

 bool get isInitialLoaded; List<ProjectModel> get featuredProjects; AboutMeModel? get aboutMe;
/// Create a copy of OverviewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverviewStateCopyWith<OverviewState> get copyWith => _$OverviewStateCopyWithImpl<OverviewState>(this as OverviewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverviewState&&(identical(other.isInitialLoaded, isInitialLoaded) || other.isInitialLoaded == isInitialLoaded)&&const DeepCollectionEquality().equals(other.featuredProjects, featuredProjects)&&(identical(other.aboutMe, aboutMe) || other.aboutMe == aboutMe));
}


@override
int get hashCode => Object.hash(runtimeType,isInitialLoaded,const DeepCollectionEquality().hash(featuredProjects),aboutMe);

@override
String toString() {
  return 'OverviewState(isInitialLoaded: $isInitialLoaded, featuredProjects: $featuredProjects, aboutMe: $aboutMe)';
}


}

/// @nodoc
abstract mixin class $OverviewStateCopyWith<$Res>  {
  factory $OverviewStateCopyWith(OverviewState value, $Res Function(OverviewState) _then) = _$OverviewStateCopyWithImpl;
@useResult
$Res call({
 bool isInitialLoaded, List<ProjectModel> featuredProjects, AboutMeModel? aboutMe
});


$AboutMeModelCopyWith<$Res>? get aboutMe;

}
/// @nodoc
class _$OverviewStateCopyWithImpl<$Res>
    implements $OverviewStateCopyWith<$Res> {
  _$OverviewStateCopyWithImpl(this._self, this._then);

  final OverviewState _self;
  final $Res Function(OverviewState) _then;

/// Create a copy of OverviewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isInitialLoaded = null,Object? featuredProjects = null,Object? aboutMe = freezed,}) {
  return _then(_self.copyWith(
isInitialLoaded: null == isInitialLoaded ? _self.isInitialLoaded : isInitialLoaded // ignore: cast_nullable_to_non_nullable
as bool,featuredProjects: null == featuredProjects ? _self.featuredProjects : featuredProjects // ignore: cast_nullable_to_non_nullable
as List<ProjectModel>,aboutMe: freezed == aboutMe ? _self.aboutMe : aboutMe // ignore: cast_nullable_to_non_nullable
as AboutMeModel?,
  ));
}
/// Create a copy of OverviewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AboutMeModelCopyWith<$Res>? get aboutMe {
    if (_self.aboutMe == null) {
    return null;
  }

  return $AboutMeModelCopyWith<$Res>(_self.aboutMe!, (value) {
    return _then(_self.copyWith(aboutMe: value));
  });
}
}


/// Adds pattern-matching-related methods to [OverviewState].
extension OverviewStatePatterns on OverviewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverviewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverviewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverviewState value)  $default,){
final _that = this;
switch (_that) {
case _OverviewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverviewState value)?  $default,){
final _that = this;
switch (_that) {
case _OverviewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isInitialLoaded,  List<ProjectModel> featuredProjects,  AboutMeModel? aboutMe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverviewState() when $default != null:
return $default(_that.isInitialLoaded,_that.featuredProjects,_that.aboutMe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isInitialLoaded,  List<ProjectModel> featuredProjects,  AboutMeModel? aboutMe)  $default,) {final _that = this;
switch (_that) {
case _OverviewState():
return $default(_that.isInitialLoaded,_that.featuredProjects,_that.aboutMe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isInitialLoaded,  List<ProjectModel> featuredProjects,  AboutMeModel? aboutMe)?  $default,) {final _that = this;
switch (_that) {
case _OverviewState() when $default != null:
return $default(_that.isInitialLoaded,_that.featuredProjects,_that.aboutMe);case _:
  return null;

}
}

}

/// @nodoc


class _OverviewState extends OverviewState {
  const _OverviewState({this.isInitialLoaded = false, final  List<ProjectModel> featuredProjects = const [], this.aboutMe}): _featuredProjects = featuredProjects,super._();
  

@override@JsonKey() final  bool isInitialLoaded;
 final  List<ProjectModel> _featuredProjects;
@override@JsonKey() List<ProjectModel> get featuredProjects {
  if (_featuredProjects is EqualUnmodifiableListView) return _featuredProjects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_featuredProjects);
}

@override final  AboutMeModel? aboutMe;

/// Create a copy of OverviewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverviewStateCopyWith<_OverviewState> get copyWith => __$OverviewStateCopyWithImpl<_OverviewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverviewState&&(identical(other.isInitialLoaded, isInitialLoaded) || other.isInitialLoaded == isInitialLoaded)&&const DeepCollectionEquality().equals(other._featuredProjects, _featuredProjects)&&(identical(other.aboutMe, aboutMe) || other.aboutMe == aboutMe));
}


@override
int get hashCode => Object.hash(runtimeType,isInitialLoaded,const DeepCollectionEquality().hash(_featuredProjects),aboutMe);

@override
String toString() {
  return 'OverviewState(isInitialLoaded: $isInitialLoaded, featuredProjects: $featuredProjects, aboutMe: $aboutMe)';
}


}

/// @nodoc
abstract mixin class _$OverviewStateCopyWith<$Res> implements $OverviewStateCopyWith<$Res> {
  factory _$OverviewStateCopyWith(_OverviewState value, $Res Function(_OverviewState) _then) = __$OverviewStateCopyWithImpl;
@override @useResult
$Res call({
 bool isInitialLoaded, List<ProjectModel> featuredProjects, AboutMeModel? aboutMe
});


@override $AboutMeModelCopyWith<$Res>? get aboutMe;

}
/// @nodoc
class __$OverviewStateCopyWithImpl<$Res>
    implements _$OverviewStateCopyWith<$Res> {
  __$OverviewStateCopyWithImpl(this._self, this._then);

  final _OverviewState _self;
  final $Res Function(_OverviewState) _then;

/// Create a copy of OverviewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isInitialLoaded = null,Object? featuredProjects = null,Object? aboutMe = freezed,}) {
  return _then(_OverviewState(
isInitialLoaded: null == isInitialLoaded ? _self.isInitialLoaded : isInitialLoaded // ignore: cast_nullable_to_non_nullable
as bool,featuredProjects: null == featuredProjects ? _self._featuredProjects : featuredProjects // ignore: cast_nullable_to_non_nullable
as List<ProjectModel>,aboutMe: freezed == aboutMe ? _self.aboutMe : aboutMe // ignore: cast_nullable_to_non_nullable
as AboutMeModel?,
  ));
}

/// Create a copy of OverviewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AboutMeModelCopyWith<$Res>? get aboutMe {
    if (_self.aboutMe == null) {
    return null;
  }

  return $AboutMeModelCopyWith<$Res>(_self.aboutMe!, (value) {
    return _then(_self.copyWith(aboutMe: value));
  });
}
}

// dart format on
