import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_model.freezed.dart';
part 'login_model.g.dart';

@freezed
abstract class LoginModel with _$LoginModel {
  const factory LoginModel({String? userId, String? token, String? refreshToken}) = _LoginModel;

  factory LoginModel.fromJson(Map<String, Object?> json) => _$LoginModelFromJson(json);
}
