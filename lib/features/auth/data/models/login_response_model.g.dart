// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginResponseModel _$LoginResponseModelFromJson(Map json) =>
    $checkedCreate('_LoginResponseModel', json, ($checkedConvert) {
      final val = _LoginResponseModel(
        userId: $checkedConvert('userId', (v) => v as String?),
        token: $checkedConvert('token', (v) => v as String?),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$LoginResponseModelToJson(_LoginResponseModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };
