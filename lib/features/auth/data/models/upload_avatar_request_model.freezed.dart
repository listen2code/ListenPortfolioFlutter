// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_avatar_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UploadAvatarRequestModel {

 String get avatar;
/// Create a copy of UploadAvatarRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadAvatarRequestModelCopyWith<UploadAvatarRequestModel> get copyWith => _$UploadAvatarRequestModelCopyWithImpl<UploadAvatarRequestModel>(this as UploadAvatarRequestModel, _$identity);

  /// Serializes this UploadAvatarRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadAvatarRequestModel&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,avatar);

@override
String toString() {
  return 'UploadAvatarRequestModel(avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class $UploadAvatarRequestModelCopyWith<$Res>  {
  factory $UploadAvatarRequestModelCopyWith(UploadAvatarRequestModel value, $Res Function(UploadAvatarRequestModel) _then) = _$UploadAvatarRequestModelCopyWithImpl;
@useResult
$Res call({
 String avatar
});




}
/// @nodoc
class _$UploadAvatarRequestModelCopyWithImpl<$Res>
    implements $UploadAvatarRequestModelCopyWith<$Res> {
  _$UploadAvatarRequestModelCopyWithImpl(this._self, this._then);

  final UploadAvatarRequestModel _self;
  final $Res Function(UploadAvatarRequestModel) _then;

/// Create a copy of UploadAvatarRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? avatar = null,}) {
  return _then(_self.copyWith(
avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadAvatarRequestModel].
extension UploadAvatarRequestModelPatterns on UploadAvatarRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadAvatarRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadAvatarRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadAvatarRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _UploadAvatarRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadAvatarRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _UploadAvatarRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String avatar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UploadAvatarRequestModel() when $default != null:
return $default(_that.avatar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String avatar)  $default,) {final _that = this;
switch (_that) {
case _UploadAvatarRequestModel():
return $default(_that.avatar);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String avatar)?  $default,) {final _that = this;
switch (_that) {
case _UploadAvatarRequestModel() when $default != null:
return $default(_that.avatar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UploadAvatarRequestModel implements UploadAvatarRequestModel {
  const _UploadAvatarRequestModel({required this.avatar});
  factory _UploadAvatarRequestModel.fromJson(Map<String, dynamic> json) => _$UploadAvatarRequestModelFromJson(json);

@override final  String avatar;

/// Create a copy of UploadAvatarRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadAvatarRequestModelCopyWith<_UploadAvatarRequestModel> get copyWith => __$UploadAvatarRequestModelCopyWithImpl<_UploadAvatarRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadAvatarRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadAvatarRequestModel&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,avatar);

@override
String toString() {
  return 'UploadAvatarRequestModel(avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class _$UploadAvatarRequestModelCopyWith<$Res> implements $UploadAvatarRequestModelCopyWith<$Res> {
  factory _$UploadAvatarRequestModelCopyWith(_UploadAvatarRequestModel value, $Res Function(_UploadAvatarRequestModel) _then) = __$UploadAvatarRequestModelCopyWithImpl;
@override @useResult
$Res call({
 String avatar
});




}
/// @nodoc
class __$UploadAvatarRequestModelCopyWithImpl<$Res>
    implements _$UploadAvatarRequestModelCopyWith<$Res> {
  __$UploadAvatarRequestModelCopyWithImpl(this._self, this._then);

  final _UploadAvatarRequestModel _self;
  final $Res Function(_UploadAvatarRequestModel) _then;

/// Create a copy of UploadAvatarRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? avatar = null,}) {
  return _then(_UploadAvatarRequestModel(
avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
