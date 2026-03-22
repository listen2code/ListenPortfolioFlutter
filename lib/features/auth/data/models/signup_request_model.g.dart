// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignupRequestModel _$SignupRequestModelFromJson(Map json) =>
    $checkedCreate('_SignupRequestModel', json, ($checkedConvert) {
      final val = _SignupRequestModel(
        userName: $checkedConvert('userName', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
        password: $checkedConvert('password', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$SignupRequestModelToJson(_SignupRequestModel instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'email': instance.email,
      'password': instance.password,
    };
