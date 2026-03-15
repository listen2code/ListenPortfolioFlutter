// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserResponseModel _$UserResponseModelFromJson(Map json) => $checkedCreate(
  '_UserResponseModel',
  json,
  ($checkedConvert) {
    final val = _UserResponseModel(
      id: $checkedConvert('id', (v) => v as String?),
      name: $checkedConvert('name', (v) => v as String?),
      avatarUrl: $checkedConvert('avatarUrl', (v) => v as String?),
      jobTitle: $checkedConvert('jobTitle', (v) => v as String?),
      graduationYear: $checkedConvert('graduationYear', (v) => v as String?),
      major: $checkedConvert('major', (v) => v as String?),
      status: $checkedConvert('status', (v) => v as String?),
      github: $checkedConvert('github', (v) => v as String?),
      email: $checkedConvert('email', (v) => v as String?),
      certifications: $checkedConvert(
        'certifications',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      experiences: $checkedConvert(
        'experiences',
        (v) => (v as List<dynamic>?)
            ?.map(
              (e) =>
                  ExperienceModel.fromJson(Map<String, Object?>.from(e as Map)),
            )
            .toList(),
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$UserResponseModelToJson(_UserResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'jobTitle': instance.jobTitle,
      'graduationYear': instance.graduationYear,
      'major': instance.major,
      'status': instance.status,
      'github': instance.github,
      'email': instance.email,
      'certifications': instance.certifications,
      'experiences': instance.experiences?.map((e) => e.toJson()).toList(),
    };

_ExperienceModel _$ExperienceModelFromJson(Map json) =>
    $checkedCreate('_ExperienceModel', json, ($checkedConvert) {
      final val = _ExperienceModel(
        id: $checkedConvert('id', (v) => v as String?),
        year: $checkedConvert('year', (v) => v as String?),
        label: $checkedConvert('label', (v) => v as String?),
        tags: $checkedConvert(
          'tags',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ExperienceModelToJson(_ExperienceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'year': instance.year,
      'label': instance.label,
      'tags': instance.tags,
    };
