// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ForgotPasswordRequestModel _$ForgotPasswordRequestModelFromJson(Map json) =>
    $checkedCreate('_ForgotPasswordRequestModel', json, ($checkedConvert) {
      final val = _ForgotPasswordRequestModel(
        email: $checkedConvert('email', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ForgotPasswordRequestModelToJson(
  _ForgotPasswordRequestModel instance,
) => <String, dynamic>{'email': instance.email};
