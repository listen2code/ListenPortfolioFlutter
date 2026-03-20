// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_policy_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrivacyPolicyState {

 String get lastUpdated; List<PrivacySection> get sections;
/// Create a copy of PrivacyPolicyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivacyPolicyStateCopyWith<PrivacyPolicyState> get copyWith => _$PrivacyPolicyStateCopyWithImpl<PrivacyPolicyState>(this as PrivacyPolicyState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivacyPolicyState&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&const DeepCollectionEquality().equals(other.sections, sections));
}


@override
int get hashCode => Object.hash(runtimeType,lastUpdated,const DeepCollectionEquality().hash(sections));

@override
String toString() {
  return 'PrivacyPolicyState(lastUpdated: $lastUpdated, sections: $sections)';
}


}

/// @nodoc
abstract mixin class $PrivacyPolicyStateCopyWith<$Res>  {
  factory $PrivacyPolicyStateCopyWith(PrivacyPolicyState value, $Res Function(PrivacyPolicyState) _then) = _$PrivacyPolicyStateCopyWithImpl;
@useResult
$Res call({
 String lastUpdated, List<PrivacySection> sections
});




}
/// @nodoc
class _$PrivacyPolicyStateCopyWithImpl<$Res>
    implements $PrivacyPolicyStateCopyWith<$Res> {
  _$PrivacyPolicyStateCopyWithImpl(this._self, this._then);

  final PrivacyPolicyState _self;
  final $Res Function(PrivacyPolicyState) _then;

/// Create a copy of PrivacyPolicyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastUpdated = null,Object? sections = null,}) {
  return _then(_self.copyWith(
lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<PrivacySection>,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivacyPolicyState].
extension PrivacyPolicyStatePatterns on PrivacyPolicyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivacyPolicyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivacyPolicyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivacyPolicyState value)  $default,){
final _that = this;
switch (_that) {
case _PrivacyPolicyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivacyPolicyState value)?  $default,){
final _that = this;
switch (_that) {
case _PrivacyPolicyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String lastUpdated,  List<PrivacySection> sections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivacyPolicyState() when $default != null:
return $default(_that.lastUpdated,_that.sections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String lastUpdated,  List<PrivacySection> sections)  $default,) {final _that = this;
switch (_that) {
case _PrivacyPolicyState():
return $default(_that.lastUpdated,_that.sections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String lastUpdated,  List<PrivacySection> sections)?  $default,) {final _that = this;
switch (_that) {
case _PrivacyPolicyState() when $default != null:
return $default(_that.lastUpdated,_that.sections);case _:
  return null;

}
}

}

/// @nodoc


class _PrivacyPolicyState extends PrivacyPolicyState {
  const _PrivacyPolicyState({this.lastUpdated = '', final  List<PrivacySection> sections = const []}): _sections = sections,super._();
  

@override@JsonKey() final  String lastUpdated;
 final  List<PrivacySection> _sections;
@override@JsonKey() List<PrivacySection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}


/// Create a copy of PrivacyPolicyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivacyPolicyStateCopyWith<_PrivacyPolicyState> get copyWith => __$PrivacyPolicyStateCopyWithImpl<_PrivacyPolicyState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivacyPolicyState&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&const DeepCollectionEquality().equals(other._sections, _sections));
}


@override
int get hashCode => Object.hash(runtimeType,lastUpdated,const DeepCollectionEquality().hash(_sections));

@override
String toString() {
  return 'PrivacyPolicyState(lastUpdated: $lastUpdated, sections: $sections)';
}


}

/// @nodoc
abstract mixin class _$PrivacyPolicyStateCopyWith<$Res> implements $PrivacyPolicyStateCopyWith<$Res> {
  factory _$PrivacyPolicyStateCopyWith(_PrivacyPolicyState value, $Res Function(_PrivacyPolicyState) _then) = __$PrivacyPolicyStateCopyWithImpl;
@override @useResult
$Res call({
 String lastUpdated, List<PrivacySection> sections
});




}
/// @nodoc
class __$PrivacyPolicyStateCopyWithImpl<$Res>
    implements _$PrivacyPolicyStateCopyWith<$Res> {
  __$PrivacyPolicyStateCopyWithImpl(this._self, this._then);

  final _PrivacyPolicyState _self;
  final $Res Function(_PrivacyPolicyState) _then;

/// Create a copy of PrivacyPolicyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastUpdated = null,Object? sections = null,}) {
  return _then(_PrivacyPolicyState(
lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<PrivacySection>,
  ));
}


}

/// @nodoc
mixin _$PrivacySection {

 String get title; String get content;
/// Create a copy of PrivacySection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivacySectionCopyWith<PrivacySection> get copyWith => _$PrivacySectionCopyWithImpl<PrivacySection>(this as PrivacySection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivacySection&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,title,content);

@override
String toString() {
  return 'PrivacySection(title: $title, content: $content)';
}


}

/// @nodoc
abstract mixin class $PrivacySectionCopyWith<$Res>  {
  factory $PrivacySectionCopyWith(PrivacySection value, $Res Function(PrivacySection) _then) = _$PrivacySectionCopyWithImpl;
@useResult
$Res call({
 String title, String content
});




}
/// @nodoc
class _$PrivacySectionCopyWithImpl<$Res>
    implements $PrivacySectionCopyWith<$Res> {
  _$PrivacySectionCopyWithImpl(this._self, this._then);

  final PrivacySection _self;
  final $Res Function(PrivacySection) _then;

/// Create a copy of PrivacySection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? content = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivacySection].
extension PrivacySectionPatterns on PrivacySection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivacySection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivacySection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivacySection value)  $default,){
final _that = this;
switch (_that) {
case _PrivacySection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivacySection value)?  $default,){
final _that = this;
switch (_that) {
case _PrivacySection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivacySection() when $default != null:
return $default(_that.title,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String content)  $default,) {final _that = this;
switch (_that) {
case _PrivacySection():
return $default(_that.title,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String content)?  $default,) {final _that = this;
switch (_that) {
case _PrivacySection() when $default != null:
return $default(_that.title,_that.content);case _:
  return null;

}
}

}

/// @nodoc


class _PrivacySection implements PrivacySection {
  const _PrivacySection({required this.title, required this.content});
  

@override final  String title;
@override final  String content;

/// Create a copy of PrivacySection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivacySectionCopyWith<_PrivacySection> get copyWith => __$PrivacySectionCopyWithImpl<_PrivacySection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivacySection&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,title,content);

@override
String toString() {
  return 'PrivacySection(title: $title, content: $content)';
}


}

/// @nodoc
abstract mixin class _$PrivacySectionCopyWith<$Res> implements $PrivacySectionCopyWith<$Res> {
  factory _$PrivacySectionCopyWith(_PrivacySection value, $Res Function(_PrivacySection) _then) = __$PrivacySectionCopyWithImpl;
@override @useResult
$Res call({
 String title, String content
});




}
/// @nodoc
class __$PrivacySectionCopyWithImpl<$Res>
    implements _$PrivacySectionCopyWith<$Res> {
  __$PrivacySectionCopyWithImpl(this._self, this._then);

  final _PrivacySection _self;
  final $Res Function(_PrivacySection) _then;

/// Create a copy of PrivacySection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? content = null,}) {
  return _then(_PrivacySection(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
