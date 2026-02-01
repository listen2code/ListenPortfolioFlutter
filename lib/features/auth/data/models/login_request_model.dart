import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_model.freezed.dart';
part 'login_request_model.g.dart';

/// Request model for login API call
@freezed
abstract class LoginRequestModel with _$LoginRequestModel {
  const LoginRequestModel._();

  const factory LoginRequestModel({required String username, required String password}) = _LoginRequestModel;

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) => _$LoginRequestModelFromJson(json);
}
