import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_response_model.freezed.dart';
part 'user_response_model.g.dart';

@freezed
abstract class UserResponseModel with _$UserResponseModel {
  const factory UserResponseModel({
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
  }) = _UserResponseModel;

  factory UserResponseModel.fromJson(Map<String, Object?> json) => _$UserResponseModelFromJson(json);
}

@freezed
abstract class ExperienceModel with _$ExperienceModel {
  const factory ExperienceModel({String? id, String? year, String? label, List<String>? tags}) =
      _ExperienceModel;

  factory ExperienceModel.fromJson(Map<String, Object?> json) => _$ExperienceModelFromJson(json);
}
