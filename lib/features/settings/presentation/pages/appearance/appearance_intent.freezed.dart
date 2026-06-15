// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appearance_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppearanceIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppearanceIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppearanceIntent()';
}


}

/// @nodoc
class $AppearanceIntentCopyWith<$Res>  {
$AppearanceIntentCopyWith(AppearanceIntent _, $Res Function(AppearanceIntent) __);
}


/// Adds pattern-matching-related methods to [AppearanceIntent].
extension AppearanceIntentPatterns on AppearanceIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _SetThemeMode value)?  setThemeMode,TResult Function( _SetAccentColor value)?  setAccentColor,TResult Function( _SetFontSize value)?  setFontSize,TResult Function( _SetUseDynamicColor value)?  setUseDynamicColor,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetThemeMode() when setThemeMode != null:
return setThemeMode(_that);case _SetAccentColor() when setAccentColor != null:
return setAccentColor(_that);case _SetFontSize() when setFontSize != null:
return setFontSize(_that);case _SetUseDynamicColor() when setUseDynamicColor != null:
return setUseDynamicColor(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _SetThemeMode value)  setThemeMode,required TResult Function( _SetAccentColor value)  setAccentColor,required TResult Function( _SetFontSize value)  setFontSize,required TResult Function( _SetUseDynamicColor value)  setUseDynamicColor,}){
final _that = this;
switch (_that) {
case _SetThemeMode():
return setThemeMode(_that);case _SetAccentColor():
return setAccentColor(_that);case _SetFontSize():
return setFontSize(_that);case _SetUseDynamicColor():
return setUseDynamicColor(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _SetThemeMode value)?  setThemeMode,TResult? Function( _SetAccentColor value)?  setAccentColor,TResult? Function( _SetFontSize value)?  setFontSize,TResult? Function( _SetUseDynamicColor value)?  setUseDynamicColor,}){
final _that = this;
switch (_that) {
case _SetThemeMode() when setThemeMode != null:
return setThemeMode(_that);case _SetAccentColor() when setAccentColor != null:
return setAccentColor(_that);case _SetFontSize() when setFontSize != null:
return setFontSize(_that);case _SetUseDynamicColor() when setUseDynamicColor != null:
return setUseDynamicColor(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ThemeMode mode)?  setThemeMode,TResult Function( Color color)?  setAccentColor,TResult Function( AppFontSize size)?  setFontSize,TResult Function( bool use)?  setUseDynamicColor,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetThemeMode() when setThemeMode != null:
return setThemeMode(_that.mode);case _SetAccentColor() when setAccentColor != null:
return setAccentColor(_that.color);case _SetFontSize() when setFontSize != null:
return setFontSize(_that.size);case _SetUseDynamicColor() when setUseDynamicColor != null:
return setUseDynamicColor(_that.use);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ThemeMode mode)  setThemeMode,required TResult Function( Color color)  setAccentColor,required TResult Function( AppFontSize size)  setFontSize,required TResult Function( bool use)  setUseDynamicColor,}) {final _that = this;
switch (_that) {
case _SetThemeMode():
return setThemeMode(_that.mode);case _SetAccentColor():
return setAccentColor(_that.color);case _SetFontSize():
return setFontSize(_that.size);case _SetUseDynamicColor():
return setUseDynamicColor(_that.use);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ThemeMode mode)?  setThemeMode,TResult? Function( Color color)?  setAccentColor,TResult? Function( AppFontSize size)?  setFontSize,TResult? Function( bool use)?  setUseDynamicColor,}) {final _that = this;
switch (_that) {
case _SetThemeMode() when setThemeMode != null:
return setThemeMode(_that.mode);case _SetAccentColor() when setAccentColor != null:
return setAccentColor(_that.color);case _SetFontSize() when setFontSize != null:
return setFontSize(_that.size);case _SetUseDynamicColor() when setUseDynamicColor != null:
return setUseDynamicColor(_that.use);case _:
  return null;

}
}

}

/// @nodoc


class _SetThemeMode extends AppearanceIntent {
  const _SetThemeMode(this.mode): super._();
  

 final  ThemeMode mode;

/// Create a copy of AppearanceIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetThemeModeCopyWith<_SetThemeMode> get copyWith => __$SetThemeModeCopyWithImpl<_SetThemeMode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetThemeMode&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'AppearanceIntent.setThemeMode(mode: $mode)';
}


}

/// @nodoc
abstract mixin class _$SetThemeModeCopyWith<$Res> implements $AppearanceIntentCopyWith<$Res> {
  factory _$SetThemeModeCopyWith(_SetThemeMode value, $Res Function(_SetThemeMode) _then) = __$SetThemeModeCopyWithImpl;
@useResult
$Res call({
 ThemeMode mode
});




}
/// @nodoc
class __$SetThemeModeCopyWithImpl<$Res>
    implements _$SetThemeModeCopyWith<$Res> {
  __$SetThemeModeCopyWithImpl(this._self, this._then);

  final _SetThemeMode _self;
  final $Res Function(_SetThemeMode) _then;

/// Create a copy of AppearanceIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mode = null,}) {
  return _then(_SetThemeMode(
null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}


}

/// @nodoc


class _SetAccentColor extends AppearanceIntent {
  const _SetAccentColor(this.color): super._();
  

 final  Color color;

/// Create a copy of AppearanceIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetAccentColorCopyWith<_SetAccentColor> get copyWith => __$SetAccentColorCopyWithImpl<_SetAccentColor>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetAccentColor&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,color);

@override
String toString() {
  return 'AppearanceIntent.setAccentColor(color: $color)';
}


}

/// @nodoc
abstract mixin class _$SetAccentColorCopyWith<$Res> implements $AppearanceIntentCopyWith<$Res> {
  factory _$SetAccentColorCopyWith(_SetAccentColor value, $Res Function(_SetAccentColor) _then) = __$SetAccentColorCopyWithImpl;
@useResult
$Res call({
 Color color
});




}
/// @nodoc
class __$SetAccentColorCopyWithImpl<$Res>
    implements _$SetAccentColorCopyWith<$Res> {
  __$SetAccentColorCopyWithImpl(this._self, this._then);

  final _SetAccentColor _self;
  final $Res Function(_SetAccentColor) _then;

/// Create a copy of AppearanceIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? color = null,}) {
  return _then(_SetAccentColor(
null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}


}

/// @nodoc


class _SetFontSize extends AppearanceIntent {
  const _SetFontSize(this.size): super._();
  

 final  AppFontSize size;

/// Create a copy of AppearanceIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetFontSizeCopyWith<_SetFontSize> get copyWith => __$SetFontSizeCopyWithImpl<_SetFontSize>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetFontSize&&(identical(other.size, size) || other.size == size));
}


@override
int get hashCode => Object.hash(runtimeType,size);

@override
String toString() {
  return 'AppearanceIntent.setFontSize(size: $size)';
}


}

/// @nodoc
abstract mixin class _$SetFontSizeCopyWith<$Res> implements $AppearanceIntentCopyWith<$Res> {
  factory _$SetFontSizeCopyWith(_SetFontSize value, $Res Function(_SetFontSize) _then) = __$SetFontSizeCopyWithImpl;
@useResult
$Res call({
 AppFontSize size
});




}
/// @nodoc
class __$SetFontSizeCopyWithImpl<$Res>
    implements _$SetFontSizeCopyWith<$Res> {
  __$SetFontSizeCopyWithImpl(this._self, this._then);

  final _SetFontSize _self;
  final $Res Function(_SetFontSize) _then;

/// Create a copy of AppearanceIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? size = null,}) {
  return _then(_SetFontSize(
null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as AppFontSize,
  ));
}


}

/// @nodoc


class _SetUseDynamicColor extends AppearanceIntent {
  const _SetUseDynamicColor(this.use): super._();
  

 final  bool use;

/// Create a copy of AppearanceIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetUseDynamicColorCopyWith<_SetUseDynamicColor> get copyWith => __$SetUseDynamicColorCopyWithImpl<_SetUseDynamicColor>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetUseDynamicColor&&(identical(other.use, use) || other.use == use));
}


@override
int get hashCode => Object.hash(runtimeType,use);

@override
String toString() {
  return 'AppearanceIntent.setUseDynamicColor(use: $use)';
}


}

/// @nodoc
abstract mixin class _$SetUseDynamicColorCopyWith<$Res> implements $AppearanceIntentCopyWith<$Res> {
  factory _$SetUseDynamicColorCopyWith(_SetUseDynamicColor value, $Res Function(_SetUseDynamicColor) _then) = __$SetUseDynamicColorCopyWithImpl;
@useResult
$Res call({
 bool use
});




}
/// @nodoc
class __$SetUseDynamicColorCopyWithImpl<$Res>
    implements _$SetUseDynamicColorCopyWith<$Res> {
  __$SetUseDynamicColorCopyWithImpl(this._self, this._then);

  final _SetUseDynamicColor _self;
  final $Res Function(_SetUseDynamicColor) _then;

/// Create a copy of AppearanceIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? use = null,}) {
  return _then(_SetUseDynamicColor(
null == use ? _self.use : use // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
