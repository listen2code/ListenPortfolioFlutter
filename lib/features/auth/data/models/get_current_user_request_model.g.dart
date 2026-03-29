// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_current_user_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetCurrentUserRequestModel _$GetCurrentUserRequestModelFromJson(Map json) =>
    $checkedCreate('_GetCurrentUserRequestModel', json, ($checkedConvert) {
      final val = _GetCurrentUserRequestModel(
        userId: $checkedConvert('userId', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$GetCurrentUserRequestModelToJson(
  _GetCurrentUserRequestModel instance,
) => <String, dynamic>{'userId': instance.userId};
