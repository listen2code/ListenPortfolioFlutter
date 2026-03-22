// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginModel _$LoginModelFromJson(Map json) =>
    $checkedCreate('_LoginModel', json, ($checkedConvert) {
      final val = _LoginModel(
        userId: $checkedConvert(
          'userId',
          (v) => const ToStringConverter().fromJson(v),
        ),
        token: $checkedConvert('token', (v) => v as String?),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$LoginModelToJson(_LoginModel instance) =>
    <String, dynamic>{
      'userId': const ToStringConverter().toJson(instance.userId),
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };
