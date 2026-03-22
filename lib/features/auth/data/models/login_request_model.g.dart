// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginRequestModel _$LoginRequestModelFromJson(Map json) =>
    $checkedCreate('_LoginRequestModel', json, ($checkedConvert) {
      final val = _LoginRequestModel(
        userName: $checkedConvert('userName', (v) => v as String),
        password: $checkedConvert('password', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$LoginRequestModelToJson(_LoginRequestModel instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'password': instance.password,
    };
