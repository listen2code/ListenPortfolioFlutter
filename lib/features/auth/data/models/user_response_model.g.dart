// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserResponseModel _$UserResponseModelFromJson(Map json) =>
    $checkedCreate('_UserResponseModel', json, ($checkedConvert) {
      final val = _UserResponseModel(
        id: $checkedConvert('id', (v) => v as String?),
        name: $checkedConvert('name', (v) => v as String?),
        location: $checkedConvert('location', (v) => v as String?),
        email: $checkedConvert('email', (v) => v as String?),
        avatarUrl: $checkedConvert('avatarUrl', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$UserResponseModelToJson(_UserResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
    };
