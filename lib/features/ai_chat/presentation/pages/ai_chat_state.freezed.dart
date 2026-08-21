// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiChatState {

 List<ChatMessage> get messages; bool get isLoading; String get resumeContent; String? get errorMessage; List<String> get presetQuestions; Map<String, List<PresetQaItem>> get allPresetQAs;
/// Create a copy of AiChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiChatStateCopyWith<AiChatState> get copyWith => _$AiChatStateCopyWithImpl<AiChatState>(this as AiChatState, _$identity);

  /// Serializes this AiChatState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiChatState&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.resumeContent, resumeContent) || other.resumeContent == resumeContent)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.presetQuestions, presetQuestions)&&const DeepCollectionEquality().equals(other.allPresetQAs, allPresetQAs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(messages),isLoading,resumeContent,errorMessage,const DeepCollectionEquality().hash(presetQuestions),const DeepCollectionEquality().hash(allPresetQAs));

@override
String toString() {
  return 'AiChatState(messages: $messages, isLoading: $isLoading, resumeContent: $resumeContent, errorMessage: $errorMessage, presetQuestions: $presetQuestions, allPresetQAs: $allPresetQAs)';
}


}

/// @nodoc
abstract mixin class $AiChatStateCopyWith<$Res>  {
  factory $AiChatStateCopyWith(AiChatState value, $Res Function(AiChatState) _then) = _$AiChatStateCopyWithImpl;
@useResult
$Res call({
 List<ChatMessage> messages, bool isLoading, String resumeContent, String? errorMessage, List<String> presetQuestions, Map<String, List<PresetQaItem>> allPresetQAs
});




}
/// @nodoc
class _$AiChatStateCopyWithImpl<$Res>
    implements $AiChatStateCopyWith<$Res> {
  _$AiChatStateCopyWithImpl(this._self, this._then);

  final AiChatState _self;
  final $Res Function(AiChatState) _then;

/// Create a copy of AiChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,Object? isLoading = null,Object? resumeContent = null,Object? errorMessage = freezed,Object? presetQuestions = null,Object? allPresetQAs = null,}) {
  return _then(_self.copyWith(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,resumeContent: null == resumeContent ? _self.resumeContent : resumeContent // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,presetQuestions: null == presetQuestions ? _self.presetQuestions : presetQuestions // ignore: cast_nullable_to_non_nullable
as List<String>,allPresetQAs: null == allPresetQAs ? _self.allPresetQAs : allPresetQAs // ignore: cast_nullable_to_non_nullable
as Map<String, List<PresetQaItem>>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiChatState].
extension AiChatStatePatterns on AiChatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiChatState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiChatState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiChatState value)  $default,){
final _that = this;
switch (_that) {
case _AiChatState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiChatState value)?  $default,){
final _that = this;
switch (_that) {
case _AiChatState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChatMessage> messages,  bool isLoading,  String resumeContent,  String? errorMessage,  List<String> presetQuestions,  Map<String, List<PresetQaItem>> allPresetQAs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiChatState() when $default != null:
return $default(_that.messages,_that.isLoading,_that.resumeContent,_that.errorMessage,_that.presetQuestions,_that.allPresetQAs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChatMessage> messages,  bool isLoading,  String resumeContent,  String? errorMessage,  List<String> presetQuestions,  Map<String, List<PresetQaItem>> allPresetQAs)  $default,) {final _that = this;
switch (_that) {
case _AiChatState():
return $default(_that.messages,_that.isLoading,_that.resumeContent,_that.errorMessage,_that.presetQuestions,_that.allPresetQAs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChatMessage> messages,  bool isLoading,  String resumeContent,  String? errorMessage,  List<String> presetQuestions,  Map<String, List<PresetQaItem>> allPresetQAs)?  $default,) {final _that = this;
switch (_that) {
case _AiChatState() when $default != null:
return $default(_that.messages,_that.isLoading,_that.resumeContent,_that.errorMessage,_that.presetQuestions,_that.allPresetQAs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiChatState extends AiChatState {
  const _AiChatState({final  List<ChatMessage> messages = const [], this.isLoading = false, this.resumeContent = '', this.errorMessage, final  List<String> presetQuestions = const [], final  Map<String, List<PresetQaItem>> allPresetQAs = const {}}): _messages = messages,_presetQuestions = presetQuestions,_allPresetQAs = allPresetQAs,super._();
  factory _AiChatState.fromJson(Map<String, dynamic> json) => _$AiChatStateFromJson(json);

 final  List<ChatMessage> _messages;
@override@JsonKey() List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String resumeContent;
@override final  String? errorMessage;
 final  List<String> _presetQuestions;
@override@JsonKey() List<String> get presetQuestions {
  if (_presetQuestions is EqualUnmodifiableListView) return _presetQuestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_presetQuestions);
}

 final  Map<String, List<PresetQaItem>> _allPresetQAs;
@override@JsonKey() Map<String, List<PresetQaItem>> get allPresetQAs {
  if (_allPresetQAs is EqualUnmodifiableMapView) return _allPresetQAs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_allPresetQAs);
}


/// Create a copy of AiChatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiChatStateCopyWith<_AiChatState> get copyWith => __$AiChatStateCopyWithImpl<_AiChatState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiChatStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiChatState&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.resumeContent, resumeContent) || other.resumeContent == resumeContent)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._presetQuestions, _presetQuestions)&&const DeepCollectionEquality().equals(other._allPresetQAs, _allPresetQAs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),isLoading,resumeContent,errorMessage,const DeepCollectionEquality().hash(_presetQuestions),const DeepCollectionEquality().hash(_allPresetQAs));

@override
String toString() {
  return 'AiChatState(messages: $messages, isLoading: $isLoading, resumeContent: $resumeContent, errorMessage: $errorMessage, presetQuestions: $presetQuestions, allPresetQAs: $allPresetQAs)';
}


}

/// @nodoc
abstract mixin class _$AiChatStateCopyWith<$Res> implements $AiChatStateCopyWith<$Res> {
  factory _$AiChatStateCopyWith(_AiChatState value, $Res Function(_AiChatState) _then) = __$AiChatStateCopyWithImpl;
@override @useResult
$Res call({
 List<ChatMessage> messages, bool isLoading, String resumeContent, String? errorMessage, List<String> presetQuestions, Map<String, List<PresetQaItem>> allPresetQAs
});




}
/// @nodoc
class __$AiChatStateCopyWithImpl<$Res>
    implements _$AiChatStateCopyWith<$Res> {
  __$AiChatStateCopyWithImpl(this._self, this._then);

  final _AiChatState _self;
  final $Res Function(_AiChatState) _then;

/// Create a copy of AiChatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? isLoading = null,Object? resumeContent = null,Object? errorMessage = freezed,Object? presetQuestions = null,Object? allPresetQAs = null,}) {
  return _then(_AiChatState(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,resumeContent: null == resumeContent ? _self.resumeContent : resumeContent // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,presetQuestions: null == presetQuestions ? _self._presetQuestions : presetQuestions // ignore: cast_nullable_to_non_nullable
as List<String>,allPresetQAs: null == allPresetQAs ? _self._allPresetQAs : allPresetQAs // ignore: cast_nullable_to_non_nullable
as Map<String, List<PresetQaItem>>,
  ));
}


}

// dart format on
