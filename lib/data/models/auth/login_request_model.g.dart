// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestModelImpl _$$LoginRequestModelImplFromJson(Map json) =>
    $checkedCreate(r'_$LoginRequestModelImpl', json, ($checkedConvert) {
      final val = _$LoginRequestModelImpl(
        username: $checkedConvert('username', (v) => v as String),
        password: $checkedConvert('password', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$$LoginRequestModelImplToJson(
  _$LoginRequestModelImpl instance,
) => <String, dynamic>{
  'username': instance.username,
  'password': instance.password,
};
