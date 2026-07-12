// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_chat_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiChatRequestModel {

 String get message; List<ChatMessage> get history; String get resumeContext; String get mode;
/// Create a copy of AiChatRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiChatRequestModelCopyWith<AiChatRequestModel> get copyWith => _$AiChatRequestModelCopyWithImpl<AiChatRequestModel>(this as AiChatRequestModel, _$identity);

  /// Serializes this AiChatRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiChatRequestModel&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.history, history)&&(identical(other.resumeContext, resumeContext) || other.resumeContext == resumeContext)&&(identical(other.mode, mode) || other.mode == mode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(history),resumeContext,mode);

@override
String toString() {
  return 'AiChatRequestModel(message: $message, history: $history, resumeContext: $resumeContext, mode: $mode)';
}


}

/// @nodoc
abstract mixin class $AiChatRequestModelCopyWith<$Res>  {
  factory $AiChatRequestModelCopyWith(AiChatRequestModel value, $Res Function(AiChatRequestModel) _then) = _$AiChatRequestModelCopyWithImpl;
@useResult
$Res call({
 String message, List<ChatMessage> history, String resumeContext, String mode
});




}
/// @nodoc
class _$AiChatRequestModelCopyWithImpl<$Res>
    implements $AiChatRequestModelCopyWith<$Res> {
  _$AiChatRequestModelCopyWithImpl(this._self, this._then);

  final AiChatRequestModel _self;
  final $Res Function(AiChatRequestModel) _then;

/// Create a copy of AiChatRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? history = null,Object? resumeContext = null,Object? mode = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,resumeContext: null == resumeContext ? _self.resumeContext : resumeContext // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AiChatRequestModel].
extension AiChatRequestModelPatterns on AiChatRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiChatRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiChatRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiChatRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _AiChatRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiChatRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _AiChatRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  List<ChatMessage> history,  String resumeContext,  String mode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiChatRequestModel() when $default != null:
return $default(_that.message,_that.history,_that.resumeContext,_that.mode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  List<ChatMessage> history,  String resumeContext,  String mode)  $default,) {final _that = this;
switch (_that) {
case _AiChatRequestModel():
return $default(_that.message,_that.history,_that.resumeContext,_that.mode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  List<ChatMessage> history,  String resumeContext,  String mode)?  $default,) {final _that = this;
switch (_that) {
case _AiChatRequestModel() when $default != null:
return $default(_that.message,_that.history,_that.resumeContext,_that.mode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiChatRequestModel implements AiChatRequestModel {
  const _AiChatRequestModel({required this.message, required final  List<ChatMessage> history, required this.resumeContext, required this.mode}): _history = history;
  factory _AiChatRequestModel.fromJson(Map<String, dynamic> json) => _$AiChatRequestModelFromJson(json);

@override final  String message;
 final  List<ChatMessage> _history;
@override List<ChatMessage> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

@override final  String resumeContext;
@override final  String mode;

/// Create a copy of AiChatRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiChatRequestModelCopyWith<_AiChatRequestModel> get copyWith => __$AiChatRequestModelCopyWithImpl<_AiChatRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiChatRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiChatRequestModel&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._history, _history)&&(identical(other.resumeContext, resumeContext) || other.resumeContext == resumeContext)&&(identical(other.mode, mode) || other.mode == mode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_history),resumeContext,mode);

@override
String toString() {
  return 'AiChatRequestModel(message: $message, history: $history, resumeContext: $resumeContext, mode: $mode)';
}


}

/// @nodoc
abstract mixin class _$AiChatRequestModelCopyWith<$Res> implements $AiChatRequestModelCopyWith<$Res> {
  factory _$AiChatRequestModelCopyWith(_AiChatRequestModel value, $Res Function(_AiChatRequestModel) _then) = __$AiChatRequestModelCopyWithImpl;
@override @useResult
$Res call({
 String message, List<ChatMessage> history, String resumeContext, String mode
});




}
/// @nodoc
class __$AiChatRequestModelCopyWithImpl<$Res>
    implements _$AiChatRequestModelCopyWith<$Res> {
  __$AiChatRequestModelCopyWithImpl(this._self, this._then);

  final _AiChatRequestModel _self;
  final $Res Function(_AiChatRequestModel) _then;

/// Create a copy of AiChatRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? history = null,Object? resumeContext = null,Object? mode = null,}) {
  return _then(_AiChatRequestModel(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,resumeContext: null == resumeContext ? _self.resumeContext : resumeContext // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
