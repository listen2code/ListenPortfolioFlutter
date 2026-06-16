// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsIntent()';
}


}

/// @nodoc
class $SettingsIntentCopyWith<$Res>  {
$SettingsIntentCopyWith(SettingsIntent _, $Res Function(SettingsIntent) __);
}


/// Adds pattern-matching-related methods to [SettingsIntent].
extension SettingsIntentPatterns on SettingsIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Init value)?  init,TResult Function( _ToggleNotifications value)?  toggleNotifications,TResult Function( _ClearCache value)?  clearCache,TResult Function( _ResetSettings value)?  resetSettings,TResult Function( _SwitchLanguage value)?  switchLanguage,TResult Function( _SwitchEnv value)?  switchEnv,TResult Function( _ToggleLogOverlay value)?  toggleLogOverlay,TResult Function( _CheckUpdates value)?  checkUpdates,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that);case _ToggleNotifications() when toggleNotifications != null:
return toggleNotifications(_that);case _ClearCache() when clearCache != null:
return clearCache(_that);case _ResetSettings() when resetSettings != null:
return resetSettings(_that);case _SwitchLanguage() when switchLanguage != null:
return switchLanguage(_that);case _SwitchEnv() when switchEnv != null:
return switchEnv(_that);case _ToggleLogOverlay() when toggleLogOverlay != null:
return toggleLogOverlay(_that);case _CheckUpdates() when checkUpdates != null:
return checkUpdates(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Init value)  init,required TResult Function( _ToggleNotifications value)  toggleNotifications,required TResult Function( _ClearCache value)  clearCache,required TResult Function( _ResetSettings value)  resetSettings,required TResult Function( _SwitchLanguage value)  switchLanguage,required TResult Function( _SwitchEnv value)  switchEnv,required TResult Function( _ToggleLogOverlay value)  toggleLogOverlay,required TResult Function( _CheckUpdates value)  checkUpdates,}){
final _that = this;
switch (_that) {
case _Init():
return init(_that);case _ToggleNotifications():
return toggleNotifications(_that);case _ClearCache():
return clearCache(_that);case _ResetSettings():
return resetSettings(_that);case _SwitchLanguage():
return switchLanguage(_that);case _SwitchEnv():
return switchEnv(_that);case _ToggleLogOverlay():
return toggleLogOverlay(_that);case _CheckUpdates():
return checkUpdates(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Init value)?  init,TResult? Function( _ToggleNotifications value)?  toggleNotifications,TResult? Function( _ClearCache value)?  clearCache,TResult? Function( _ResetSettings value)?  resetSettings,TResult? Function( _SwitchLanguage value)?  switchLanguage,TResult? Function( _SwitchEnv value)?  switchEnv,TResult? Function( _ToggleLogOverlay value)?  toggleLogOverlay,TResult? Function( _CheckUpdates value)?  checkUpdates,}){
final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that);case _ToggleNotifications() when toggleNotifications != null:
return toggleNotifications(_that);case _ClearCache() when clearCache != null:
return clearCache(_that);case _ResetSettings() when resetSettings != null:
return resetSettings(_that);case _SwitchLanguage() when switchLanguage != null:
return switchLanguage(_that);case _SwitchEnv() when switchEnv != null:
return switchEnv(_that);case _ToggleLogOverlay() when toggleLogOverlay != null:
return toggleLogOverlay(_that);case _CheckUpdates() when checkUpdates != null:
return checkUpdates(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  init,TResult Function( bool enabled)?  toggleNotifications,TResult Function()?  clearCache,TResult Function()?  resetSettings,TResult Function( AppLanguage language)?  switchLanguage,TResult Function( AppEnvironment env)?  switchEnv,TResult Function( bool enabled)?  toggleLogOverlay,TResult Function()?  checkUpdates,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Init() when init != null:
return init();case _ToggleNotifications() when toggleNotifications != null:
return toggleNotifications(_that.enabled);case _ClearCache() when clearCache != null:
return clearCache();case _ResetSettings() when resetSettings != null:
return resetSettings();case _SwitchLanguage() when switchLanguage != null:
return switchLanguage(_that.language);case _SwitchEnv() when switchEnv != null:
return switchEnv(_that.env);case _ToggleLogOverlay() when toggleLogOverlay != null:
return toggleLogOverlay(_that.enabled);case _CheckUpdates() when checkUpdates != null:
return checkUpdates();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  init,required TResult Function( bool enabled)  toggleNotifications,required TResult Function()  clearCache,required TResult Function()  resetSettings,required TResult Function( AppLanguage language)  switchLanguage,required TResult Function( AppEnvironment env)  switchEnv,required TResult Function( bool enabled)  toggleLogOverlay,required TResult Function()  checkUpdates,}) {final _that = this;
switch (_that) {
case _Init():
return init();case _ToggleNotifications():
return toggleNotifications(_that.enabled);case _ClearCache():
return clearCache();case _ResetSettings():
return resetSettings();case _SwitchLanguage():
return switchLanguage(_that.language);case _SwitchEnv():
return switchEnv(_that.env);case _ToggleLogOverlay():
return toggleLogOverlay(_that.enabled);case _CheckUpdates():
return checkUpdates();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  init,TResult? Function( bool enabled)?  toggleNotifications,TResult? Function()?  clearCache,TResult? Function()?  resetSettings,TResult? Function( AppLanguage language)?  switchLanguage,TResult? Function( AppEnvironment env)?  switchEnv,TResult? Function( bool enabled)?  toggleLogOverlay,TResult? Function()?  checkUpdates,}) {final _that = this;
switch (_that) {
case _Init() when init != null:
return init();case _ToggleNotifications() when toggleNotifications != null:
return toggleNotifications(_that.enabled);case _ClearCache() when clearCache != null:
return clearCache();case _ResetSettings() when resetSettings != null:
return resetSettings();case _SwitchLanguage() when switchLanguage != null:
return switchLanguage(_that.language);case _SwitchEnv() when switchEnv != null:
return switchEnv(_that.env);case _ToggleLogOverlay() when toggleLogOverlay != null:
return toggleLogOverlay(_that.enabled);case _CheckUpdates() when checkUpdates != null:
return checkUpdates();case _:
  return null;

}
}

}

/// @nodoc


class _Init extends SettingsIntent {
  const _Init(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Init);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsIntent.init()';
}


}




/// @nodoc


class _ToggleNotifications extends SettingsIntent {
  const _ToggleNotifications(this.enabled): super._();
  

 final  bool enabled;

/// Create a copy of SettingsIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToggleNotificationsCopyWith<_ToggleNotifications> get copyWith => __$ToggleNotificationsCopyWithImpl<_ToggleNotifications>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleNotifications&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,enabled);

@override
String toString() {
  return 'SettingsIntent.toggleNotifications(enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$ToggleNotificationsCopyWith<$Res> implements $SettingsIntentCopyWith<$Res> {
  factory _$ToggleNotificationsCopyWith(_ToggleNotifications value, $Res Function(_ToggleNotifications) _then) = __$ToggleNotificationsCopyWithImpl;
@useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class __$ToggleNotificationsCopyWithImpl<$Res>
    implements _$ToggleNotificationsCopyWith<$Res> {
  __$ToggleNotificationsCopyWithImpl(this._self, this._then);

  final _ToggleNotifications _self;
  final $Res Function(_ToggleNotifications) _then;

/// Create a copy of SettingsIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enabled = null,}) {
  return _then(_ToggleNotifications(
null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _ClearCache extends SettingsIntent {
  const _ClearCache(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClearCache);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsIntent.clearCache()';
}


}




/// @nodoc


class _ResetSettings extends SettingsIntent {
  const _ResetSettings(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResetSettings);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsIntent.resetSettings()';
}


}




/// @nodoc


class _SwitchLanguage extends SettingsIntent {
  const _SwitchLanguage(this.language): super._();
  

 final  AppLanguage language;

/// Create a copy of SettingsIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwitchLanguageCopyWith<_SwitchLanguage> get copyWith => __$SwitchLanguageCopyWithImpl<_SwitchLanguage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwitchLanguage&&(identical(other.language, language) || other.language == language));
}


@override
int get hashCode => Object.hash(runtimeType,language);

@override
String toString() {
  return 'SettingsIntent.switchLanguage(language: $language)';
}


}

/// @nodoc
abstract mixin class _$SwitchLanguageCopyWith<$Res> implements $SettingsIntentCopyWith<$Res> {
  factory _$SwitchLanguageCopyWith(_SwitchLanguage value, $Res Function(_SwitchLanguage) _then) = __$SwitchLanguageCopyWithImpl;
@useResult
$Res call({
 AppLanguage language
});




}
/// @nodoc
class __$SwitchLanguageCopyWithImpl<$Res>
    implements _$SwitchLanguageCopyWith<$Res> {
  __$SwitchLanguageCopyWithImpl(this._self, this._then);

  final _SwitchLanguage _self;
  final $Res Function(_SwitchLanguage) _then;

/// Create a copy of SettingsIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? language = null,}) {
  return _then(_SwitchLanguage(
null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as AppLanguage,
  ));
}


}

/// @nodoc


class _SwitchEnv extends SettingsIntent {
  const _SwitchEnv(this.env): super._();
  

 final  AppEnvironment env;

/// Create a copy of SettingsIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwitchEnvCopyWith<_SwitchEnv> get copyWith => __$SwitchEnvCopyWithImpl<_SwitchEnv>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwitchEnv&&(identical(other.env, env) || other.env == env));
}


@override
int get hashCode => Object.hash(runtimeType,env);

@override
String toString() {
  return 'SettingsIntent.switchEnv(env: $env)';
}


}

/// @nodoc
abstract mixin class _$SwitchEnvCopyWith<$Res> implements $SettingsIntentCopyWith<$Res> {
  factory _$SwitchEnvCopyWith(_SwitchEnv value, $Res Function(_SwitchEnv) _then) = __$SwitchEnvCopyWithImpl;
@useResult
$Res call({
 AppEnvironment env
});




}
/// @nodoc
class __$SwitchEnvCopyWithImpl<$Res>
    implements _$SwitchEnvCopyWith<$Res> {
  __$SwitchEnvCopyWithImpl(this._self, this._then);

  final _SwitchEnv _self;
  final $Res Function(_SwitchEnv) _then;

/// Create a copy of SettingsIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? env = null,}) {
  return _then(_SwitchEnv(
null == env ? _self.env : env // ignore: cast_nullable_to_non_nullable
as AppEnvironment,
  ));
}


}

/// @nodoc


class _ToggleLogOverlay extends SettingsIntent {
  const _ToggleLogOverlay(this.enabled): super._();
  

 final  bool enabled;

/// Create a copy of SettingsIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToggleLogOverlayCopyWith<_ToggleLogOverlay> get copyWith => __$ToggleLogOverlayCopyWithImpl<_ToggleLogOverlay>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleLogOverlay&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,enabled);

@override
String toString() {
  return 'SettingsIntent.toggleLogOverlay(enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$ToggleLogOverlayCopyWith<$Res> implements $SettingsIntentCopyWith<$Res> {
  factory _$ToggleLogOverlayCopyWith(_ToggleLogOverlay value, $Res Function(_ToggleLogOverlay) _then) = __$ToggleLogOverlayCopyWithImpl;
@useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class __$ToggleLogOverlayCopyWithImpl<$Res>
    implements _$ToggleLogOverlayCopyWith<$Res> {
  __$ToggleLogOverlayCopyWithImpl(this._self, this._then);

  final _ToggleLogOverlay _self;
  final $Res Function(_ToggleLogOverlay) _then;

/// Create a copy of SettingsIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enabled = null,}) {
  return _then(_ToggleLogOverlay(
null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _CheckUpdates extends SettingsIntent {
  const _CheckUpdates(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckUpdates);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsIntent.checkUpdates()';
}


}




// dart format on
