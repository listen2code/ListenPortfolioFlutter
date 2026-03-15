import 'package:freezed_annotation/freezed_annotation.dart';

part 'about_me_model.freezed.dart';
part 'about_me_model.g.dart';

@freezed
abstract class AboutMeModel with _$AboutMeModel {
  const factory AboutMeModel({
    String? bio,
    @Default([]) List<ExperienceItemModel> experiences,
    @Default([]) List<EducationItemModel> education,
    @Default([]) List<SkillCategoryModel> skills,
  }) = _AboutMeModel;

  factory AboutMeModel.fromJson(Map<String, Object?> json) => _$AboutMeModelFromJson(json);
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
