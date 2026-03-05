// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'projects_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectsState {

 List<Map<String, dynamic>> get projects; bool get isInitialLoaded;
/// Create a copy of ProjectsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectsStateCopyWith<ProjectsState> get copyWith => _$ProjectsStateCopyWithImpl<ProjectsState>(this as ProjectsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectsState&&const DeepCollectionEquality().equals(other.projects, projects)&&(identical(other.isInitialLoaded, isInitialLoaded) || other.isInitialLoaded == isInitialLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(projects),isInitialLoaded);

@override
String toString() {
  return 'ProjectsState(projects: $projects, isInitialLoaded: $isInitialLoaded)';
}


}

/// @nodoc
abstract mixin class $ProjectsStateCopyWith<$Res>  {
  factory $ProjectsStateCopyWith(ProjectsState value, $Res Function(ProjectsState) _then) = _$ProjectsStateCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> projects, bool isInitialLoaded
});




}
/// @nodoc
class _$ProjectsStateCopyWithImpl<$Res>
    implements $ProjectsStateCopyWith<$Res> {
  _$ProjectsStateCopyWithImpl(this._self, this._then);

  final ProjectsState _self;
  final $Res Function(ProjectsState) _then;

/// Create a copy of ProjectsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projects = null,Object? isInitialLoaded = null,}) {
  return _then(_self.copyWith(
projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isInitialLoaded: null == isInitialLoaded ? _self.isInitialLoaded : isInitialLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectsState].
extension ProjectsStatePatterns on ProjectsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectsState value)  $default,){
final _that = this;
switch (_that) {
case _ProjectsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectsState value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> projects,  bool isInitialLoaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectsState() when $default != null:
return $default(_that.projects,_that.isInitialLoaded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> projects,  bool isInitialLoaded)  $default,) {final _that = this;
switch (_that) {
case _ProjectsState():
return $default(_that.projects,_that.isInitialLoaded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Map<String, dynamic>> projects,  bool isInitialLoaded)?  $default,) {final _that = this;
switch (_that) {
case _ProjectsState() when $default != null:
return $default(_that.projects,_that.isInitialLoaded);case _:
  return null;

}
}

}

/// @nodoc


class _ProjectsState extends ProjectsState {
  const _ProjectsState({final  List<Map<String, dynamic>> projects = const [], this.isInitialLoaded = false}): _projects = projects,super._();
  

 final  List<Map<String, dynamic>> _projects;
@override@JsonKey() List<Map<String, dynamic>> get projects {
  if (_projects is EqualUnmodifiableListView) return _projects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_projects);
}

@override@JsonKey() final  bool isInitialLoaded;

/// Create a copy of ProjectsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectsStateCopyWith<_ProjectsState> get copyWith => __$ProjectsStateCopyWithImpl<_ProjectsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectsState&&const DeepCollectionEquality().equals(other._projects, _projects)&&(identical(other.isInitialLoaded, isInitialLoaded) || other.isInitialLoaded == isInitialLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_projects),isInitialLoaded);

@override
String toString() {
  return 'ProjectsState(projects: $projects, isInitialLoaded: $isInitialLoaded)';
}


}

/// @nodoc
abstract mixin class _$ProjectsStateCopyWith<$Res> implements $ProjectsStateCopyWith<$Res> {
  factory _$ProjectsStateCopyWith(_ProjectsState value, $Res Function(_ProjectsState) _then) = __$ProjectsStateCopyWithImpl;
@override @useResult
$Res call({
 List<Map<String, dynamic>> projects, bool isInitialLoaded
});




}
/// @nodoc
class __$ProjectsStateCopyWithImpl<$Res>
    implements _$ProjectsStateCopyWith<$Res> {
  __$ProjectsStateCopyWithImpl(this._self, this._then);

  final _ProjectsState _self;
  final $Res Function(_ProjectsState) _then;

/// Create a copy of ProjectsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projects = null,Object? isInitialLoaded = null,}) {
  return _then(_ProjectsState(
projects: null == projects ? _self._projects : projects // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isInitialLoaded: null == isInitialLoaded ? _self.isInitialLoaded : isInitialLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
