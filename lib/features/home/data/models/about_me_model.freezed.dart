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

 String? get status; String? get jobTitle; String? get bio; String? get graduationYear; String? get major; String? get github; List<String> get certifications; List<AboutMeStatModel> get stats; List<ExperienceItemModel> get experiences; List<EducationItemModel> get education; List<SkillCategoryModel> get skills; List<LanguageItemModel> get languages;
/// Create a copy of AboutMeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AboutMeModelCopyWith<AboutMeModel> get copyWith => _$AboutMeModelCopyWithImpl<AboutMeModel>(this as AboutMeModel, _$identity);

  /// Serializes this AboutMeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AboutMeModel&&(identical(other.status, status) || other.status == status)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.graduationYear, graduationYear) || other.graduationYear == graduationYear)&&(identical(other.major, major) || other.major == major)&&(identical(other.github, github) || other.github == github)&&const DeepCollectionEquality().equals(other.certifications, certifications)&&const DeepCollectionEquality().equals(other.stats, stats)&&const DeepCollectionEquality().equals(other.experiences, experiences)&&const DeepCollectionEquality().equals(other.education, education)&&const DeepCollectionEquality().equals(other.skills, skills)&&const DeepCollectionEquality().equals(other.languages, languages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,jobTitle,bio,graduationYear,major,github,const DeepCollectionEquality().hash(certifications),const DeepCollectionEquality().hash(stats),const DeepCollectionEquality().hash(experiences),const DeepCollectionEquality().hash(education),const DeepCollectionEquality().hash(skills),const DeepCollectionEquality().hash(languages));

@override
String toString() {
  return 'AboutMeModel(status: $status, jobTitle: $jobTitle, bio: $bio, graduationYear: $graduationYear, major: $major, github: $github, certifications: $certifications, stats: $stats, experiences: $experiences, education: $education, skills: $skills, languages: $languages)';
}


}

/// @nodoc
abstract mixin class $AboutMeModelCopyWith<$Res>  {
  factory $AboutMeModelCopyWith(AboutMeModel value, $Res Function(AboutMeModel) _then) = _$AboutMeModelCopyWithImpl;
@useResult
$Res call({
 String? status, String? jobTitle, String? bio, String? graduationYear, String? major, String? github, List<String> certifications, List<AboutMeStatModel> stats, List<ExperienceItemModel> experiences, List<EducationItemModel> education, List<SkillCategoryModel> skills, List<LanguageItemModel> languages
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
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? jobTitle = freezed,Object? bio = freezed,Object? graduationYear = freezed,Object? major = freezed,Object? github = freezed,Object? certifications = null,Object? stats = null,Object? experiences = null,Object? education = null,Object? skills = null,Object? languages = null,}) {
  return _then(_self.copyWith(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,jobTitle: freezed == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,graduationYear: freezed == graduationYear ? _self.graduationYear : graduationYear // ignore: cast_nullable_to_non_nullable
as String?,major: freezed == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as String?,github: freezed == github ? _self.github : github // ignore: cast_nullable_to_non_nullable
as String?,certifications: null == certifications ? _self.certifications : certifications // ignore: cast_nullable_to_non_nullable
as List<String>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as List<AboutMeStatModel>,experiences: null == experiences ? _self.experiences : experiences // ignore: cast_nullable_to_non_nullable
as List<ExperienceItemModel>,education: null == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as List<EducationItemModel>,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as List<SkillCategoryModel>,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<LanguageItemModel>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? status,  String? jobTitle,  String? bio,  String? graduationYear,  String? major,  String? github,  List<String> certifications,  List<AboutMeStatModel> stats,  List<ExperienceItemModel> experiences,  List<EducationItemModel> education,  List<SkillCategoryModel> skills,  List<LanguageItemModel> languages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AboutMeModel() when $default != null:
return $default(_that.status,_that.jobTitle,_that.bio,_that.graduationYear,_that.major,_that.github,_that.certifications,_that.stats,_that.experiences,_that.education,_that.skills,_that.languages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? status,  String? jobTitle,  String? bio,  String? graduationYear,  String? major,  String? github,  List<String> certifications,  List<AboutMeStatModel> stats,  List<ExperienceItemModel> experiences,  List<EducationItemModel> education,  List<SkillCategoryModel> skills,  List<LanguageItemModel> languages)  $default,) {final _that = this;
switch (_that) {
case _AboutMeModel():
return $default(_that.status,_that.jobTitle,_that.bio,_that.graduationYear,_that.major,_that.github,_that.certifications,_that.stats,_that.experiences,_that.education,_that.skills,_that.languages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? status,  String? jobTitle,  String? bio,  String? graduationYear,  String? major,  String? github,  List<String> certifications,  List<AboutMeStatModel> stats,  List<ExperienceItemModel> experiences,  List<EducationItemModel> education,  List<SkillCategoryModel> skills,  List<LanguageItemModel> languages)?  $default,) {final _that = this;
switch (_that) {
case _AboutMeModel() when $default != null:
return $default(_that.status,_that.jobTitle,_that.bio,_that.graduationYear,_that.major,_that.github,_that.certifications,_that.stats,_that.experiences,_that.education,_that.skills,_that.languages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AboutMeModel implements AboutMeModel {
  const _AboutMeModel({this.status, this.jobTitle, this.bio, this.graduationYear, this.major, this.github, final  List<String> certifications = const [], final  List<AboutMeStatModel> stats = const [], final  List<ExperienceItemModel> experiences = const [], final  List<EducationItemModel> education = const [], final  List<SkillCategoryModel> skills = const [], final  List<LanguageItemModel> languages = const []}): _certifications = certifications,_stats = stats,_experiences = experiences,_education = education,_skills = skills,_languages = languages;
  factory _AboutMeModel.fromJson(Map<String, dynamic> json) => _$AboutMeModelFromJson(json);

@override final  String? status;
@override final  String? jobTitle;
@override final  String? bio;
@override final  String? graduationYear;
@override final  String? major;
@override final  String? github;
 final  List<String> _certifications;
@override@JsonKey() List<String> get certifications {
  if (_certifications is EqualUnmodifiableListView) return _certifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_certifications);
}

 final  List<AboutMeStatModel> _stats;
@override@JsonKey() List<AboutMeStatModel> get stats {
  if (_stats is EqualUnmodifiableListView) return _stats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stats);
}

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

 final  List<LanguageItemModel> _languages;
@override@JsonKey() List<LanguageItemModel> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AboutMeModel&&(identical(other.status, status) || other.status == status)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.graduationYear, graduationYear) || other.graduationYear == graduationYear)&&(identical(other.major, major) || other.major == major)&&(identical(other.github, github) || other.github == github)&&const DeepCollectionEquality().equals(other._certifications, _certifications)&&const DeepCollectionEquality().equals(other._stats, _stats)&&const DeepCollectionEquality().equals(other._experiences, _experiences)&&const DeepCollectionEquality().equals(other._education, _education)&&const DeepCollectionEquality().equals(other._skills, _skills)&&const DeepCollectionEquality().equals(other._languages, _languages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,jobTitle,bio,graduationYear,major,github,const DeepCollectionEquality().hash(_certifications),const DeepCollectionEquality().hash(_stats),const DeepCollectionEquality().hash(_experiences),const DeepCollectionEquality().hash(_education),const DeepCollectionEquality().hash(_skills),const DeepCollectionEquality().hash(_languages));

@override
String toString() {
  return 'AboutMeModel(status: $status, jobTitle: $jobTitle, bio: $bio, graduationYear: $graduationYear, major: $major, github: $github, certifications: $certifications, stats: $stats, experiences: $experiences, education: $education, skills: $skills, languages: $languages)';
}


}

/// @nodoc
abstract mixin class _$AboutMeModelCopyWith<$Res> implements $AboutMeModelCopyWith<$Res> {
  factory _$AboutMeModelCopyWith(_AboutMeModel value, $Res Function(_AboutMeModel) _then) = __$AboutMeModelCopyWithImpl;
@override @useResult
$Res call({
 String? status, String? jobTitle, String? bio, String? graduationYear, String? major, String? github, List<String> certifications, List<AboutMeStatModel> stats, List<ExperienceItemModel> experiences, List<EducationItemModel> education, List<SkillCategoryModel> skills, List<LanguageItemModel> languages
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
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? jobTitle = freezed,Object? bio = freezed,Object? graduationYear = freezed,Object? major = freezed,Object? github = freezed,Object? certifications = null,Object? stats = null,Object? experiences = null,Object? education = null,Object? skills = null,Object? languages = null,}) {
  return _then(_AboutMeModel(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,jobTitle: freezed == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,graduationYear: freezed == graduationYear ? _self.graduationYear : graduationYear // ignore: cast_nullable_to_non_nullable
as String?,major: freezed == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as String?,github: freezed == github ? _self.github : github // ignore: cast_nullable_to_non_nullable
as String?,certifications: null == certifications ? _self._certifications : certifications // ignore: cast_nullable_to_non_nullable
as List<String>,stats: null == stats ? _self._stats : stats // ignore: cast_nullable_to_non_nullable
as List<AboutMeStatModel>,experiences: null == experiences ? _self._experiences : experiences // ignore: cast_nullable_to_non_nullable
as List<ExperienceItemModel>,education: null == education ? _self._education : education // ignore: cast_nullable_to_non_nullable
as List<EducationItemModel>,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as List<SkillCategoryModel>,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<LanguageItemModel>,
  ));
}


}


/// @nodoc
mixin _$AboutMeStatModel {

@ToStringConverter() String? get id; String? get businessId; String? get year; String? get label; List<String> get tags;
/// Create a copy of AboutMeStatModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AboutMeStatModelCopyWith<AboutMeStatModel> get copyWith => _$AboutMeStatModelCopyWithImpl<AboutMeStatModel>(this as AboutMeStatModel, _$identity);

  /// Serializes this AboutMeStatModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AboutMeStatModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.year, year) || other.year == year)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessId,year,label,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'AboutMeStatModel(id: $id, businessId: $businessId, year: $year, label: $label, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $AboutMeStatModelCopyWith<$Res>  {
  factory $AboutMeStatModelCopyWith(AboutMeStatModel value, $Res Function(AboutMeStatModel) _then) = _$AboutMeStatModelCopyWithImpl;
@useResult
$Res call({
@ToStringConverter() String? id, String? businessId, String? year, String? label, List<String> tags
});




}
/// @nodoc
class _$AboutMeStatModelCopyWithImpl<$Res>
    implements $AboutMeStatModelCopyWith<$Res> {
  _$AboutMeStatModelCopyWithImpl(this._self, this._then);

  final AboutMeStatModel _self;
  final $Res Function(AboutMeStatModel) _then;

/// Create a copy of AboutMeStatModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? businessId = freezed,Object? year = freezed,Object? label = freezed,Object? tags = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,businessId: freezed == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AboutMeStatModel].
extension AboutMeStatModelPatterns on AboutMeStatModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AboutMeStatModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AboutMeStatModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AboutMeStatModel value)  $default,){
final _that = this;
switch (_that) {
case _AboutMeStatModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AboutMeStatModel value)?  $default,){
final _that = this;
switch (_that) {
case _AboutMeStatModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ToStringConverter()  String? id,  String? businessId,  String? year,  String? label,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AboutMeStatModel() when $default != null:
return $default(_that.id,_that.businessId,_that.year,_that.label,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ToStringConverter()  String? id,  String? businessId,  String? year,  String? label,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _AboutMeStatModel():
return $default(_that.id,_that.businessId,_that.year,_that.label,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ToStringConverter()  String? id,  String? businessId,  String? year,  String? label,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _AboutMeStatModel() when $default != null:
return $default(_that.id,_that.businessId,_that.year,_that.label,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AboutMeStatModel implements AboutMeStatModel {
  const _AboutMeStatModel({@ToStringConverter() this.id, this.businessId, this.year, this.label, final  List<String> tags = const []}): _tags = tags;
  factory _AboutMeStatModel.fromJson(Map<String, dynamic> json) => _$AboutMeStatModelFromJson(json);

@override@ToStringConverter() final  String? id;
@override final  String? businessId;
@override final  String? year;
@override final  String? label;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of AboutMeStatModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AboutMeStatModelCopyWith<_AboutMeStatModel> get copyWith => __$AboutMeStatModelCopyWithImpl<_AboutMeStatModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AboutMeStatModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AboutMeStatModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.year, year) || other.year == year)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessId,year,label,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'AboutMeStatModel(id: $id, businessId: $businessId, year: $year, label: $label, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$AboutMeStatModelCopyWith<$Res> implements $AboutMeStatModelCopyWith<$Res> {
  factory _$AboutMeStatModelCopyWith(_AboutMeStatModel value, $Res Function(_AboutMeStatModel) _then) = __$AboutMeStatModelCopyWithImpl;
@override @useResult
$Res call({
@ToStringConverter() String? id, String? businessId, String? year, String? label, List<String> tags
});




}
/// @nodoc
class __$AboutMeStatModelCopyWithImpl<$Res>
    implements _$AboutMeStatModelCopyWith<$Res> {
  __$AboutMeStatModelCopyWithImpl(this._self, this._then);

  final _AboutMeStatModel _self;
  final $Res Function(_AboutMeStatModel) _then;

/// Create a copy of AboutMeStatModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? businessId = freezed,Object? year = freezed,Object? label = freezed,Object? tags = null,}) {
  return _then(_AboutMeStatModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,businessId: freezed == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
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


/// @nodoc
mixin _$LanguageItemModel {

 String? get name; String? get level;
/// Create a copy of LanguageItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LanguageItemModelCopyWith<LanguageItemModel> get copyWith => _$LanguageItemModelCopyWithImpl<LanguageItemModel>(this as LanguageItemModel, _$identity);

  /// Serializes this LanguageItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LanguageItemModel&&(identical(other.name, name) || other.name == name)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,level);

@override
String toString() {
  return 'LanguageItemModel(name: $name, level: $level)';
}


}

/// @nodoc
abstract mixin class $LanguageItemModelCopyWith<$Res>  {
  factory $LanguageItemModelCopyWith(LanguageItemModel value, $Res Function(LanguageItemModel) _then) = _$LanguageItemModelCopyWithImpl;
@useResult
$Res call({
 String? name, String? level
});




}
/// @nodoc
class _$LanguageItemModelCopyWithImpl<$Res>
    implements $LanguageItemModelCopyWith<$Res> {
  _$LanguageItemModelCopyWithImpl(this._self, this._then);

  final LanguageItemModel _self;
  final $Res Function(LanguageItemModel) _then;

/// Create a copy of LanguageItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? level = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LanguageItemModel].
extension LanguageItemModelPatterns on LanguageItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LanguageItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LanguageItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LanguageItemModel value)  $default,){
final _that = this;
switch (_that) {
case _LanguageItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LanguageItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _LanguageItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? level)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LanguageItemModel() when $default != null:
return $default(_that.name,_that.level);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? level)  $default,) {final _that = this;
switch (_that) {
case _LanguageItemModel():
return $default(_that.name,_that.level);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? level)?  $default,) {final _that = this;
switch (_that) {
case _LanguageItemModel() when $default != null:
return $default(_that.name,_that.level);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LanguageItemModel implements LanguageItemModel {
  const _LanguageItemModel({this.name, this.level});
  factory _LanguageItemModel.fromJson(Map<String, dynamic> json) => _$LanguageItemModelFromJson(json);

@override final  String? name;
@override final  String? level;

/// Create a copy of LanguageItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LanguageItemModelCopyWith<_LanguageItemModel> get copyWith => __$LanguageItemModelCopyWithImpl<_LanguageItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LanguageItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LanguageItemModel&&(identical(other.name, name) || other.name == name)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,level);

@override
String toString() {
  return 'LanguageItemModel(name: $name, level: $level)';
}


}

/// @nodoc
abstract mixin class _$LanguageItemModelCopyWith<$Res> implements $LanguageItemModelCopyWith<$Res> {
  factory _$LanguageItemModelCopyWith(_LanguageItemModel value, $Res Function(_LanguageItemModel) _then) = __$LanguageItemModelCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? level
});




}
/// @nodoc
class __$LanguageItemModelCopyWithImpl<$Res>
    implements _$LanguageItemModelCopyWith<$Res> {
  __$LanguageItemModelCopyWithImpl(this._self, this._then);

  final _LanguageItemModel _self;
  final $Res Function(_LanguageItemModel) _then;

/// Create a copy of LanguageItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? level = freezed,}) {
  return _then(_LanguageItemModel(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
