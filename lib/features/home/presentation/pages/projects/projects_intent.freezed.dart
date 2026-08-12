// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'projects_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectsIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectsIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProjectsIntent()';
}


}

/// @nodoc
class $ProjectsIntentCopyWith<$Res>  {
$ProjectsIntentCopyWith(ProjectsIntent _, $Res Function(ProjectsIntent) __);
}


/// Adds pattern-matching-related methods to [ProjectsIntent].
extension ProjectsIntentPatterns on ProjectsIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Refresh value)?  refresh,TResult Function( _LaunchURL value)?  launchURL,TResult Function( _ScrollToProject value)?  scrollToProject,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Refresh() when refresh != null:
return refresh(_that);case _LaunchURL() when launchURL != null:
return launchURL(_that);case _ScrollToProject() when scrollToProject != null:
return scrollToProject(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Refresh value)  refresh,required TResult Function( _LaunchURL value)  launchURL,required TResult Function( _ScrollToProject value)  scrollToProject,}){
final _that = this;
switch (_that) {
case _Refresh():
return refresh(_that);case _LaunchURL():
return launchURL(_that);case _ScrollToProject():
return scrollToProject(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Refresh value)?  refresh,TResult? Function( _LaunchURL value)?  launchURL,TResult? Function( _ScrollToProject value)?  scrollToProject,}){
final _that = this;
switch (_that) {
case _Refresh() when refresh != null:
return refresh(_that);case _LaunchURL() when launchURL != null:
return launchURL(_that);case _ScrollToProject() when scrollToProject != null:
return scrollToProject(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  refresh,TResult Function( String url)?  launchURL,TResult Function( String businessId)?  scrollToProject,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Refresh() when refresh != null:
return refresh();case _LaunchURL() when launchURL != null:
return launchURL(_that.url);case _ScrollToProject() when scrollToProject != null:
return scrollToProject(_that.businessId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  refresh,required TResult Function( String url)  launchURL,required TResult Function( String businessId)  scrollToProject,}) {final _that = this;
switch (_that) {
case _Refresh():
return refresh();case _LaunchURL():
return launchURL(_that.url);case _ScrollToProject():
return scrollToProject(_that.businessId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  refresh,TResult? Function( String url)?  launchURL,TResult? Function( String businessId)?  scrollToProject,}) {final _that = this;
switch (_that) {
case _Refresh() when refresh != null:
return refresh();case _LaunchURL() when launchURL != null:
return launchURL(_that.url);case _ScrollToProject() when scrollToProject != null:
return scrollToProject(_that.businessId);case _:
  return null;

}
}

}

/// @nodoc


class _Refresh extends ProjectsIntent {
  const _Refresh(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refresh);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProjectsIntent.refresh()';
}


}




/// @nodoc


class _LaunchURL extends ProjectsIntent {
  const _LaunchURL(this.url): super._();
  

 final  String url;

/// Create a copy of ProjectsIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LaunchURLCopyWith<_LaunchURL> get copyWith => __$LaunchURLCopyWithImpl<_LaunchURL>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LaunchURL&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'ProjectsIntent.launchURL(url: $url)';
}


}

/// @nodoc
abstract mixin class _$LaunchURLCopyWith<$Res> implements $ProjectsIntentCopyWith<$Res> {
  factory _$LaunchURLCopyWith(_LaunchURL value, $Res Function(_LaunchURL) _then) = __$LaunchURLCopyWithImpl;
@useResult
$Res call({
 String url
});




}
/// @nodoc
class __$LaunchURLCopyWithImpl<$Res>
    implements _$LaunchURLCopyWith<$Res> {
  __$LaunchURLCopyWithImpl(this._self, this._then);

  final _LaunchURL _self;
  final $Res Function(_LaunchURL) _then;

/// Create a copy of ProjectsIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? url = null,}) {
  return _then(_LaunchURL(
null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ScrollToProject extends ProjectsIntent {
  const _ScrollToProject(this.businessId): super._();
  

 final  String businessId;

/// Create a copy of ProjectsIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScrollToProjectCopyWith<_ScrollToProject> get copyWith => __$ScrollToProjectCopyWithImpl<_ScrollToProject>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScrollToProject&&(identical(other.businessId, businessId) || other.businessId == businessId));
}


@override
int get hashCode => Object.hash(runtimeType,businessId);

@override
String toString() {
  return 'ProjectsIntent.scrollToProject(businessId: $businessId)';
}


}

/// @nodoc
abstract mixin class _$ScrollToProjectCopyWith<$Res> implements $ProjectsIntentCopyWith<$Res> {
  factory _$ScrollToProjectCopyWith(_ScrollToProject value, $Res Function(_ScrollToProject) _then) = __$ScrollToProjectCopyWithImpl;
@useResult
$Res call({
 String businessId
});




}
/// @nodoc
class __$ScrollToProjectCopyWithImpl<$Res>
    implements _$ScrollToProjectCopyWith<$Res> {
  __$ScrollToProjectCopyWithImpl(this._self, this._then);

  final _ScrollToProject _self;
  final $Res Function(_ScrollToProject) _then;

/// Create a copy of ProjectsIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? businessId = null,}) {
  return _then(_ScrollToProject(
null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
