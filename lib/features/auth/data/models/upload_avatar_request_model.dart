import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_avatar_request_model.freezed.dart';
part 'upload_avatar_request_model.g.dart';

@freezed
abstract class UploadAvatarRequestModel with _$UploadAvatarRequestModel {
  const factory UploadAvatarRequestModel({
    required String avatar,
  }) = _UploadAvatarRequestModel;

  factory UploadAvatarRequestModel.fromJson(Map<String, Object?> json) =>
      _$UploadAvatarRequestModelFromJson(json);
}
