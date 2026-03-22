// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectModel {

@ToStringConverter() String? get id; String? get title; String? get subtitle; String? get desc; String? get imageUrl; String? get githubUrl; List<String> get techStack;
/// Create a copy of ProjectModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectModelCopyWith<ProjectModel> get copyWith => _$ProjectModelCopyWithImpl<ProjectModel>(this as ProjectModel, _$identity);

  /// Serializes this ProjectModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.githubUrl, githubUrl) || other.githubUrl == githubUrl)&&const DeepCollectionEquality().equals(other.techStack, techStack));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,desc,imageUrl,githubUrl,const DeepCollectionEquality().hash(techStack));

@override
String toString() {
  return 'ProjectModel(id: $id, title: $title, subtitle: $subtitle, desc: $desc, imageUrl: $imageUrl, githubUrl: $githubUrl, techStack: $techStack)';
}


}

/// @nodoc
abstract mixin class $ProjectModelCopyWith<$Res>  {
  factory $ProjectModelCopyWith(ProjectModel value, $Res Function(ProjectModel) _then) = _$ProjectModelCopyWithImpl;
@useResult
$Res call({
@ToStringConverter() String? id, String? title, String? subtitle, String? desc, String? imageUrl, String? githubUrl, List<String> techStack
});




}
/// @nodoc
class _$ProjectModelCopyWithImpl<$Res>
    implements $ProjectModelCopyWith<$Res> {
  _$ProjectModelCopyWithImpl(this._self, this._then);

  final ProjectModel _self;
  final $Res Function(ProjectModel) _then;

/// Create a copy of ProjectModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = freezed,Object? subtitle = freezed,Object? desc = freezed,Object? imageUrl = freezed,Object? githubUrl = freezed,Object? techStack = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,desc: freezed == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,githubUrl: freezed == githubUrl ? _self.githubUrl : githubUrl // ignore: cast_nullable_to_non_nullable
as String?,techStack: null == techStack ? _self.techStack : techStack // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectModel].
extension ProjectModelPatterns on ProjectModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectModel value)  $default,){
final _that = this;
switch (_that) {
case _ProjectModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ToStringConverter()  String? id,  String? title,  String? subtitle,  String? desc,  String? imageUrl,  String? githubUrl,  List<String> techStack)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectModel() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.desc,_that.imageUrl,_that.githubUrl,_that.techStack);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ToStringConverter()  String? id,  String? title,  String? subtitle,  String? desc,  String? imageUrl,  String? githubUrl,  List<String> techStack)  $default,) {final _that = this;
switch (_that) {
case _ProjectModel():
return $default(_that.id,_that.title,_that.subtitle,_that.desc,_that.imageUrl,_that.githubUrl,_that.techStack);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ToStringConverter()  String? id,  String? title,  String? subtitle,  String? desc,  String? imageUrl,  String? githubUrl,  List<String> techStack)?  $default,) {final _that = this;
switch (_that) {
case _ProjectModel() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.desc,_that.imageUrl,_that.githubUrl,_that.techStack);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectModel implements ProjectModel {
  const _ProjectModel({@ToStringConverter() this.id, this.title, this.subtitle, this.desc, this.imageUrl, this.githubUrl, final  List<String> techStack = const []}): _techStack = techStack;
  factory _ProjectModel.fromJson(Map<String, dynamic> json) => _$ProjectModelFromJson(json);

@override@ToStringConverter() final  String? id;
@override final  String? title;
@override final  String? subtitle;
@override final  String? desc;
@override final  String? imageUrl;
@override final  String? githubUrl;
 final  List<String> _techStack;
@override@JsonKey() List<String> get techStack {
  if (_techStack is EqualUnmodifiableListView) return _techStack;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_techStack);
}


/// Create a copy of ProjectModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectModelCopyWith<_ProjectModel> get copyWith => __$ProjectModelCopyWithImpl<_ProjectModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.githubUrl, githubUrl) || other.githubUrl == githubUrl)&&const DeepCollectionEquality().equals(other._techStack, _techStack));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,desc,imageUrl,githubUrl,const DeepCollectionEquality().hash(_techStack));

@override
String toString() {
  return 'ProjectModel(id: $id, title: $title, subtitle: $subtitle, desc: $desc, imageUrl: $imageUrl, githubUrl: $githubUrl, techStack: $techStack)';
}


}

/// @nodoc
abstract mixin class _$ProjectModelCopyWith<$Res> implements $ProjectModelCopyWith<$Res> {
  factory _$ProjectModelCopyWith(_ProjectModel value, $Res Function(_ProjectModel) _then) = __$ProjectModelCopyWithImpl;
@override @useResult
$Res call({
@ToStringConverter() String? id, String? title, String? subtitle, String? desc, String? imageUrl, String? githubUrl, List<String> techStack
});




}
/// @nodoc
class __$ProjectModelCopyWithImpl<$Res>
    implements _$ProjectModelCopyWith<$Res> {
  __$ProjectModelCopyWithImpl(this._self, this._then);

  final _ProjectModel _self;
  final $Res Function(_ProjectModel) _then;

/// Create a copy of ProjectModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = freezed,Object? subtitle = freezed,Object? desc = freezed,Object? imageUrl = freezed,Object? githubUrl = freezed,Object? techStack = null,}) {
  return _then(_ProjectModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,desc: freezed == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,githubUrl: freezed == githubUrl ? _self.githubUrl : githubUrl // ignore: cast_nullable_to_non_nullable
as String?,techStack: null == techStack ? _self._techStack : techStack // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
