// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_avatar_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UploadAvatarRequestModel _$UploadAvatarRequestModelFromJson(Map json) =>
    $checkedCreate('_UploadAvatarRequestModel', json, ($checkedConvert) {
      final val = _UploadAvatarRequestModel(
        avatar: $checkedConvert('avatar', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$UploadAvatarRequestModelToJson(
  _UploadAvatarRequestModel instance,
) => <String, dynamic>{'avatar': instance.avatar};
