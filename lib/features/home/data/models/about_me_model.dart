import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/utils/json_converters.dart';

part 'about_me_model.freezed.dart';
part 'about_me_model.g.dart';

@freezed
abstract class AboutMeModel with _$AboutMeModel {
  const factory AboutMeModel({
    String? status,
    String? jobTitle,
    String? bio,
    String? graduationYear,
    String? major,
    String? github,
    @Default([]) List<String> certifications,
    @Default([]) List<AboutMeStatModel> stats,
    @Default([]) List<ExperienceItemModel> experiences,
    @Default([]) List<EducationItemModel> education,
    @Default([]) List<SkillCategoryModel> skills,
    @Default([]) List<LanguageItemModel> languages,
  }) = _AboutMeModel;

  factory AboutMeModel.fromJson(Map<String, Object?> json) => _$AboutMeModelFromJson(json);
}

@freezed
abstract class AboutMeStatModel with _$AboutMeStatModel {
  const factory AboutMeStatModel({
    @ToStringConverter() String? id,
    String? year,
    String? label,
    @Default([]) List<String> tags,
  }) = _AboutMeStatModel;

  factory AboutMeStatModel.fromJson(Map<String, Object?> json) => _$AboutMeStatModelFromJson(json);
}

@freezed
abstract class ExperienceItemModel with _$ExperienceItemModel {
  const factory ExperienceItemModel({String? title, String? company, String? period, String? description}) =
      _ExperienceItemModel;

  factory ExperienceItemModel.fromJson(Map<String, Object?> json) => _$ExperienceItemModelFromJson(json);
}

@freezed
abstract class EducationItemModel with _$EducationItemModel {
  const factory EducationItemModel({String? degree, String? school, String? period, String? description}) =
      _EducationItemModel;

  factory EducationItemModel.fromJson(Map<String, Object?> json) => _$EducationItemModelFromJson(json);
}

@freezed
abstract class SkillCategoryModel with _$SkillCategoryModel {
  const factory SkillCategoryModel({String? category, @Default([]) List<String> items}) = _SkillCategoryModel;

  factory SkillCategoryModel.fromJson(Map<String, Object?> json) => _$SkillCategoryModelFromJson(json);
}

@freezed
abstract class LanguageItemModel with _$LanguageItemModel {
  const factory LanguageItemModel({String? name, String? level}) = _LanguageItemModel;

  factory LanguageItemModel.fromJson(Map<String, Object?> json) => _$LanguageItemModelFromJson(json);
}
