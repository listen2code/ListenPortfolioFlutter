// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseModelImpl _$$LoginResponseModelImplFromJson(Map json) =>
    $checkedCreate(r'_$LoginResponseModelImpl', json, ($checkedConvert) {
      final val = _$LoginResponseModelImpl(
        token: $checkedConvert('token', (v) => v as String),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String),
        user: $checkedConvert(
          'user',
          (v) => UserModel.fromJson(Map<String, dynamic>.from(v as Map)),
        ),
      );
      return val;
    });

Map<String, dynamic> _$$LoginResponseModelImplToJson(
  _$LoginResponseModelImpl instance,
) => <String, dynamic>{
  'token': instance.token,
  'refreshToken': instance.refreshToken,
  'user': instance.user.toJson(),
};
