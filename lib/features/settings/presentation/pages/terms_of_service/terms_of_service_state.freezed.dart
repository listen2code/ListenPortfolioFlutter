// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terms_of_service_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TermsOfServiceState {

 String get lastUpdated; List<TermsSection> get sections;
/// Create a copy of TermsOfServiceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TermsOfServiceStateCopyWith<TermsOfServiceState> get copyWith => _$TermsOfServiceStateCopyWithImpl<TermsOfServiceState>(this as TermsOfServiceState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TermsOfServiceState&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&const DeepCollectionEquality().equals(other.sections, sections));
}


@override
int get hashCode => Object.hash(runtimeType,lastUpdated,const DeepCollectionEquality().hash(sections));

@override
String toString() {
  return 'TermsOfServiceState(lastUpdated: $lastUpdated, sections: $sections)';
}


}

/// @nodoc
abstract mixin class $TermsOfServiceStateCopyWith<$Res>  {
  factory $TermsOfServiceStateCopyWith(TermsOfServiceState value, $Res Function(TermsOfServiceState) _then) = _$TermsOfServiceStateCopyWithImpl;
@useResult
$Res call({
 String lastUpdated, List<TermsSection> sections
});




}
/// @nodoc
class _$TermsOfServiceStateCopyWithImpl<$Res>
    implements $TermsOfServiceStateCopyWith<$Res> {
  _$TermsOfServiceStateCopyWithImpl(this._self, this._then);

  final TermsOfServiceState _self;
  final $Res Function(TermsOfServiceState) _then;

/// Create a copy of TermsOfServiceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastUpdated = null,Object? sections = null,}) {
  return _then(_self.copyWith(
lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<TermsSection>,
  ));
}

}


/// Adds pattern-matching-related methods to [TermsOfServiceState].
extension TermsOfServiceStatePatterns on TermsOfServiceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TermsOfServiceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TermsOfServiceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TermsOfServiceState value)  $default,){
final _that = this;
switch (_that) {
case _TermsOfServiceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TermsOfServiceState value)?  $default,){
final _that = this;
switch (_that) {
case _TermsOfServiceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String lastUpdated,  List<TermsSection> sections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TermsOfServiceState() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String lastUpdated,  List<TermsSection> sections)  $default,) {final _that = this;
switch (_that) {
case _TermsOfServiceState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String lastUpdated,  List<TermsSection> sections)?  $default,) {final _that = this;
switch (_that) {
case _TermsOfServiceState() when $default != null:
return $default(_that.lastUpdated,_that.sections);case _:
  return null;

}
}

}

/// @nodoc


class _TermsOfServiceState extends TermsOfServiceState {
  const _TermsOfServiceState({this.lastUpdated = '', final  List<TermsSection> sections = const []}): _sections = sections,super._();
  

@override@JsonKey() final  String lastUpdated;
 final  List<TermsSection> _sections;
@override@JsonKey() List<TermsSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}


/// Create a copy of TermsOfServiceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TermsOfServiceStateCopyWith<_TermsOfServiceState> get copyWith => __$TermsOfServiceStateCopyWithImpl<_TermsOfServiceState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TermsOfServiceState&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&const DeepCollectionEquality().equals(other._sections, _sections));
}


@override
int get hashCode => Object.hash(runtimeType,lastUpdated,const DeepCollectionEquality().hash(_sections));

@override
String toString() {
  return 'TermsOfServiceState(lastUpdated: $lastUpdated, sections: $sections)';
}


}

/// @nodoc
abstract mixin class _$TermsOfServiceStateCopyWith<$Res> implements $TermsOfServiceStateCopyWith<$Res> {
  factory _$TermsOfServiceStateCopyWith(_TermsOfServiceState value, $Res Function(_TermsOfServiceState) _then) = __$TermsOfServiceStateCopyWithImpl;
@override @useResult
$Res call({
 String lastUpdated, List<TermsSection> sections
});




}
/// @nodoc
class __$TermsOfServiceStateCopyWithImpl<$Res>
    implements _$TermsOfServiceStateCopyWith<$Res> {
  __$TermsOfServiceStateCopyWithImpl(this._self, this._then);

  final _TermsOfServiceState _self;
  final $Res Function(_TermsOfServiceState) _then;

/// Create a copy of TermsOfServiceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastUpdated = null,Object? sections = null,}) {
  return _then(_TermsOfServiceState(
lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<TermsSection>,
  ));
}


}

/// @nodoc
mixin _$TermsSection {

 String get title; String get content;
/// Create a copy of TermsSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TermsSectionCopyWith<TermsSection> get copyWith => _$TermsSectionCopyWithImpl<TermsSection>(this as TermsSection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TermsSection&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,title,content);

@override
String toString() {
  return 'TermsSection(title: $title, content: $content)';
}


}

/// @nodoc
abstract mixin class $TermsSectionCopyWith<$Res>  {
  factory $TermsSectionCopyWith(TermsSection value, $Res Function(TermsSection) _then) = _$TermsSectionCopyWithImpl;
@useResult
$Res call({
 String title, String content
});




}
/// @nodoc
class _$TermsSectionCopyWithImpl<$Res>
    implements $TermsSectionCopyWith<$Res> {
  _$TermsSectionCopyWithImpl(this._self, this._then);

  final TermsSection _self;
  final $Res Function(TermsSection) _then;

/// Create a copy of TermsSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? content = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TermsSection].
extension TermsSectionPatterns on TermsSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TermsSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TermsSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TermsSection value)  $default,){
final _that = this;
switch (_that) {
case _TermsSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TermsSection value)?  $default,){
final _that = this;
switch (_that) {
case _TermsSection() when $default != null:
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
case _TermsSection() when $default != null:
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
case _TermsSection():
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
case _TermsSection() when $default != null:
return $default(_that.title,_that.content);case _:
  return null;

}
}

}

/// @nodoc


class _TermsSection implements TermsSection {
  const _TermsSection({required this.title, required this.content});
  

@override final  String title;
@override final  String content;

/// Create a copy of TermsSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TermsSectionCopyWith<_TermsSection> get copyWith => __$TermsSectionCopyWithImpl<_TermsSection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TermsSection&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,title,content);

@override
String toString() {
  return 'TermsSection(title: $title, content: $content)';
}


}

/// @nodoc
abstract mixin class _$TermsSectionCopyWith<$Res> implements $TermsSectionCopyWith<$Res> {
  factory _$TermsSectionCopyWith(_TermsSection value, $Res Function(_TermsSection) _then) = __$TermsSectionCopyWithImpl;
@override @useResult
$Res call({
 String title, String content
});




}
/// @nodoc
class __$TermsSectionCopyWithImpl<$Res>
    implements _$TermsSectionCopyWith<$Res> {
  __$TermsSectionCopyWithImpl(this._self, this._then);

  final _TermsSection _self;
  final $Res Function(_TermsSection) _then;

/// Create a copy of TermsSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? content = null,}) {
  return _then(_TermsSection(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
