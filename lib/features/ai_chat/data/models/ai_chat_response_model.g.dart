// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiChatResponseModel _$AiChatResponseModelFromJson(Map json) =>
    $checkedCreate('_AiChatResponseModel', json, ($checkedConvert) {
      final val = _AiChatResponseModel(
        reply: $checkedConvert('reply', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AiChatResponseModelToJson(
  _AiChatResponseModel instance,
) => <String, dynamic>{'reply': instance.reply};
