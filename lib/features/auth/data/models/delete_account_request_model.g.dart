// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_account_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeleteAccountRequestModel _$DeleteAccountRequestModelFromJson(Map json) =>
    $checkedCreate('_DeleteAccountRequestModel', json, ($checkedConvert) {
      final val = _DeleteAccountRequestModel(
        userId: $checkedConvert('userId', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$DeleteAccountRequestModelToJson(
  _DeleteAccountRequestModel instance,
) => <String, dynamic>{'userId': instance.userId};
