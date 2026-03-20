// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'architecture_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ArchitectureState {

 bool get isInitialLoaded; String? get header; List<ArchitectureSection> get sections;
/// Create a copy of ArchitectureState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchitectureStateCopyWith<ArchitectureState> get copyWith => _$ArchitectureStateCopyWithImpl<ArchitectureState>(this as ArchitectureState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchitectureState&&(identical(other.isInitialLoaded, isInitialLoaded) || other.isInitialLoaded == isInitialLoaded)&&(identical(other.header, header) || other.header == header)&&const DeepCollectionEquality().equals(other.sections, sections));
}


@override
int get hashCode => Object.hash(runtimeType,isInitialLoaded,header,const DeepCollectionEquality().hash(sections));

@override
String toString() {
  return 'ArchitectureState(isInitialLoaded: $isInitialLoaded, header: $header, sections: $sections)';
}


}

/// @nodoc
abstract mixin class $ArchitectureStateCopyWith<$Res>  {
  factory $ArchitectureStateCopyWith(ArchitectureState value, $Res Function(ArchitectureState) _then) = _$ArchitectureStateCopyWithImpl;
@useResult
$Res call({
 bool isInitialLoaded, String? header, List<ArchitectureSection> sections
});




}
/// @nodoc
class _$ArchitectureStateCopyWithImpl<$Res>
    implements $ArchitectureStateCopyWith<$Res> {
  _$ArchitectureStateCopyWithImpl(this._self, this._then);

  final ArchitectureState _self;
  final $Res Function(ArchitectureState) _then;

/// Create a copy of ArchitectureState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isInitialLoaded = null,Object? header = freezed,Object? sections = null,}) {
  return _then(_self.copyWith(
isInitialLoaded: null == isInitialLoaded ? _self.isInitialLoaded : isInitialLoaded // ignore: cast_nullable_to_non_nullable
as bool,header: freezed == header ? _self.header : header // ignore: cast_nullable_to_non_nullable
as String?,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<ArchitectureSection>,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchitectureState].
extension ArchitectureStatePatterns on ArchitectureState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchitectureState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchitectureState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchitectureState value)  $default,){
final _that = this;
switch (_that) {
case _ArchitectureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchitectureState value)?  $default,){
final _that = this;
switch (_that) {
case _ArchitectureState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isInitialLoaded,  String? header,  List<ArchitectureSection> sections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchitectureState() when $default != null:
return $default(_that.isInitialLoaded,_that.header,_that.sections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isInitialLoaded,  String? header,  List<ArchitectureSection> sections)  $default,) {final _that = this;
switch (_that) {
case _ArchitectureState():
return $default(_that.isInitialLoaded,_that.header,_that.sections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isInitialLoaded,  String? header,  List<ArchitectureSection> sections)?  $default,) {final _that = this;
switch (_that) {
case _ArchitectureState() when $default != null:
return $default(_that.isInitialLoaded,_that.header,_that.sections);case _:
  return null;

}
}

}

/// @nodoc


class _ArchitectureState extends ArchitectureState {
  const _ArchitectureState({this.isInitialLoaded = false, this.header, final  List<ArchitectureSection> sections = const []}): _sections = sections,super._();
  

@override@JsonKey() final  bool isInitialLoaded;
@override final  String? header;
 final  List<ArchitectureSection> _sections;
@override@JsonKey() List<ArchitectureSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}


/// Create a copy of ArchitectureState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchitectureStateCopyWith<_ArchitectureState> get copyWith => __$ArchitectureStateCopyWithImpl<_ArchitectureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchitectureState&&(identical(other.isInitialLoaded, isInitialLoaded) || other.isInitialLoaded == isInitialLoaded)&&(identical(other.header, header) || other.header == header)&&const DeepCollectionEquality().equals(other._sections, _sections));
}


@override
int get hashCode => Object.hash(runtimeType,isInitialLoaded,header,const DeepCollectionEquality().hash(_sections));

@override
String toString() {
  return 'ArchitectureState(isInitialLoaded: $isInitialLoaded, header: $header, sections: $sections)';
}


}

/// @nodoc
abstract mixin class _$ArchitectureStateCopyWith<$Res> implements $ArchitectureStateCopyWith<$Res> {
  factory _$ArchitectureStateCopyWith(_ArchitectureState value, $Res Function(_ArchitectureState) _then) = __$ArchitectureStateCopyWithImpl;
@override @useResult
$Res call({
 bool isInitialLoaded, String? header, List<ArchitectureSection> sections
});




}
/// @nodoc
class __$ArchitectureStateCopyWithImpl<$Res>
    implements _$ArchitectureStateCopyWith<$Res> {
  __$ArchitectureStateCopyWithImpl(this._self, this._then);

  final _ArchitectureState _self;
  final $Res Function(_ArchitectureState) _then;

/// Create a copy of ArchitectureState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isInitialLoaded = null,Object? header = freezed,Object? sections = null,}) {
  return _then(_ArchitectureState(
isInitialLoaded: null == isInitialLoaded ? _self.isInitialLoaded : isInitialLoaded // ignore: cast_nullable_to_non_nullable
as bool,header: freezed == header ? _self.header : header // ignore: cast_nullable_to_non_nullable
as String?,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<ArchitectureSection>,
  ));
}


}

/// @nodoc
mixin _$ArchitectureSection {

 String get title; String get content; dynamic get icon;// Can be IconData or String (asset path)
 List<ArchitectureLibItem>? get libs; String? get linkLabel; String? get linkUrl;
/// Create a copy of ArchitectureSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchitectureSectionCopyWith<ArchitectureSection> get copyWith => _$ArchitectureSectionCopyWithImpl<ArchitectureSection>(this as ArchitectureSection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchitectureSection&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.icon, icon)&&const DeepCollectionEquality().equals(other.libs, libs)&&(identical(other.linkLabel, linkLabel) || other.linkLabel == linkLabel)&&(identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl));
}


@override
int get hashCode => Object.hash(runtimeType,title,content,const DeepCollectionEquality().hash(icon),const DeepCollectionEquality().hash(libs),linkLabel,linkUrl);

@override
String toString() {
  return 'ArchitectureSection(title: $title, content: $content, icon: $icon, libs: $libs, linkLabel: $linkLabel, linkUrl: $linkUrl)';
}


}

/// @nodoc
abstract mixin class $ArchitectureSectionCopyWith<$Res>  {
  factory $ArchitectureSectionCopyWith(ArchitectureSection value, $Res Function(ArchitectureSection) _then) = _$ArchitectureSectionCopyWithImpl;
@useResult
$Res call({
 String title, String content, dynamic icon, List<ArchitectureLibItem>? libs, String? linkLabel, String? linkUrl
});




}
/// @nodoc
class _$ArchitectureSectionCopyWithImpl<$Res>
    implements $ArchitectureSectionCopyWith<$Res> {
  _$ArchitectureSectionCopyWithImpl(this._self, this._then);

  final ArchitectureSection _self;
  final $Res Function(ArchitectureSection) _then;

/// Create a copy of ArchitectureSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? content = null,Object? icon = freezed,Object? libs = freezed,Object? linkLabel = freezed,Object? linkUrl = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as dynamic,libs: freezed == libs ? _self.libs : libs // ignore: cast_nullable_to_non_nullable
as List<ArchitectureLibItem>?,linkLabel: freezed == linkLabel ? _self.linkLabel : linkLabel // ignore: cast_nullable_to_non_nullable
as String?,linkUrl: freezed == linkUrl ? _self.linkUrl : linkUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchitectureSection].
extension ArchitectureSectionPatterns on ArchitectureSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchitectureSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchitectureSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchitectureSection value)  $default,){
final _that = this;
switch (_that) {
case _ArchitectureSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchitectureSection value)?  $default,){
final _that = this;
switch (_that) {
case _ArchitectureSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String content,  dynamic icon,  List<ArchitectureLibItem>? libs,  String? linkLabel,  String? linkUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchitectureSection() when $default != null:
return $default(_that.title,_that.content,_that.icon,_that.libs,_that.linkLabel,_that.linkUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String content,  dynamic icon,  List<ArchitectureLibItem>? libs,  String? linkLabel,  String? linkUrl)  $default,) {final _that = this;
switch (_that) {
case _ArchitectureSection():
return $default(_that.title,_that.content,_that.icon,_that.libs,_that.linkLabel,_that.linkUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String content,  dynamic icon,  List<ArchitectureLibItem>? libs,  String? linkLabel,  String? linkUrl)?  $default,) {final _that = this;
switch (_that) {
case _ArchitectureSection() when $default != null:
return $default(_that.title,_that.content,_that.icon,_that.libs,_that.linkLabel,_that.linkUrl);case _:
  return null;

}
}

}

/// @nodoc


class _ArchitectureSection implements ArchitectureSection {
  const _ArchitectureSection({required this.title, required this.content, required this.icon, final  List<ArchitectureLibItem>? libs, this.linkLabel, this.linkUrl}): _libs = libs;
  

@override final  String title;
@override final  String content;
@override final  dynamic icon;
// Can be IconData or String (asset path)
 final  List<ArchitectureLibItem>? _libs;
// Can be IconData or String (asset path)
@override List<ArchitectureLibItem>? get libs {
  final value = _libs;
  if (value == null) return null;
  if (_libs is EqualUnmodifiableListView) return _libs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? linkLabel;
@override final  String? linkUrl;

/// Create a copy of ArchitectureSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchitectureSectionCopyWith<_ArchitectureSection> get copyWith => __$ArchitectureSectionCopyWithImpl<_ArchitectureSection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchitectureSection&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.icon, icon)&&const DeepCollectionEquality().equals(other._libs, _libs)&&(identical(other.linkLabel, linkLabel) || other.linkLabel == linkLabel)&&(identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl));
}


@override
int get hashCode => Object.hash(runtimeType,title,content,const DeepCollectionEquality().hash(icon),const DeepCollectionEquality().hash(_libs),linkLabel,linkUrl);

@override
String toString() {
  return 'ArchitectureSection(title: $title, content: $content, icon: $icon, libs: $libs, linkLabel: $linkLabel, linkUrl: $linkUrl)';
}


}

/// @nodoc
abstract mixin class _$ArchitectureSectionCopyWith<$Res> implements $ArchitectureSectionCopyWith<$Res> {
  factory _$ArchitectureSectionCopyWith(_ArchitectureSection value, $Res Function(_ArchitectureSection) _then) = __$ArchitectureSectionCopyWithImpl;
@override @useResult
$Res call({
 String title, String content, dynamic icon, List<ArchitectureLibItem>? libs, String? linkLabel, String? linkUrl
});




}
/// @nodoc
class __$ArchitectureSectionCopyWithImpl<$Res>
    implements _$ArchitectureSectionCopyWith<$Res> {
  __$ArchitectureSectionCopyWithImpl(this._self, this._then);

  final _ArchitectureSection _self;
  final $Res Function(_ArchitectureSection) _then;

/// Create a copy of ArchitectureSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? content = null,Object? icon = freezed,Object? libs = freezed,Object? linkLabel = freezed,Object? linkUrl = freezed,}) {
  return _then(_ArchitectureSection(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as dynamic,libs: freezed == libs ? _self._libs : libs // ignore: cast_nullable_to_non_nullable
as List<ArchitectureLibItem>?,linkLabel: freezed == linkLabel ? _self.linkLabel : linkLabel // ignore: cast_nullable_to_non_nullable
as String?,linkUrl: freezed == linkUrl ? _self.linkUrl : linkUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ArchitectureLibItem {

 String get name; String get desc;
/// Create a copy of ArchitectureLibItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchitectureLibItemCopyWith<ArchitectureLibItem> get copyWith => _$ArchitectureLibItemCopyWithImpl<ArchitectureLibItem>(this as ArchitectureLibItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchitectureLibItem&&(identical(other.name, name) || other.name == name)&&(identical(other.desc, desc) || other.desc == desc));
}


@override
int get hashCode => Object.hash(runtimeType,name,desc);

@override
String toString() {
  return 'ArchitectureLibItem(name: $name, desc: $desc)';
}


}

/// @nodoc
abstract mixin class $ArchitectureLibItemCopyWith<$Res>  {
  factory $ArchitectureLibItemCopyWith(ArchitectureLibItem value, $Res Function(ArchitectureLibItem) _then) = _$ArchitectureLibItemCopyWithImpl;
@useResult
$Res call({
 String name, String desc
});




}
/// @nodoc
class _$ArchitectureLibItemCopyWithImpl<$Res>
    implements $ArchitectureLibItemCopyWith<$Res> {
  _$ArchitectureLibItemCopyWithImpl(this._self, this._then);

  final ArchitectureLibItem _self;
  final $Res Function(ArchitectureLibItem) _then;

/// Create a copy of ArchitectureLibItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? desc = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,desc: null == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchitectureLibItem].
extension ArchitectureLibItemPatterns on ArchitectureLibItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchitectureLibItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchitectureLibItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchitectureLibItem value)  $default,){
final _that = this;
switch (_that) {
case _ArchitectureLibItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchitectureLibItem value)?  $default,){
final _that = this;
switch (_that) {
case _ArchitectureLibItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String desc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchitectureLibItem() when $default != null:
return $default(_that.name,_that.desc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String desc)  $default,) {final _that = this;
switch (_that) {
case _ArchitectureLibItem():
return $default(_that.name,_that.desc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String desc)?  $default,) {final _that = this;
switch (_that) {
case _ArchitectureLibItem() when $default != null:
return $default(_that.name,_that.desc);case _:
  return null;

}
}

}

/// @nodoc


class _ArchitectureLibItem implements ArchitectureLibItem {
  const _ArchitectureLibItem({required this.name, required this.desc});
  

@override final  String name;
@override final  String desc;

/// Create a copy of ArchitectureLibItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchitectureLibItemCopyWith<_ArchitectureLibItem> get copyWith => __$ArchitectureLibItemCopyWithImpl<_ArchitectureLibItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchitectureLibItem&&(identical(other.name, name) || other.name == name)&&(identical(other.desc, desc) || other.desc == desc));
}


@override
int get hashCode => Object.hash(runtimeType,name,desc);

@override
String toString() {
  return 'ArchitectureLibItem(name: $name, desc: $desc)';
}


}

/// @nodoc
abstract mixin class _$ArchitectureLibItemCopyWith<$Res> implements $ArchitectureLibItemCopyWith<$Res> {
  factory _$ArchitectureLibItemCopyWith(_ArchitectureLibItem value, $Res Function(_ArchitectureLibItem) _then) = __$ArchitectureLibItemCopyWithImpl;
@override @useResult
$Res call({
 String name, String desc
});




}
/// @nodoc
class __$ArchitectureLibItemCopyWithImpl<$Res>
    implements _$ArchitectureLibItemCopyWith<$Res> {
  __$ArchitectureLibItemCopyWithImpl(this._self, this._then);

  final _ArchitectureLibItem _self;
  final $Res Function(_ArchitectureLibItem) _then;

/// Create a copy of ArchitectureLibItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? desc = null,}) {
  return _then(_ArchitectureLibItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,desc: null == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
