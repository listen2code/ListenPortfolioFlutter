// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserResponseModel {

 String? get id; String? get name; String? get avatarUrl; String? get jobTitle; String? get graduationYear; String? get major; String? get status; String? get github; String? get email; List<String>? get certifications; List<ExperienceModel>? get experiences;
/// Create a copy of UserResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserResponseModelCopyWith<UserResponseModel> get copyWith => _$UserResponseModelCopyWithImpl<UserResponseModel>(this as UserResponseModel, _$identity);

  /// Serializes this UserResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserResponseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.graduationYear, graduationYear) || other.graduationYear == graduationYear)&&(identical(other.major, major) || other.major == major)&&(identical(other.status, status) || other.status == status)&&(identical(other.github, github) || other.github == github)&&(identical(other.email, email) || other.email == email)&&const DeepCollectionEquality().equals(other.certifications, certifications)&&const DeepCollectionEquality().equals(other.experiences, experiences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,jobTitle,graduationYear,major,status,github,email,const DeepCollectionEquality().hash(certifications),const DeepCollectionEquality().hash(experiences));

@override
String toString() {
  return 'UserResponseModel(id: $id, name: $name, avatarUrl: $avatarUrl, jobTitle: $jobTitle, graduationYear: $graduationYear, major: $major, status: $status, github: $github, email: $email, certifications: $certifications, experiences: $experiences)';
}


}

/// @nodoc
abstract mixin class $UserResponseModelCopyWith<$Res>  {
  factory $UserResponseModelCopyWith(UserResponseModel value, $Res Function(UserResponseModel) _then) = _$UserResponseModelCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String? avatarUrl, String? jobTitle, String? graduationYear, String? major, String? status, String? github, String? email, List<String>? certifications, List<ExperienceModel>? experiences
});




}
/// @nodoc
class _$UserResponseModelCopyWithImpl<$Res>
    implements $UserResponseModelCopyWith<$Res> {
  _$UserResponseModelCopyWithImpl(this._self, this._then);

  final UserResponseModel _self;
  final $Res Function(UserResponseModel) _then;

/// Create a copy of UserResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? avatarUrl = freezed,Object? jobTitle = freezed,Object? graduationYear = freezed,Object? major = freezed,Object? status = freezed,Object? github = freezed,Object? email = freezed,Object? certifications = freezed,Object? experiences = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,jobTitle: freezed == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String?,graduationYear: freezed == graduationYear ? _self.graduationYear : graduationYear // ignore: cast_nullable_to_non_nullable
as String?,major: freezed == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,github: freezed == github ? _self.github : github // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,certifications: freezed == certifications ? _self.certifications : certifications // ignore: cast_nullable_to_non_nullable
as List<String>?,experiences: freezed == experiences ? _self.experiences : experiences // ignore: cast_nullable_to_non_nullable
as List<ExperienceModel>?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserResponseModel].
extension UserResponseModelPatterns on UserResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _UserResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? name,  String? avatarUrl,  String? jobTitle,  String? graduationYear,  String? major,  String? status,  String? github,  String? email,  List<String>? certifications,  List<ExperienceModel>? experiences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserResponseModel() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.jobTitle,_that.graduationYear,_that.major,_that.status,_that.github,_that.email,_that.certifications,_that.experiences);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? name,  String? avatarUrl,  String? jobTitle,  String? graduationYear,  String? major,  String? status,  String? github,  String? email,  List<String>? certifications,  List<ExperienceModel>? experiences)  $default,) {final _that = this;
switch (_that) {
case _UserResponseModel():
return $default(_that.id,_that.name,_that.avatarUrl,_that.jobTitle,_that.graduationYear,_that.major,_that.status,_that.github,_that.email,_that.certifications,_that.experiences);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? name,  String? avatarUrl,  String? jobTitle,  String? graduationYear,  String? major,  String? status,  String? github,  String? email,  List<String>? certifications,  List<ExperienceModel>? experiences)?  $default,) {final _that = this;
switch (_that) {
case _UserResponseModel() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.jobTitle,_that.graduationYear,_that.major,_that.status,_that.github,_that.email,_that.certifications,_that.experiences);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserResponseModel implements UserResponseModel {
  const _UserResponseModel({this.id, this.name, this.avatarUrl, this.jobTitle, this.graduationYear, this.major, this.status, this.github, this.email, final  List<String>? certifications, final  List<ExperienceModel>? experiences}): _certifications = certifications,_experiences = experiences;
  factory _UserResponseModel.fromJson(Map<String, dynamic> json) => _$UserResponseModelFromJson(json);

@override final  String? id;
@override final  String? name;
@override final  String? avatarUrl;
@override final  String? jobTitle;
@override final  String? graduationYear;
@override final  String? major;
@override final  String? status;
@override final  String? github;
@override final  String? email;
 final  List<String>? _certifications;
@override List<String>? get certifications {
  final value = _certifications;
  if (value == null) return null;
  if (_certifications is EqualUnmodifiableListView) return _certifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ExperienceModel>? _experiences;
@override List<ExperienceModel>? get experiences {
  final value = _experiences;
  if (value == null) return null;
  if (_experiences is EqualUnmodifiableListView) return _experiences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of UserResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserResponseModelCopyWith<_UserResponseModel> get copyWith => __$UserResponseModelCopyWithImpl<_UserResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserResponseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.graduationYear, graduationYear) || other.graduationYear == graduationYear)&&(identical(other.major, major) || other.major == major)&&(identical(other.status, status) || other.status == status)&&(identical(other.github, github) || other.github == github)&&(identical(other.email, email) || other.email == email)&&const DeepCollectionEquality().equals(other._certifications, _certifications)&&const DeepCollectionEquality().equals(other._experiences, _experiences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,jobTitle,graduationYear,major,status,github,email,const DeepCollectionEquality().hash(_certifications),const DeepCollectionEquality().hash(_experiences));

@override
String toString() {
  return 'UserResponseModel(id: $id, name: $name, avatarUrl: $avatarUrl, jobTitle: $jobTitle, graduationYear: $graduationYear, major: $major, status: $status, github: $github, email: $email, certifications: $certifications, experiences: $experiences)';
}


}

/// @nodoc
abstract mixin class _$UserResponseModelCopyWith<$Res> implements $UserResponseModelCopyWith<$Res> {
  factory _$UserResponseModelCopyWith(_UserResponseModel value, $Res Function(_UserResponseModel) _then) = __$UserResponseModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String? avatarUrl, String? jobTitle, String? graduationYear, String? major, String? status, String? github, String? email, List<String>? certifications, List<ExperienceModel>? experiences
});




}
/// @nodoc
class __$UserResponseModelCopyWithImpl<$Res>
    implements _$UserResponseModelCopyWith<$Res> {
  __$UserResponseModelCopyWithImpl(this._self, this._then);

  final _UserResponseModel _self;
  final $Res Function(_UserResponseModel) _then;

/// Create a copy of UserResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? avatarUrl = freezed,Object? jobTitle = freezed,Object? graduationYear = freezed,Object? major = freezed,Object? status = freezed,Object? github = freezed,Object? email = freezed,Object? certifications = freezed,Object? experiences = freezed,}) {
  return _then(_UserResponseModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,jobTitle: freezed == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String?,graduationYear: freezed == graduationYear ? _self.graduationYear : graduationYear // ignore: cast_nullable_to_non_nullable
as String?,major: freezed == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,github: freezed == github ? _self.github : github // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,certifications: freezed == certifications ? _self._certifications : certifications // ignore: cast_nullable_to_non_nullable
as List<String>?,experiences: freezed == experiences ? _self._experiences : experiences // ignore: cast_nullable_to_non_nullable
as List<ExperienceModel>?,
  ));
}


}


/// @nodoc
mixin _$ExperienceModel {

 String? get id; String? get year; String? get label; List<String>? get tags;
/// Create a copy of ExperienceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExperienceModelCopyWith<ExperienceModel> get copyWith => _$ExperienceModelCopyWithImpl<ExperienceModel>(this as ExperienceModel, _$identity);

  /// Serializes this ExperienceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExperienceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.year, year) || other.year == year)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,year,label,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'ExperienceModel(id: $id, year: $year, label: $label, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $ExperienceModelCopyWith<$Res>  {
  factory $ExperienceModelCopyWith(ExperienceModel value, $Res Function(ExperienceModel) _then) = _$ExperienceModelCopyWithImpl;
@useResult
$Res call({
 String? id, String? year, String? label, List<String>? tags
});




}
/// @nodoc
class _$ExperienceModelCopyWithImpl<$Res>
    implements $ExperienceModelCopyWith<$Res> {
  _$ExperienceModelCopyWithImpl(this._self, this._then);

  final ExperienceModel _self;
  final $Res Function(ExperienceModel) _then;

/// Create a copy of ExperienceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? year = freezed,Object? label = freezed,Object? tags = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExperienceModel].
extension ExperienceModelPatterns on ExperienceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExperienceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExperienceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExperienceModel value)  $default,){
final _that = this;
switch (_that) {
case _ExperienceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExperienceModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExperienceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? year,  String? label,  List<String>? tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExperienceModel() when $default != null:
return $default(_that.id,_that.year,_that.label,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? year,  String? label,  List<String>? tags)  $default,) {final _that = this;
switch (_that) {
case _ExperienceModel():
return $default(_that.id,_that.year,_that.label,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? year,  String? label,  List<String>? tags)?  $default,) {final _that = this;
switch (_that) {
case _ExperienceModel() when $default != null:
return $default(_that.id,_that.year,_that.label,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExperienceModel implements ExperienceModel {
  const _ExperienceModel({this.id, this.year, this.label, final  List<String>? tags}): _tags = tags;
  factory _ExperienceModel.fromJson(Map<String, dynamic> json) => _$ExperienceModelFromJson(json);

@override final  String? id;
@override final  String? year;
@override final  String? label;
 final  List<String>? _tags;
@override List<String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ExperienceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExperienceModelCopyWith<_ExperienceModel> get copyWith => __$ExperienceModelCopyWithImpl<_ExperienceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExperienceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExperienceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.year, year) || other.year == year)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,year,label,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'ExperienceModel(id: $id, year: $year, label: $label, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$ExperienceModelCopyWith<$Res> implements $ExperienceModelCopyWith<$Res> {
  factory _$ExperienceModelCopyWith(_ExperienceModel value, $Res Function(_ExperienceModel) _then) = __$ExperienceModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? year, String? label, List<String>? tags
});




}
/// @nodoc
class __$ExperienceModelCopyWithImpl<$Res>
    implements _$ExperienceModelCopyWith<$Res> {
  __$ExperienceModelCopyWithImpl(this._self, this._then);

  final _ExperienceModel _self;
  final $Res Function(_ExperienceModel) _then;

/// Create a copy of ExperienceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? year = freezed,Object? label = freezed,Object? tags = freezed,}) {
  return _then(_ExperienceModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
