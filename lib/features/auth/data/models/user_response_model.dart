import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_response_model.freezed.dart';
part 'user_response_model.g.dart';

@freezed
abstract class UserResponseModel with _$UserResponseModel {
  const factory UserResponseModel({
    String? id,
    String? name,
    String? location,
    String? email,
    String? avatarUrl,
  }) = _UserResponseModel;

  factory UserResponseModel.fromJson(Map<String, Object?> json) => _$UserResponseModelFromJson(json);
}
