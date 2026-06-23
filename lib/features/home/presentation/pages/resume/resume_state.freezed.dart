// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resume_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResumeState {

 bool get isLoading; String get markdownContent; bool get isExporting; String? get errorMessage;
/// Create a copy of ResumeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResumeStateCopyWith<ResumeState> get copyWith => _$ResumeStateCopyWithImpl<ResumeState>(this as ResumeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResumeState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.markdownContent, markdownContent) || other.markdownContent == markdownContent)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,markdownContent,isExporting,errorMessage);

@override
String toString() {
  return 'ResumeState(isLoading: $isLoading, markdownContent: $markdownContent, isExporting: $isExporting, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ResumeStateCopyWith<$Res>  {
  factory $ResumeStateCopyWith(ResumeState value, $Res Function(ResumeState) _then) = _$ResumeStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String markdownContent, bool isExporting, String? errorMessage
});




}
/// @nodoc
class _$ResumeStateCopyWithImpl<$Res>
    implements $ResumeStateCopyWith<$Res> {
  _$ResumeStateCopyWithImpl(this._self, this._then);

  final ResumeState _self;
  final $Res Function(ResumeState) _then;

/// Create a copy of ResumeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? markdownContent = null,Object? isExporting = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,markdownContent: null == markdownContent ? _self.markdownContent : markdownContent // ignore: cast_nullable_to_non_nullable
as String,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResumeState].
extension ResumeStatePatterns on ResumeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResumeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResumeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResumeState value)  $default,){
final _that = this;
switch (_that) {
case _ResumeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResumeState value)?  $default,){
final _that = this;
switch (_that) {
case _ResumeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String markdownContent,  bool isExporting,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResumeState() when $default != null:
return $default(_that.isLoading,_that.markdownContent,_that.isExporting,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String markdownContent,  bool isExporting,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ResumeState():
return $default(_that.isLoading,_that.markdownContent,_that.isExporting,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String markdownContent,  bool isExporting,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ResumeState() when $default != null:
return $default(_that.isLoading,_that.markdownContent,_that.isExporting,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ResumeState extends ResumeState {
  const _ResumeState({this.isLoading = false, this.markdownContent = '', this.isExporting = false, this.errorMessage}): super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String markdownContent;
@override@JsonKey() final  bool isExporting;
@override final  String? errorMessage;

/// Create a copy of ResumeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResumeStateCopyWith<_ResumeState> get copyWith => __$ResumeStateCopyWithImpl<_ResumeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResumeState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.markdownContent, markdownContent) || other.markdownContent == markdownContent)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,markdownContent,isExporting,errorMessage);

@override
String toString() {
  return 'ResumeState(isLoading: $isLoading, markdownContent: $markdownContent, isExporting: $isExporting, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ResumeStateCopyWith<$Res> implements $ResumeStateCopyWith<$Res> {
  factory _$ResumeStateCopyWith(_ResumeState value, $Res Function(_ResumeState) _then) = __$ResumeStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String markdownContent, bool isExporting, String? errorMessage
});




}
/// @nodoc
class __$ResumeStateCopyWithImpl<$Res>
    implements _$ResumeStateCopyWith<$Res> {
  __$ResumeStateCopyWithImpl(this._self, this._then);

  final _ResumeState _self;
  final $Res Function(_ResumeState) _then;

/// Create a copy of ResumeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? markdownContent = null,Object? isExporting = null,Object? errorMessage = freezed,}) {
  return _then(_ResumeState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,markdownContent: null == markdownContent ? _self.markdownContent : markdownContent // ignore: cast_nullable_to_non_nullable
as String,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
