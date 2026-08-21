// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_chat_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiChatIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiChatIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AiChatIntent()';
}


}

/// @nodoc
class $AiChatIntentCopyWith<$Res>  {
$AiChatIntentCopyWith(AiChatIntent _, $Res Function(AiChatIntent) __);
}


/// Adds pattern-matching-related methods to [AiChatIntent].
extension AiChatIntentPatterns on AiChatIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Init value)?  init,TResult Function( _SendMessage value)?  sendMessage,TResult Function( _ClearHistory value)?  clearHistory,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that);case _SendMessage() when sendMessage != null:
return sendMessage(_that);case _ClearHistory() when clearHistory != null:
return clearHistory(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Init value)  init,required TResult Function( _SendMessage value)  sendMessage,required TResult Function( _ClearHistory value)  clearHistory,}){
final _that = this;
switch (_that) {
case _Init():
return init(_that);case _SendMessage():
return sendMessage(_that);case _ClearHistory():
return clearHistory(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Init value)?  init,TResult? Function( _SendMessage value)?  sendMessage,TResult? Function( _ClearHistory value)?  clearHistory,}){
final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that);case _SendMessage() when sendMessage != null:
return sendMessage(_that);case _ClearHistory() when clearHistory != null:
return clearHistory(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  init,TResult Function( String text)?  sendMessage,TResult Function()?  clearHistory,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Init() when init != null:
return init();case _SendMessage() when sendMessage != null:
return sendMessage(_that.text);case _ClearHistory() when clearHistory != null:
return clearHistory();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  init,required TResult Function( String text)  sendMessage,required TResult Function()  clearHistory,}) {final _that = this;
switch (_that) {
case _Init():
return init();case _SendMessage():
return sendMessage(_that.text);case _ClearHistory():
return clearHistory();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  init,TResult? Function( String text)?  sendMessage,TResult? Function()?  clearHistory,}) {final _that = this;
switch (_that) {
case _Init() when init != null:
return init();case _SendMessage() when sendMessage != null:
return sendMessage(_that.text);case _ClearHistory() when clearHistory != null:
return clearHistory();case _:
  return null;

}
}

}

/// @nodoc


class _Init extends AiChatIntent {
  const _Init(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Init);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AiChatIntent.init()';
}


}




/// @nodoc


class _SendMessage extends AiChatIntent {
  const _SendMessage(this.text): super._();
  

 final  String text;

/// Create a copy of AiChatIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendMessageCopyWith<_SendMessage> get copyWith => __$SendMessageCopyWithImpl<_SendMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendMessage&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'AiChatIntent.sendMessage(text: $text)';
}


}

/// @nodoc
abstract mixin class _$SendMessageCopyWith<$Res> implements $AiChatIntentCopyWith<$Res> {
  factory _$SendMessageCopyWith(_SendMessage value, $Res Function(_SendMessage) _then) = __$SendMessageCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class __$SendMessageCopyWithImpl<$Res>
    implements _$SendMessageCopyWith<$Res> {
  __$SendMessageCopyWithImpl(this._self, this._then);

  final _SendMessage _self;
  final $Res Function(_SendMessage) _then;

/// Create a copy of AiChatIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(_SendMessage(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ClearHistory extends AiChatIntent {
  const _ClearHistory(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClearHistory);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AiChatIntent.clearHistory()';
}


}




// dart format on
