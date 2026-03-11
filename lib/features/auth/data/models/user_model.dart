import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    String? id,
    String? name,
    String? avatarUrl,
    String? jobTitle,
    String? graduationYear,
    String? major,
    String? status,
    String? github,
    String? email,
    List<String>? certifications,
    List<ExperienceModel>? experiences,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) => _$UserModelFromJson(json);
}

@freezed
abstract class ExperienceModel with _$ExperienceModel {
  const factory ExperienceModel({String? id, String? year, String? label, List<String>? tags}) =
      _ExperienceModel;

  factory ExperienceModel.fromJson(Map<String, Object?> json) => _$ExperienceModelFromJson(json);
}
