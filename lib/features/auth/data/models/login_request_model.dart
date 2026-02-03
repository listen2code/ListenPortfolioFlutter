import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_model.freezed.dart';
part 'login_request_model.g.dart';

@freezed
abstract class LoginRequestModel with _$LoginRequestModel {
  const factory LoginRequestModel({String? username, String? password}) = _LoginRequestModel;

  factory LoginRequestModel.fromJson(Map<String, Object?> json) => _$LoginRequestModelFromJson(json);
}
