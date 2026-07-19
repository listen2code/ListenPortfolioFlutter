// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overview_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OverviewIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverviewIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OverviewIntent()';
}


}

/// @nodoc
class $OverviewIntentCopyWith<$Res>  {
$OverviewIntentCopyWith(OverviewIntent _, $Res Function(OverviewIntent) __);
}


/// Adds pattern-matching-related methods to [OverviewIntent].
extension OverviewIntentPatterns on OverviewIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Refresh value)?  refresh,TResult Function( _LaunchURL value)?  launchURL,TResult Function( _ContactMe value)?  contactMe,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Refresh() when refresh != null:
return refresh(_that);case _LaunchURL() when launchURL != null:
return launchURL(_that);case _ContactMe() when contactMe != null:
return contactMe(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Refresh value)  refresh,required TResult Function( _LaunchURL value)  launchURL,required TResult Function( _ContactMe value)  contactMe,}){
final _that = this;
switch (_that) {
case _Refresh():
return refresh(_that);case _LaunchURL():
return launchURL(_that);case _ContactMe():
return contactMe(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Refresh value)?  refresh,TResult? Function( _LaunchURL value)?  launchURL,TResult? Function( _ContactMe value)?  contactMe,}){
final _that = this;
switch (_that) {
case _Refresh() when refresh != null:
return refresh(_that);case _LaunchURL() when launchURL != null:
return launchURL(_that);case _ContactMe() when contactMe != null:
return contactMe(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  refresh,TResult Function( String url)?  launchURL,TResult Function( String email)?  contactMe,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Refresh() when refresh != null:
return refresh();case _LaunchURL() when launchURL != null:
return launchURL(_that.url);case _ContactMe() when contactMe != null:
return contactMe(_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  refresh,required TResult Function( String url)  launchURL,required TResult Function( String email)  contactMe,}) {final _that = this;
switch (_that) {
case _Refresh():
return refresh();case _LaunchURL():
return launchURL(_that.url);case _ContactMe():
return contactMe(_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  refresh,TResult? Function( String url)?  launchURL,TResult? Function( String email)?  contactMe,}) {final _that = this;
switch (_that) {
case _Refresh() when refresh != null:
return refresh();case _LaunchURL() when launchURL != null:
return launchURL(_that.url);case _ContactMe() when contactMe != null:
return contactMe(_that.email);case _:
  return null;

}
}

}

/// @nodoc


class _Refresh extends OverviewIntent {
  const _Refresh(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refresh);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OverviewIntent.refresh()';
}


}




/// @nodoc


class _LaunchURL extends OverviewIntent {
  const _LaunchURL(this.url): super._();
  

 final  String url;

/// Create a copy of OverviewIntent
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
  return 'OverviewIntent.launchURL(url: $url)';
}


}

/// @nodoc
abstract mixin class _$LaunchURLCopyWith<$Res> implements $OverviewIntentCopyWith<$Res> {
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

/// Create a copy of OverviewIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? url = null,}) {
  return _then(_LaunchURL(
null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ContactMe extends OverviewIntent {
  const _ContactMe(this.email): super._();
  

 final  String email;

/// Create a copy of OverviewIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactMeCopyWith<_ContactMe> get copyWith => __$ContactMeCopyWithImpl<_ContactMe>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactMe&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'OverviewIntent.contactMe(email: $email)';
}


}

/// @nodoc
abstract mixin class _$ContactMeCopyWith<$Res> implements $OverviewIntentCopyWith<$Res> {
  factory _$ContactMeCopyWith(_ContactMe value, $Res Function(_ContactMe) _then) = __$ContactMeCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class __$ContactMeCopyWithImpl<$Res>
    implements _$ContactMeCopyWith<$Res> {
  __$ContactMeCopyWithImpl(this._self, this._then);

  final _ContactMe _self;
  final $Res Function(_ContactMe) _then;

/// Create a copy of OverviewIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(_ContactMe(
null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
