import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

@freezed
abstract class LoginResponseModel with _$LoginResponseModel {
  const factory LoginResponseModel({String? userId, String? token, String? refreshToken}) =
      _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, Object?> json) => _$LoginResponseModelFromJson(json);
}
