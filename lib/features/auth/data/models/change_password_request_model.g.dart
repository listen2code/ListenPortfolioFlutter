// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChangePasswordRequestModel _$ChangePasswordRequestModelFromJson(Map json) =>
    $checkedCreate('_ChangePasswordRequestModel', json, ($checkedConvert) {
      final val = _ChangePasswordRequestModel(
        userId: $checkedConvert('userId', (v) => v as String),
        oldPassword: $checkedConvert('oldPassword', (v) => v as String),
        newPassword: $checkedConvert('newPassword', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ChangePasswordRequestModelToJson(
  _ChangePasswordRequestModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'oldPassword': instance.oldPassword,
  'newPassword': instance.newPassword,
};
