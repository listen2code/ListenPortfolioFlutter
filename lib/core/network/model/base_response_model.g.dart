// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BaseResponseModel<T> _$BaseResponseModelFromJson<T>(
  Map json,
  T Function(Object? json) fromJsonT,
) => $checkedCreate('_BaseResponseModel', json, ($checkedConvert) {
  final val = _BaseResponseModel<T>(
    result: $checkedConvert('result', (v) => v as String?),
    messageId: $checkedConvert('messageId', (v) => v as String?),
    message: $checkedConvert('message', (v) => v as String?),
    body: $checkedConvert(
      'body',
      (v) => _$nullableGenericFromJson(v, fromJsonT),
    ),
  );
  return val;
});

Map<String, dynamic> _$BaseResponseModelToJson<T>(
  _BaseResponseModel<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'result': instance.result,
  'messageId': instance.messageId,
  'message': instance.message,
  'body': _$nullableGenericToJson(instance.body, toJsonT),
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);
