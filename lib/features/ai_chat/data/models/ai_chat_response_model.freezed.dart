// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_chat_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiChatResponseModel {

 String get reply;
/// Create a copy of AiChatResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiChatResponseModelCopyWith<AiChatResponseModel> get copyWith => _$AiChatResponseModelCopyWithImpl<AiChatResponseModel>(this as AiChatResponseModel, _$identity);

  /// Serializes this AiChatResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiChatResponseModel&&(identical(other.reply, reply) || other.reply == reply));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reply);

@override
String toString() {
  return 'AiChatResponseModel(reply: $reply)';
}


}

/// @nodoc
abstract mixin class $AiChatResponseModelCopyWith<$Res>  {
  factory $AiChatResponseModelCopyWith(AiChatResponseModel value, $Res Function(AiChatResponseModel) _then) = _$AiChatResponseModelCopyWithImpl;
@useResult
$Res call({
 String reply
});




}
/// @nodoc
class _$AiChatResponseModelCopyWithImpl<$Res>
    implements $AiChatResponseModelCopyWith<$Res> {
  _$AiChatResponseModelCopyWithImpl(this._self, this._then);

  final AiChatResponseModel _self;
  final $Res Function(AiChatResponseModel) _then;

/// Create a copy of AiChatResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reply = null,}) {
  return _then(_self.copyWith(
reply: null == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AiChatResponseModel].
extension AiChatResponseModelPatterns on AiChatResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiChatResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiChatResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiChatResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _AiChatResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiChatResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _AiChatResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reply)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiChatResponseModel() when $default != null:
return $default(_that.reply);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reply)  $default,) {final _that = this;
switch (_that) {
case _AiChatResponseModel():
return $default(_that.reply);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reply)?  $default,) {final _that = this;
switch (_that) {
case _AiChatResponseModel() when $default != null:
return $default(_that.reply);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiChatResponseModel implements AiChatResponseModel {
  const _AiChatResponseModel({required this.reply});
  factory _AiChatResponseModel.fromJson(Map<String, dynamic> json) => _$AiChatResponseModelFromJson(json);

@override final  String reply;

/// Create a copy of AiChatResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiChatResponseModelCopyWith<_AiChatResponseModel> get copyWith => __$AiChatResponseModelCopyWithImpl<_AiChatResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiChatResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiChatResponseModel&&(identical(other.reply, reply) || other.reply == reply));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reply);

@override
String toString() {
  return 'AiChatResponseModel(reply: $reply)';
}


}

/// @nodoc
abstract mixin class _$AiChatResponseModelCopyWith<$Res> implements $AiChatResponseModelCopyWith<$Res> {
  factory _$AiChatResponseModelCopyWith(_AiChatResponseModel value, $Res Function(_AiChatResponseModel) _then) = __$AiChatResponseModelCopyWithImpl;
@override @useResult
$Res call({
 String reply
});




}
/// @nodoc
class __$AiChatResponseModelCopyWithImpl<$Res>
    implements _$AiChatResponseModelCopyWith<$Res> {
  __$AiChatResponseModelCopyWithImpl(this._self, this._then);

  final _AiChatResponseModel _self;
  final $Res Function(_AiChatResponseModel) _then;

/// Create a copy of AiChatResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reply = null,}) {
  return _then(_AiChatResponseModel(
reply: null == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
