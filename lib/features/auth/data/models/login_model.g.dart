// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginModel _$LoginModelFromJson(Map json) =>
    $checkedCreate('_LoginModel', json, ($checkedConvert) {
      final val = _LoginModel(
        userId: $checkedConvert('userId', (v) => v as String?),
        token: $checkedConvert('token', (v) => v as String?),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$LoginModelToJson(_LoginModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };
