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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _PickImage value)?  pickImage,TResult Function( _ImagePicked value)?  imagePicked,TResult Function( _ImageCropped value)?  imageCropped,TResult Function( _RemoveImage value)?  removeImage,TResult Function( _Refresh value)?  refresh,TResult Function( _ShareApp value)?  shareApp,TResult Function( _ToResume value)?  toResume,TResult Function( _ShowPickerMenu value)?  showPickerMenu,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PickImage() when pickImage != null:
return pickImage(_that);case _ImagePicked() when imagePicked != null:
return imagePicked(_that);case _ImageCropped() when imageCropped != null:
return imageCropped(_that);case _RemoveImage() when removeImage != null:
return removeImage(_that);case _Refresh() when refresh != null:
return refresh(_that);case _ShareApp() when shareApp != null:
return shareApp(_that);case _ToResume() when toResume != null:
return toResume(_that);case _ShowPickerMenu() when showPickerMenu != null:
return showPickerMenu(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _PickImage value)  pickImage,required TResult Function( _ImagePicked value)  imagePicked,required TResult Function( _ImageCropped value)  imageCropped,required TResult Function( _RemoveImage value)  removeImage,required TResult Function( _Refresh value)  refresh,required TResult Function( _ShareApp value)  shareApp,required TResult Function( _ToResume value)  toResume,required TResult Function( _ShowPickerMenu value)  showPickerMenu,}){
final _that = this;
switch (_that) {
case _PickImage():
return pickImage(_that);case _ImagePicked():
return imagePicked(_that);case _ImageCropped():
return imageCropped(_that);case _RemoveImage():
return removeImage(_that);case _Refresh():
return refresh(_that);case _ShareApp():
return shareApp(_that);case _ToResume():
return toResume(_that);case _ShowPickerMenu():
return showPickerMenu(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _PickImage value)?  pickImage,TResult? Function( _ImagePicked value)?  imagePicked,TResult? Function( _ImageCropped value)?  imageCropped,TResult? Function( _RemoveImage value)?  removeImage,TResult? Function( _Refresh value)?  refresh,TResult? Function( _ShareApp value)?  shareApp,TResult? Function( _ToResume value)?  toResume,TResult? Function( _ShowPickerMenu value)?  showPickerMenu,}){
final _that = this;
switch (_that) {
case _PickImage() when pickImage != null:
return pickImage(_that);case _ImagePicked() when imagePicked != null:
return imagePicked(_that);case _ImageCropped() when imageCropped != null:
return imageCropped(_that);case _RemoveImage() when removeImage != null:
return removeImage(_that);case _Refresh() when refresh != null:
return refresh(_that);case _ShareApp() when shareApp != null:
return shareApp(_that);case _ToResume() when toResume != null:
return toResume(_that);case _ShowPickerMenu() when showPickerMenu != null:
return showPickerMenu(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ImageSource source)?  pickImage,TResult Function( File? file)?  imagePicked,TResult Function( File file)?  imageCropped,TResult Function()?  removeImage,TResult Function()?  refresh,TResult Function()?  shareApp,TResult Function()?  toResume,TResult Function()?  showPickerMenu,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PickImage() when pickImage != null:
return pickImage(_that.source);case _ImagePicked() when imagePicked != null:
return imagePicked(_that.file);case _ImageCropped() when imageCropped != null:
return imageCropped(_that.file);case _RemoveImage() when removeImage != null:
return removeImage();case _Refresh() when refresh != null:
return refresh();case _ShareApp() when shareApp != null:
return shareApp();case _ToResume() when toResume != null:
return toResume();case _ShowPickerMenu() when showPickerMenu != null:
return showPickerMenu();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ImageSource source)  pickImage,required TResult Function( File? file)  imagePicked,required TResult Function( File file)  imageCropped,required TResult Function()  removeImage,required TResult Function()  refresh,required TResult Function()  shareApp,required TResult Function()  toResume,required TResult Function()  showPickerMenu,}) {final _that = this;
switch (_that) {
case _PickImage():
return pickImage(_that.source);case _ImagePicked():
return imagePicked(_that.file);case _ImageCropped():
return imageCropped(_that.file);case _RemoveImage():
return removeImage();case _Refresh():
return refresh();case _ShareApp():
return shareApp();case _ToResume():
return toResume();case _ShowPickerMenu():
return showPickerMenu();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ImageSource source)?  pickImage,TResult? Function( File? file)?  imagePicked,TResult? Function( File file)?  imageCropped,TResult? Function()?  removeImage,TResult? Function()?  refresh,TResult? Function()?  shareApp,TResult? Function()?  toResume,TResult? Function()?  showPickerMenu,}) {final _that = this;
switch (_that) {
case _PickImage() when pickImage != null:
return pickImage(_that.source);case _ImagePicked() when imagePicked != null:
return imagePicked(_that.file);case _ImageCropped() when imageCropped != null:
return imageCropped(_that.file);case _RemoveImage() when removeImage != null:
return removeImage();case _Refresh() when refresh != null:
return refresh();case _ShareApp() when shareApp != null:
return shareApp();case _ToResume() when toResume != null:
return toResume();case _ShowPickerMenu() when showPickerMenu != null:
return showPickerMenu();case _:
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


class _ImagePicked extends AboutMeIntent {
  const _ImagePicked(this.file): super._();
  

 final  File? file;

/// Create a copy of AboutMeIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImagePickedCopyWith<_ImagePicked> get copyWith => __$ImagePickedCopyWithImpl<_ImagePicked>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImagePicked&&(identical(other.file, file) || other.file == file));
}


@override
int get hashCode => Object.hash(runtimeType,file);

@override
String toString() {
  return 'AboutMeIntent.imagePicked(file: $file)';
}


}

/// @nodoc
abstract mixin class _$ImagePickedCopyWith<$Res> implements $AboutMeIntentCopyWith<$Res> {
  factory _$ImagePickedCopyWith(_ImagePicked value, $Res Function(_ImagePicked) _then) = __$ImagePickedCopyWithImpl;
@useResult
$Res call({
 File? file
});




}
/// @nodoc
class __$ImagePickedCopyWithImpl<$Res>
    implements _$ImagePickedCopyWith<$Res> {
  __$ImagePickedCopyWithImpl(this._self, this._then);

  final _ImagePicked _self;
  final $Res Function(_ImagePicked) _then;

/// Create a copy of AboutMeIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? file = freezed,}) {
  return _then(_ImagePicked(
freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as File?,
  ));
}


}

/// @nodoc


class _ImageCropped extends AboutMeIntent {
  const _ImageCropped(this.file): super._();
  

 final  File file;

/// Create a copy of AboutMeIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageCroppedCopyWith<_ImageCropped> get copyWith => __$ImageCroppedCopyWithImpl<_ImageCropped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageCropped&&(identical(other.file, file) || other.file == file));
}


@override
int get hashCode => Object.hash(runtimeType,file);

@override
String toString() {
  return 'AboutMeIntent.imageCropped(file: $file)';
}


}

/// @nodoc
abstract mixin class _$ImageCroppedCopyWith<$Res> implements $AboutMeIntentCopyWith<$Res> {
  factory _$ImageCroppedCopyWith(_ImageCropped value, $Res Function(_ImageCropped) _then) = __$ImageCroppedCopyWithImpl;
@useResult
$Res call({
 File file
});




}
/// @nodoc
class __$ImageCroppedCopyWithImpl<$Res>
    implements _$ImageCroppedCopyWith<$Res> {
  __$ImageCroppedCopyWithImpl(this._self, this._then);

  final _ImageCropped _self;
  final $Res Function(_ImageCropped) _then;

/// Create a copy of AboutMeIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? file = null,}) {
  return _then(_ImageCropped(
null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as File,
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




/// @nodoc


class _ToResume extends AboutMeIntent {
  const _ToResume(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToResume);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AboutMeIntent.toResume()';
}


}




/// @nodoc


class _ShowPickerMenu extends AboutMeIntent {
  const _ShowPickerMenu(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShowPickerMenu);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AboutMeIntent.showPickerMenu()';
}


}




// dart format on
