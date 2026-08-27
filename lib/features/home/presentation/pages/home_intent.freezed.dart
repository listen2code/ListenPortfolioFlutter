// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeIntent()';
}


}

/// @nodoc
class $HomeIntentCopyWith<$Res>  {
$HomeIntentCopyWith(HomeIntent _, $Res Function(HomeIntent) __);
}


/// Adds pattern-matching-related methods to [HomeIntent].
extension HomeIntentPatterns on HomeIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _TabChanged value)?  tabChanged,TResult Function( _Logout value)?  logout,TResult Function( _ConfirmLogout value)?  confirmLogout,TResult Function( _ToSettings value)?  toSettings,TResult Function( _ToAppearance value)?  toAppearance,TResult Function( _HandleDeepLink value)?  handleDeepLink,TResult Function( _Init value)?  init,TResult Function( _PreviewAvatar value)?  previewAvatar,TResult Function( _CheckDeferredDeepLink value)?  checkDeferredDeepLink,TResult Function( _HandleDeferredDeepLink value)?  handleDeferredDeepLink,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TabChanged() when tabChanged != null:
return tabChanged(_that);case _Logout() when logout != null:
return logout(_that);case _ConfirmLogout() when confirmLogout != null:
return confirmLogout(_that);case _ToSettings() when toSettings != null:
return toSettings(_that);case _ToAppearance() when toAppearance != null:
return toAppearance(_that);case _HandleDeepLink() when handleDeepLink != null:
return handleDeepLink(_that);case _Init() when init != null:
return init(_that);case _PreviewAvatar() when previewAvatar != null:
return previewAvatar(_that);case _CheckDeferredDeepLink() when checkDeferredDeepLink != null:
return checkDeferredDeepLink(_that);case _HandleDeferredDeepLink() when handleDeferredDeepLink != null:
return handleDeferredDeepLink(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _TabChanged value)  tabChanged,required TResult Function( _Logout value)  logout,required TResult Function( _ConfirmLogout value)  confirmLogout,required TResult Function( _ToSettings value)  toSettings,required TResult Function( _ToAppearance value)  toAppearance,required TResult Function( _HandleDeepLink value)  handleDeepLink,required TResult Function( _Init value)  init,required TResult Function( _PreviewAvatar value)  previewAvatar,required TResult Function( _CheckDeferredDeepLink value)  checkDeferredDeepLink,required TResult Function( _HandleDeferredDeepLink value)  handleDeferredDeepLink,}){
final _that = this;
switch (_that) {
case _TabChanged():
return tabChanged(_that);case _Logout():
return logout(_that);case _ConfirmLogout():
return confirmLogout(_that);case _ToSettings():
return toSettings(_that);case _ToAppearance():
return toAppearance(_that);case _HandleDeepLink():
return handleDeepLink(_that);case _Init():
return init(_that);case _PreviewAvatar():
return previewAvatar(_that);case _CheckDeferredDeepLink():
return checkDeferredDeepLink(_that);case _HandleDeferredDeepLink():
return handleDeferredDeepLink(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _TabChanged value)?  tabChanged,TResult? Function( _Logout value)?  logout,TResult? Function( _ConfirmLogout value)?  confirmLogout,TResult? Function( _ToSettings value)?  toSettings,TResult? Function( _ToAppearance value)?  toAppearance,TResult? Function( _HandleDeepLink value)?  handleDeepLink,TResult? Function( _Init value)?  init,TResult? Function( _PreviewAvatar value)?  previewAvatar,TResult? Function( _CheckDeferredDeepLink value)?  checkDeferredDeepLink,TResult? Function( _HandleDeferredDeepLink value)?  handleDeferredDeepLink,}){
final _that = this;
switch (_that) {
case _TabChanged() when tabChanged != null:
return tabChanged(_that);case _Logout() when logout != null:
return logout(_that);case _ConfirmLogout() when confirmLogout != null:
return confirmLogout(_that);case _ToSettings() when toSettings != null:
return toSettings(_that);case _ToAppearance() when toAppearance != null:
return toAppearance(_that);case _HandleDeepLink() when handleDeepLink != null:
return handleDeepLink(_that);case _Init() when init != null:
return init(_that);case _PreviewAvatar() when previewAvatar != null:
return previewAvatar(_that);case _CheckDeferredDeepLink() when checkDeferredDeepLink != null:
return checkDeferredDeepLink(_that);case _HandleDeferredDeepLink() when handleDeferredDeepLink != null:
return handleDeferredDeepLink(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( HomeTab tab,  String? targetProjectBusinessId,  bool closeDrawer)?  tabChanged,TResult Function()?  logout,TResult Function()?  confirmLogout,TResult Function()?  toSettings,TResult Function()?  toAppearance,TResult Function( Uri uri)?  handleDeepLink,TResult Function()?  init,TResult Function()?  previewAvatar,TResult Function()?  checkDeferredDeepLink,TResult Function( InstallReferrerData data)?  handleDeferredDeepLink,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TabChanged() when tabChanged != null:
return tabChanged(_that.tab,_that.targetProjectBusinessId,_that.closeDrawer);case _Logout() when logout != null:
return logout();case _ConfirmLogout() when confirmLogout != null:
return confirmLogout();case _ToSettings() when toSettings != null:
return toSettings();case _ToAppearance() when toAppearance != null:
return toAppearance();case _HandleDeepLink() when handleDeepLink != null:
return handleDeepLink(_that.uri);case _Init() when init != null:
return init();case _PreviewAvatar() when previewAvatar != null:
return previewAvatar();case _CheckDeferredDeepLink() when checkDeferredDeepLink != null:
return checkDeferredDeepLink();case _HandleDeferredDeepLink() when handleDeferredDeepLink != null:
return handleDeferredDeepLink(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( HomeTab tab,  String? targetProjectBusinessId,  bool closeDrawer)  tabChanged,required TResult Function()  logout,required TResult Function()  confirmLogout,required TResult Function()  toSettings,required TResult Function()  toAppearance,required TResult Function( Uri uri)  handleDeepLink,required TResult Function()  init,required TResult Function()  previewAvatar,required TResult Function()  checkDeferredDeepLink,required TResult Function( InstallReferrerData data)  handleDeferredDeepLink,}) {final _that = this;
switch (_that) {
case _TabChanged():
return tabChanged(_that.tab,_that.targetProjectBusinessId,_that.closeDrawer);case _Logout():
return logout();case _ConfirmLogout():
return confirmLogout();case _ToSettings():
return toSettings();case _ToAppearance():
return toAppearance();case _HandleDeepLink():
return handleDeepLink(_that.uri);case _Init():
return init();case _PreviewAvatar():
return previewAvatar();case _CheckDeferredDeepLink():
return checkDeferredDeepLink();case _HandleDeferredDeepLink():
return handleDeferredDeepLink(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( HomeTab tab,  String? targetProjectBusinessId,  bool closeDrawer)?  tabChanged,TResult? Function()?  logout,TResult? Function()?  confirmLogout,TResult? Function()?  toSettings,TResult? Function()?  toAppearance,TResult? Function( Uri uri)?  handleDeepLink,TResult? Function()?  init,TResult? Function()?  previewAvatar,TResult? Function()?  checkDeferredDeepLink,TResult? Function( InstallReferrerData data)?  handleDeferredDeepLink,}) {final _that = this;
switch (_that) {
case _TabChanged() when tabChanged != null:
return tabChanged(_that.tab,_that.targetProjectBusinessId,_that.closeDrawer);case _Logout() when logout != null:
return logout();case _ConfirmLogout() when confirmLogout != null:
return confirmLogout();case _ToSettings() when toSettings != null:
return toSettings();case _ToAppearance() when toAppearance != null:
return toAppearance();case _HandleDeepLink() when handleDeepLink != null:
return handleDeepLink(_that.uri);case _Init() when init != null:
return init();case _PreviewAvatar() when previewAvatar != null:
return previewAvatar();case _CheckDeferredDeepLink() when checkDeferredDeepLink != null:
return checkDeferredDeepLink();case _HandleDeferredDeepLink() when handleDeferredDeepLink != null:
return handleDeferredDeepLink(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _TabChanged extends HomeIntent {
  const _TabChanged(this.tab, {this.targetProjectBusinessId, this.closeDrawer = false}): super._();
  

 final  HomeTab tab;
 final  String? targetProjectBusinessId;
@JsonKey() final  bool closeDrawer;

/// Create a copy of HomeIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TabChangedCopyWith<_TabChanged> get copyWith => __$TabChangedCopyWithImpl<_TabChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TabChanged&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.targetProjectBusinessId, targetProjectBusinessId) || other.targetProjectBusinessId == targetProjectBusinessId)&&(identical(other.closeDrawer, closeDrawer) || other.closeDrawer == closeDrawer));
}


@override
int get hashCode => Object.hash(runtimeType,tab,targetProjectBusinessId,closeDrawer);

@override
String toString() {
  return 'HomeIntent.tabChanged(tab: $tab, targetProjectBusinessId: $targetProjectBusinessId, closeDrawer: $closeDrawer)';
}


}

/// @nodoc
abstract mixin class _$TabChangedCopyWith<$Res> implements $HomeIntentCopyWith<$Res> {
  factory _$TabChangedCopyWith(_TabChanged value, $Res Function(_TabChanged) _then) = __$TabChangedCopyWithImpl;
@useResult
$Res call({
 HomeTab tab, String? targetProjectBusinessId, bool closeDrawer
});




}
/// @nodoc
class __$TabChangedCopyWithImpl<$Res>
    implements _$TabChangedCopyWith<$Res> {
  __$TabChangedCopyWithImpl(this._self, this._then);

  final _TabChanged _self;
  final $Res Function(_TabChanged) _then;

/// Create a copy of HomeIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tab = null,Object? targetProjectBusinessId = freezed,Object? closeDrawer = null,}) {
  return _then(_TabChanged(
null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as HomeTab,targetProjectBusinessId: freezed == targetProjectBusinessId ? _self.targetProjectBusinessId : targetProjectBusinessId // ignore: cast_nullable_to_non_nullable
as String?,closeDrawer: null == closeDrawer ? _self.closeDrawer : closeDrawer // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Logout extends HomeIntent {
  const _Logout(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Logout);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeIntent.logout()';
}


}




/// @nodoc


class _ConfirmLogout extends HomeIntent {
  const _ConfirmLogout(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfirmLogout);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeIntent.confirmLogout()';
}


}




/// @nodoc


class _ToSettings extends HomeIntent {
  const _ToSettings(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToSettings);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeIntent.toSettings()';
}


}




/// @nodoc


class _ToAppearance extends HomeIntent {
  const _ToAppearance(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToAppearance);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeIntent.toAppearance()';
}


}




/// @nodoc


class _HandleDeepLink extends HomeIntent {
  const _HandleDeepLink(this.uri): super._();
  

 final  Uri uri;

/// Create a copy of HomeIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HandleDeepLinkCopyWith<_HandleDeepLink> get copyWith => __$HandleDeepLinkCopyWithImpl<_HandleDeepLink>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HandleDeepLink&&(identical(other.uri, uri) || other.uri == uri));
}


@override
int get hashCode => Object.hash(runtimeType,uri);

@override
String toString() {
  return 'HomeIntent.handleDeepLink(uri: $uri)';
}


}

/// @nodoc
abstract mixin class _$HandleDeepLinkCopyWith<$Res> implements $HomeIntentCopyWith<$Res> {
  factory _$HandleDeepLinkCopyWith(_HandleDeepLink value, $Res Function(_HandleDeepLink) _then) = __$HandleDeepLinkCopyWithImpl;
@useResult
$Res call({
 Uri uri
});




}
/// @nodoc
class __$HandleDeepLinkCopyWithImpl<$Res>
    implements _$HandleDeepLinkCopyWith<$Res> {
  __$HandleDeepLinkCopyWithImpl(this._self, this._then);

  final _HandleDeepLink _self;
  final $Res Function(_HandleDeepLink) _then;

/// Create a copy of HomeIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? uri = null,}) {
  return _then(_HandleDeepLink(
null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as Uri,
  ));
}


}

/// @nodoc


class _Init extends HomeIntent {
  const _Init(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Init);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeIntent.init()';
}


}




/// @nodoc


class _PreviewAvatar extends HomeIntent {
  const _PreviewAvatar(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreviewAvatar);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeIntent.previewAvatar()';
}


}




/// @nodoc


class _CheckDeferredDeepLink extends HomeIntent {
  const _CheckDeferredDeepLink(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckDeferredDeepLink);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeIntent.checkDeferredDeepLink()';
}


}




/// @nodoc


class _HandleDeferredDeepLink extends HomeIntent {
  const _HandleDeferredDeepLink(this.data): super._();
  

 final  InstallReferrerData data;

/// Create a copy of HomeIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HandleDeferredDeepLinkCopyWith<_HandleDeferredDeepLink> get copyWith => __$HandleDeferredDeepLinkCopyWithImpl<_HandleDeferredDeepLink>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HandleDeferredDeepLink&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'HomeIntent.handleDeferredDeepLink(data: $data)';
}


}

/// @nodoc
abstract mixin class _$HandleDeferredDeepLinkCopyWith<$Res> implements $HomeIntentCopyWith<$Res> {
  factory _$HandleDeferredDeepLinkCopyWith(_HandleDeferredDeepLink value, $Res Function(_HandleDeferredDeepLink) _then) = __$HandleDeferredDeepLinkCopyWithImpl;
@useResult
$Res call({
 InstallReferrerData data
});




}
/// @nodoc
class __$HandleDeferredDeepLinkCopyWithImpl<$Res>
    implements _$HandleDeferredDeepLinkCopyWith<$Res> {
  __$HandleDeferredDeepLinkCopyWithImpl(this._self, this._then);

  final _HandleDeferredDeepLink _self;
  final $Res Function(_HandleDeferredDeepLink) _then;

/// Create a copy of HomeIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_HandleDeferredDeepLink(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as InstallReferrerData,
  ));
}


}

// dart format on
