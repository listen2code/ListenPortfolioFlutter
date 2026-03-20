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
      status: $checkedConvert('status', (v) => v as String?),
      jobTitle: $checkedConvert('jobTitle', (v) => v as String?),
      bio: $checkedConvert('bio', (v) => v as String?),
      graduationYear: $checkedConvert('graduationYear', (v) => v as String?),
      major: $checkedConvert('major', (v) => v as String?),
      github: $checkedConvert('github', (v) => v as String?),
      certifications: $checkedConvert(
        'certifications',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
      stats: $checkedConvert(
        'stats',
        (v) =>
            (v as List<dynamic>?)
                ?.map(
                  (e) => AboutMeStatModel.fromJson(
                    Map<String, Object?>.from(e as Map),
                  ),
                )
                .toList() ??
            const [],
      ),
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
      languages: $checkedConvert(
        'languages',
        (v) =>
            (v as List<dynamic>?)
                ?.map(
                  (e) => LanguageItemModel.fromJson(
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
      'status': instance.status,
      'jobTitle': instance.jobTitle,
      'bio': instance.bio,
      'graduationYear': instance.graduationYear,
      'major': instance.major,
      'github': instance.github,
      'certifications': instance.certifications,
      'stats': instance.stats.map((e) => e.toJson()).toList(),
      'experiences': instance.experiences.map((e) => e.toJson()).toList(),
      'education': instance.education.map((e) => e.toJson()).toList(),
      'skills': instance.skills.map((e) => e.toJson()).toList(),
      'languages': instance.languages.map((e) => e.toJson()).toList(),
    };

_AboutMeStatModel _$AboutMeStatModelFromJson(Map json) => $checkedCreate(
  '_AboutMeStatModel',
  json,
  ($checkedConvert) {
    final val = _AboutMeStatModel(
      id: $checkedConvert('id', (v) => v as String?),
      year: $checkedConvert('year', (v) => v as String?),
      label: $checkedConvert('label', (v) => v as String?),
      tags: $checkedConvert(
        'tags',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$AboutMeStatModelToJson(_AboutMeStatModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'year': instance.year,
      'label': instance.label,
      'tags': instance.tags,
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

_LanguageItemModel _$LanguageItemModelFromJson(Map json) =>
    $checkedCreate('_LanguageItemModel', json, ($checkedConvert) {
      final val = _LanguageItemModel(
        name: $checkedConvert('name', (v) => v as String?),
        level: $checkedConvert('level', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$LanguageItemModelToJson(_LanguageItemModel instance) =>
    <String, dynamic>{'name': instance.name, 'level': instance.level};
