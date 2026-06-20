// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'about_me_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AboutMeIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AboutMeIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AboutMeIntent()';
}


}

/// @nodoc
class $AboutMeIntentCopyWith<$Res>  {
$AboutMeIntentCopyWith(AboutMeIntent _, $Res Function(AboutMeIntent) __);
}


/// Adds pattern-matching-related methods to [AboutMeIntent].
extension AboutMeIntentPatterns on AboutMeIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _PickImage value)?  pickImage,TResult Function( _RemoveImage value)?  removeImage,TResult Function( _Refresh value)?  refresh,TResult Function( _ShareApp value)?  shareApp,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PickImage() when pickImage != null:
return pickImage(_that);case _RemoveImage() when removeImage != null:
return removeImage(_that);case _Refresh() when refresh != null:
return refresh(_that);case _ShareApp() when shareApp != null:
return shareApp(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _PickImage value)  pickImage,required TResult Function( _RemoveImage value)  removeImage,required TResult Function( _Refresh value)  refresh,required TResult Function( _ShareApp value)  shareApp,}){
final _that = this;
switch (_that) {
case _PickImage():
return pickImage(_that);case _RemoveImage():
return removeImage(_that);case _Refresh():
return refresh(_that);case _ShareApp():
return shareApp(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _PickImage value)?  pickImage,TResult? Function( _RemoveImage value)?  removeImage,TResult? Function( _Refresh value)?  refresh,TResult? Function( _ShareApp value)?  shareApp,}){
final _that = this;
switch (_that) {
case _PickImage() when pickImage != null:
return pickImage(_that);case _RemoveImage() when removeImage != null:
return removeImage(_that);case _Refresh() when refresh != null:
return refresh(_that);case _ShareApp() when shareApp != null:
return shareApp(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ImageSource source)?  pickImage,TResult Function()?  removeImage,TResult Function()?  refresh,TResult Function()?  shareApp,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PickImage() when pickImage != null:
return pickImage(_that.source);case _RemoveImage() when removeImage != null:
return removeImage();case _Refresh() when refresh != null:
return refresh();case _ShareApp() when shareApp != null:
return shareApp();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ImageSource source)  pickImage,required TResult Function()  removeImage,required TResult Function()  refresh,required TResult Function()  shareApp,}) {final _that = this;
switch (_that) {
case _PickImage():
return pickImage(_that.source);case _RemoveImage():
return removeImage();case _Refresh():
return refresh();case _ShareApp():
return shareApp();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ImageSource source)?  pickImage,TResult? Function()?  removeImage,TResult? Function()?  refresh,TResult? Function()?  shareApp,}) {final _that = this;
switch (_that) {
case _PickImage() when pickImage != null:
return pickImage(_that.source);case _RemoveImage() when removeImage != null:
return removeImage();case _Refresh() when refresh != null:
return refresh();case _ShareApp() when shareApp != null:
return shareApp();case _:
  return null;

}
}

}

/// @nodoc


class _PickImage extends AboutMeIntent {
  const _PickImage(this.source): super._();
  

 final  ImageSource source;

/// Create a copy of AboutMeIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PickImageCopyWith<_PickImage> get copyWith => __$PickImageCopyWithImpl<_PickImage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PickImage&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,source);

@override
String toString() {
  return 'AboutMeIntent.pickImage(source: $source)';
}


}

/// @nodoc
abstract mixin class _$PickImageCopyWith<$Res> implements $AboutMeIntentCopyWith<$Res> {
  factory _$PickImageCopyWith(_PickImage value, $Res Function(_PickImage) _then) = __$PickImageCopyWithImpl;
@useResult
$Res call({
 ImageSource source
});




}
/// @nodoc
class __$PickImageCopyWithImpl<$Res>
    implements _$PickImageCopyWith<$Res> {
  __$PickImageCopyWithImpl(this._self, this._then);

  final _PickImage _self;
  final $Res Function(_PickImage) _then;

/// Create a copy of AboutMeIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? source = null,}) {
  return _then(_PickImage(
null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ImageSource,
  ));
}


}

/// @nodoc


class _RemoveImage extends AboutMeIntent {
  const _RemoveImage(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveImage);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AboutMeIntent.removeImage()';
}


}




/// @nodoc


class _Refresh extends AboutMeIntent {
  const _Refresh(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refresh);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AboutMeIntent.refresh()';
}


}




/// @nodoc


class _ShareApp extends AboutMeIntent {
  const _ShareApp(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShareApp);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AboutMeIntent.shareApp()';
}


}




// dart format on
