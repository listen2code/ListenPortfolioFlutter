// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map json) =>
    $checkedCreate('_UserModel', json, ($checkedConvert) {
      final val = _UserModel(
        id: $checkedConvert('id', (v) => const ToStringConverter().fromJson(v)),
        name: $checkedConvert('name', (v) => v as String?),
        location: $checkedConvert('location', (v) => v as String?),
        email: $checkedConvert('email', (v) => v as String?),
        avatarUrl: $checkedConvert('avatarUrl', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': const ToStringConverter().toJson(instance.id),
      'name': instance.name,
      'location': instance.location,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
    };
