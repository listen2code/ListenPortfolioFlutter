// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'about_me_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AboutMeModel {

 String? get bio; List<ExperienceItemModel> get experiences; List<EducationItemModel> get education; List<SkillCategoryModel> get skills;
/// Create a copy of AboutMeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AboutMeModelCopyWith<AboutMeModel> get copyWith => _$AboutMeModelCopyWithImpl<AboutMeModel>(this as AboutMeModel, _$identity);

  /// Serializes this AboutMeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AboutMeModel&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other.experiences, experiences)&&const DeepCollectionEquality().equals(other.education, education)&&const DeepCollectionEquality().equals(other.skills, skills));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bio,const DeepCollectionEquality().hash(experiences),const DeepCollectionEquality().hash(education),const DeepCollectionEquality().hash(skills));

@override
String toString() {
  return 'AboutMeModel(bio: $bio, experiences: $experiences, education: $education, skills: $skills)';
}


}

/// @nodoc
abstract mixin class $AboutMeModelCopyWith<$Res>  {
  factory $AboutMeModelCopyWith(AboutMeModel value, $Res Function(AboutMeModel) _then) = _$AboutMeModelCopyWithImpl;
@useResult
$Res call({
 String? bio, List<ExperienceItemModel> experiences, List<EducationItemModel> education, List<SkillCategoryModel> skills
});




}
/// @nodoc
class _$AboutMeModelCopyWithImpl<$Res>
    implements $AboutMeModelCopyWith<$Res> {
  _$AboutMeModelCopyWithImpl(this._self, this._then);

  final AboutMeModel _self;
  final $Res Function(AboutMeModel) _then;

/// Create a copy of AboutMeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bio = freezed,Object? experiences = null,Object? education = null,Object? skills = null,}) {
  return _then(_self.copyWith(
bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,experiences: null == experiences ? _self.experiences : experiences // ignore: cast_nullable_to_non_nullable
as List<ExperienceItemModel>,education: null == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as List<EducationItemModel>,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as List<SkillCategoryModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [AboutMeModel].
extension AboutMeModelPatterns on AboutMeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AboutMeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AboutMeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AboutMeModel value)  $default,){
final _that = this;
switch (_that) {
case _AboutMeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AboutMeModel value)?  $default,){
final _that = this;
switch (_that) {
case _AboutMeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? bio,  List<ExperienceItemModel> experiences,  List<EducationItemModel> education,  List<SkillCategoryModel> skills)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AboutMeModel() when $default != null:
return $default(_that.bio,_that.experiences,_that.education,_that.skills);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? bio,  List<ExperienceItemModel> experiences,  List<EducationItemModel> education,  List<SkillCategoryModel> skills)  $default,) {final _that = this;
switch (_that) {
case _AboutMeModel():
return $default(_that.bio,_that.experiences,_that.education,_that.skills);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? bio,  List<ExperienceItemModel> experiences,  List<EducationItemModel> education,  List<SkillCategoryModel> skills)?  $default,) {final _that = this;
switch (_that) {
case _AboutMeModel() when $default != null:
return $default(_that.bio,_that.experiences,_that.education,_that.skills);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AboutMeModel implements AboutMeModel {
  const _AboutMeModel({this.bio, final  List<ExperienceItemModel> experiences = const [], final  List<EducationItemModel> education = const [], final  List<SkillCategoryModel> skills = const []}): _experiences = experiences,_education = education,_skills = skills;
  factory _AboutMeModel.fromJson(Map<String, dynamic> json) => _$AboutMeModelFromJson(json);

@override final  String? bio;
 final  List<ExperienceItemModel> _experiences;
@override@JsonKey() List<ExperienceItemModel> get experiences {
  if (_experiences is EqualUnmodifiableListView) return _experiences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_experiences);
}

 final  List<EducationItemModel> _education;
@override@JsonKey() List<EducationItemModel> get education {
  if (_education is EqualUnmodifiableListView) return _education;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_education);
}

 final  List<SkillCategoryModel> _skills;
@override@JsonKey() List<SkillCategoryModel> get skills {
  if (_skills is EqualUnmodifiableListView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skills);
}


/// Create a copy of AboutMeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AboutMeModelCopyWith<_AboutMeModel> get copyWith => __$AboutMeModelCopyWithImpl<_AboutMeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AboutMeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AboutMeModel&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other._experiences, _experiences)&&const DeepCollectionEquality().equals(other._education, _education)&&const DeepCollectionEquality().equals(other._skills, _skills));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bio,const DeepCollectionEquality().hash(_experiences),const DeepCollectionEquality().hash(_education),const DeepCollectionEquality().hash(_skills));

@override
String toString() {
  return 'AboutMeModel(bio: $bio, experiences: $experiences, education: $education, skills: $skills)';
}


}

/// @nodoc
abstract mixin class _$AboutMeModelCopyWith<$Res> implements $AboutMeModelCopyWith<$Res> {
  factory _$AboutMeModelCopyWith(_AboutMeModel value, $Res Function(_AboutMeModel) _then) = __$AboutMeModelCopyWithImpl;
@override @useResult
$Res call({
 String? bio, List<ExperienceItemModel> experiences, List<EducationItemModel> education, List<SkillCategoryModel> skills
});




}
/// @nodoc
class __$AboutMeModelCopyWithImpl<$Res>
    implements _$AboutMeModelCopyWith<$Res> {
  __$AboutMeModelCopyWithImpl(this._self, this._then);

  final _AboutMeModel _self;
  final $Res Function(_AboutMeModel) _then;

/// Create a copy of AboutMeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bio = freezed,Object? experiences = null,Object? education = null,Object? skills = null,}) {
  return _then(_AboutMeModel(
bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,experiences: null == experiences ? _self._experiences : experiences // ignore: cast_nullable_to_non_nullable
as List<ExperienceItemModel>,education: null == education ? _self._education : education // ignore: cast_nullable_to_non_nullable
as List<EducationItemModel>,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as List<SkillCategoryModel>,
  ));
}


}


/// @nodoc
mixin _$ExperienceItemModel {

 String? get title; String? get company; String? get period; String? get description;
/// Create a copy of ExperienceItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExperienceItemModelCopyWith<ExperienceItemModel> get copyWith => _$ExperienceItemModelCopyWithImpl<ExperienceItemModel>(this as ExperienceItemModel, _$identity);

  /// Serializes this ExperienceItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExperienceItemModel&&(identical(other.title, title) || other.title == title)&&(identical(other.company, company) || other.company == company)&&(identical(other.period, period) || other.period == period)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,company,period,description);

@override
String toString() {
  return 'ExperienceItemModel(title: $title, company: $company, period: $period, description: $description)';
}


}

/// @nodoc
abstract mixin class $ExperienceItemModelCopyWith<$Res>  {
  factory $ExperienceItemModelCopyWith(ExperienceItemModel value, $Res Function(ExperienceItemModel) _then) = _$ExperienceItemModelCopyWithImpl;
@useResult
$Res call({
 String? title, String? company, String? period, String? description
});




}
/// @nodoc
class _$ExperienceItemModelCopyWithImpl<$Res>
    implements $ExperienceItemModelCopyWith<$Res> {
  _$ExperienceItemModelCopyWithImpl(this._self, this._then);

  final ExperienceItemModel _self;
  final $Res Function(ExperienceItemModel) _then;

/// Create a copy of ExperienceItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? company = freezed,Object? period = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,period: freezed == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExperienceItemModel].
extension ExperienceItemModelPatterns on ExperienceItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExperienceItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExperienceItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExperienceItemModel value)  $default,){
final _that = this;
switch (_that) {
case _ExperienceItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExperienceItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExperienceItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? company,  String? period,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExperienceItemModel() when $default != null:
return $default(_that.title,_that.company,_that.period,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? company,  String? period,  String? description)  $default,) {final _that = this;
switch (_that) {
case _ExperienceItemModel():
return $default(_that.title,_that.company,_that.period,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? company,  String? period,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _ExperienceItemModel() when $default != null:
return $default(_that.title,_that.company,_that.period,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExperienceItemModel implements ExperienceItemModel {
  const _ExperienceItemModel({this.title, this.company, this.period, this.description});
  factory _ExperienceItemModel.fromJson(Map<String, dynamic> json) => _$ExperienceItemModelFromJson(json);

@override final  String? title;
@override final  String? company;
@override final  String? period;
@override final  String? description;

/// Create a copy of ExperienceItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExperienceItemModelCopyWith<_ExperienceItemModel> get copyWith => __$ExperienceItemModelCopyWithImpl<_ExperienceItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExperienceItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExperienceItemModel&&(identical(other.title, title) || other.title == title)&&(identical(other.company, company) || other.company == company)&&(identical(other.period, period) || other.period == period)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,company,period,description);

@override
String toString() {
  return 'ExperienceItemModel(title: $title, company: $company, period: $period, description: $description)';
}


}

/// @nodoc
abstract mixin class _$ExperienceItemModelCopyWith<$Res> implements $ExperienceItemModelCopyWith<$Res> {
  factory _$ExperienceItemModelCopyWith(_ExperienceItemModel value, $Res Function(_ExperienceItemModel) _then) = __$ExperienceItemModelCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? company, String? period, String? description
});




}
/// @nodoc
class __$ExperienceItemModelCopyWithImpl<$Res>
    implements _$ExperienceItemModelCopyWith<$Res> {
  __$ExperienceItemModelCopyWithImpl(this._self, this._then);

  final _ExperienceItemModel _self;
  final $Res Function(_ExperienceItemModel) _then;

/// Create a copy of ExperienceItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? company = freezed,Object? period = freezed,Object? description = freezed,}) {
  return _then(_ExperienceItemModel(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,period: freezed == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$EducationItemModel {

 String? get degree; String? get school; String? get period; String? get description;
/// Create a copy of EducationItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EducationItemModelCopyWith<EducationItemModel> get copyWith => _$EducationItemModelCopyWithImpl<EducationItemModel>(this as EducationItemModel, _$identity);

  /// Serializes this EducationItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EducationItemModel&&(identical(other.degree, degree) || other.degree == degree)&&(identical(other.school, school) || other.school == school)&&(identical(other.period, period) || other.period == period)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,degree,school,period,description);

@override
String toString() {
  return 'EducationItemModel(degree: $degree, school: $school, period: $period, description: $description)';
}


}

/// @nodoc
abstract mixin class $EducationItemModelCopyWith<$Res>  {
  factory $EducationItemModelCopyWith(EducationItemModel value, $Res Function(EducationItemModel) _then) = _$EducationItemModelCopyWithImpl;
@useResult
$Res call({
 String? degree, String? school, String? period, String? description
});




}
/// @nodoc
class _$EducationItemModelCopyWithImpl<$Res>
    implements $EducationItemModelCopyWith<$Res> {
  _$EducationItemModelCopyWithImpl(this._self, this._then);

  final EducationItemModel _self;
  final $Res Function(EducationItemModel) _then;

/// Create a copy of EducationItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? degree = freezed,Object? school = freezed,Object? period = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
degree: freezed == degree ? _self.degree : degree // ignore: cast_nullable_to_non_nullable
as String?,school: freezed == school ? _self.school : school // ignore: cast_nullable_to_non_nullable
as String?,period: freezed == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EducationItemModel].
extension EducationItemModelPatterns on EducationItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EducationItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EducationItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EducationItemModel value)  $default,){
final _that = this;
switch (_that) {
case _EducationItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EducationItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _EducationItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? degree,  String? school,  String? period,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EducationItemModel() when $default != null:
return $default(_that.degree,_that.school,_that.period,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? degree,  String? school,  String? period,  String? description)  $default,) {final _that = this;
switch (_that) {
case _EducationItemModel():
return $default(_that.degree,_that.school,_that.period,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? degree,  String? school,  String? period,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _EducationItemModel() when $default != null:
return $default(_that.degree,_that.school,_that.period,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EducationItemModel implements EducationItemModel {
  const _EducationItemModel({this.degree, this.school, this.period, this.description});
  factory _EducationItemModel.fromJson(Map<String, dynamic> json) => _$EducationItemModelFromJson(json);

@override final  String? degree;
@override final  String? school;
@override final  String? period;
@override final  String? description;

/// Create a copy of EducationItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EducationItemModelCopyWith<_EducationItemModel> get copyWith => __$EducationItemModelCopyWithImpl<_EducationItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EducationItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EducationItemModel&&(identical(other.degree, degree) || other.degree == degree)&&(identical(other.school, school) || other.school == school)&&(identical(other.period, period) || other.period == period)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,degree,school,period,description);

@override
String toString() {
  return 'EducationItemModel(degree: $degree, school: $school, period: $period, description: $description)';
}


}

/// @nodoc
abstract mixin class _$EducationItemModelCopyWith<$Res> implements $EducationItemModelCopyWith<$Res> {
  factory _$EducationItemModelCopyWith(_EducationItemModel value, $Res Function(_EducationItemModel) _then) = __$EducationItemModelCopyWithImpl;
@override @useResult
$Res call({
 String? degree, String? school, String? period, String? description
});




}
/// @nodoc
class __$EducationItemModelCopyWithImpl<$Res>
    implements _$EducationItemModelCopyWith<$Res> {
  __$EducationItemModelCopyWithImpl(this._self, this._then);

  final _EducationItemModel _self;
  final $Res Function(_EducationItemModel) _then;

/// Create a copy of EducationItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? degree = freezed,Object? school = freezed,Object? period = freezed,Object? description = freezed,}) {
  return _then(_EducationItemModel(
degree: freezed == degree ? _self.degree : degree // ignore: cast_nullable_to_non_nullable
as String?,school: freezed == school ? _self.school : school // ignore: cast_nullable_to_non_nullable
as String?,period: freezed == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SkillCategoryModel {

 String? get category; List<String> get items;
/// Create a copy of SkillCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkillCategoryModelCopyWith<SkillCategoryModel> get copyWith => _$SkillCategoryModelCopyWithImpl<SkillCategoryModel>(this as SkillCategoryModel, _$identity);

  /// Serializes this SkillCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkillCategoryModel&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'SkillCategoryModel(category: $category, items: $items)';
}


}

/// @nodoc
abstract mixin class $SkillCategoryModelCopyWith<$Res>  {
  factory $SkillCategoryModelCopyWith(SkillCategoryModel value, $Res Function(SkillCategoryModel) _then) = _$SkillCategoryModelCopyWithImpl;
@useResult
$Res call({
 String? category, List<String> items
});




}
/// @nodoc
class _$SkillCategoryModelCopyWithImpl<$Res>
    implements $SkillCategoryModelCopyWith<$Res> {
  _$SkillCategoryModelCopyWithImpl(this._self, this._then);

  final SkillCategoryModel _self;
  final $Res Function(SkillCategoryModel) _then;

/// Create a copy of SkillCategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SkillCategoryModel].
extension SkillCategoryModelPatterns on SkillCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SkillCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SkillCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SkillCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _SkillCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SkillCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _SkillCategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? category,  List<String> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SkillCategoryModel() when $default != null:
return $default(_that.category,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? category,  List<String> items)  $default,) {final _that = this;
switch (_that) {
case _SkillCategoryModel():
return $default(_that.category,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? category,  List<String> items)?  $default,) {final _that = this;
switch (_that) {
case _SkillCategoryModel() when $default != null:
return $default(_that.category,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SkillCategoryModel implements SkillCategoryModel {
  const _SkillCategoryModel({this.category, final  List<String> items = const []}): _items = items;
  factory _SkillCategoryModel.fromJson(Map<String, dynamic> json) => _$SkillCategoryModelFromJson(json);

@override final  String? category;
 final  List<String> _items;
@override@JsonKey() List<String> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SkillCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SkillCategoryModelCopyWith<_SkillCategoryModel> get copyWith => __$SkillCategoryModelCopyWithImpl<_SkillCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SkillCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkillCategoryModel&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'SkillCategoryModel(category: $category, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SkillCategoryModelCopyWith<$Res> implements $SkillCategoryModelCopyWith<$Res> {
  factory _$SkillCategoryModelCopyWith(_SkillCategoryModel value, $Res Function(_SkillCategoryModel) _then) = __$SkillCategoryModelCopyWithImpl;
@override @useResult
$Res call({
 String? category, List<String> items
});




}
/// @nodoc
class __$SkillCategoryModelCopyWithImpl<$Res>
    implements _$SkillCategoryModelCopyWith<$Res> {
  __$SkillCategoryModelCopyWithImpl(this._self, this._then);

  final _SkillCategoryModel _self;
  final $Res Function(_SkillCategoryModel) _then;

/// Create a copy of SkillCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = freezed,Object? items = null,}) {
  return _then(_SkillCategoryModel(
category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
