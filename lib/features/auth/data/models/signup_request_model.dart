import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_request_model.freezed.dart';
part 'signup_request_model.g.dart';

@freezed
abstract class SignupRequestModel with _$SignupRequestModel {
  const factory SignupRequestModel({String? name, String? email, String? password}) = _SignupRequestModel;

  factory SignupRequestModel.fromJson(Map<String, Object?> json) => _$SignupRequestModelFromJson(json);
}
