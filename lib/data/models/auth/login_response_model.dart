import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

/// Response model for login API call
@freezed
class LoginResponseModel with _$LoginResponseModel {
  const factory LoginResponseModel({
    required String token,
    required String refreshToken,
    required UserModel user,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
}
