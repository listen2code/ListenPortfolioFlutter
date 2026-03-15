import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_current_user_request_model.freezed.dart';
part 'get_current_user_request_model.g.dart';

@freezed
abstract class GetCurrentUserRequestModel with _$GetCurrentUserRequestModel {
  const factory GetCurrentUserRequestModel({required String userId}) = _GetCurrentUserRequestModel;

  factory GetCurrentUserRequestModel.fromJson(Map<String, Object?> json) =>
      _$GetCurrentUserRequestModelFromJson(json);
}
