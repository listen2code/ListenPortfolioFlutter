// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginResponseModel _$LoginResponseModelFromJson(Map json) =>
    $checkedCreate('_LoginResponseModel', json, ($checkedConvert) {
      final val = _LoginResponseModel(
        token: $checkedConvert('token', (v) => v as String),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String),
        user: $checkedConvert(
          'user',
          (v) => UserModel.fromJson(Map<String, dynamic>.from(v as Map)),
        ),
      );
      return val;
    });

Map<String, dynamic> _$LoginResponseModelToJson(_LoginResponseModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'user': instance.user.toJson(),
    };
