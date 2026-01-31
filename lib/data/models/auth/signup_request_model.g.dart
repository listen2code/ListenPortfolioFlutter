// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignupRequestModelImpl _$$SignupRequestModelImplFromJson(Map json) =>
    $checkedCreate(r'_$SignupRequestModelImpl', json, ($checkedConvert) {
      final val = _$SignupRequestModelImpl(
        name: $checkedConvert('name', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
        password: $checkedConvert('password', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$$SignupRequestModelImplToJson(
  _$SignupRequestModelImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'password': instance.password,
};
