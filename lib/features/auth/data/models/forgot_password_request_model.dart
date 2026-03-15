import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_request_model.freezed.dart';
part 'forgot_password_request_model.g.dart';

@freezed
abstract class ForgotPasswordRequestModel with _$ForgotPasswordRequestModel {
  const factory ForgotPasswordRequestModel({required String email}) = _ForgotPasswordRequestModel;

  factory ForgotPasswordRequestModel.fromJson(Map<String, Object?> json) =>
      _$ForgotPasswordRequestModelFromJson(json);
}
