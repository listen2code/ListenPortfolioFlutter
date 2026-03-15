// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_me_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AboutMeModel _$AboutMeModelFromJson(Map json) => $checkedCreate(
  '_AboutMeModel',
  json,
  ($checkedConvert) {
    final val = _AboutMeModel(
      bio: $checkedConvert('bio', (v) => v as String?),
      experiences: $checkedConvert(
        'experiences',
        (v) =>
            (v as List<dynamic>?)
                ?.map(
                  (e) => ExperienceItemModel.fromJson(
                    Map<String, Object?>.from(e as Map),
                  ),
                )
                .toList() ??
            const [],
      ),
      education: $checkedConvert(
        'education',
        (v) =>
            (v as List<dynamic>?)
                ?.map(
                  (e) => EducationItemModel.fromJson(
                    Map<String, Object?>.from(e as Map),
                  ),
                )
                .toList() ??
            const [],
      ),
      skills: $checkedConvert(
        'skills',
        (v) =>
            (v as List<dynamic>?)
                ?.map(
                  (e) => SkillCategoryModel.fromJson(
                    Map<String, Object?>.from(e as Map),
                  ),
                )
                .toList() ??
            const [],
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$AboutMeModelToJson(_AboutMeModel instance) =>
    <String, dynamic>{
      'bio': instance.bio,
      'experiences': instance.experiences.map((e) => e.toJson()).toList(),
      'education': instance.education.map((e) => e.toJson()).toList(),
      'skills': instance.skills.map((e) => e.toJson()).toList(),
    };

_ExperienceItemModel _$ExperienceItemModelFromJson(Map json) =>
    $checkedCreate('_ExperienceItemModel', json, ($checkedConvert) {
      final val = _ExperienceItemModel(
        title: $checkedConvert('title', (v) => v as String?),
        company: $checkedConvert('company', (v) => v as String?),
        period: $checkedConvert('period', (v) => v as String?),
        description: $checkedConvert('description', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ExperienceItemModelToJson(
  _ExperienceItemModel instance,
) => <String, dynamic>{
  'title': instance.title,
  'company': instance.company,
  'period': instance.period,
  'description': instance.description,
};

_EducationItemModel _$EducationItemModelFromJson(Map json) =>
    $checkedCreate('_EducationItemModel', json, ($checkedConvert) {
      final val = _EducationItemModel(
        degree: $checkedConvert('degree', (v) => v as String?),
        school: $checkedConvert('school', (v) => v as String?),
        period: $checkedConvert('period', (v) => v as String?),
        description: $checkedConvert('description', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$EducationItemModelToJson(_EducationItemModel instance) =>
    <String, dynamic>{
      'degree': instance.degree,
      'school': instance.school,
      'period': instance.period,
      'description': instance.description,
    };

_SkillCategoryModel _$SkillCategoryModelFromJson(Map json) => $checkedCreate(
  '_SkillCategoryModel',
  json,
  ($checkedConvert) {
    final val = _SkillCategoryModel(
      category: $checkedConvert('category', (v) => v as String?),
      items: $checkedConvert(
        'items',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$SkillCategoryModelToJson(_SkillCategoryModel instance) =>
    <String, dynamic>{'category': instance.category, 'items': instance.items};
