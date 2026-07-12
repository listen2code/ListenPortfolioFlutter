// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiChatRequestModel _$AiChatRequestModelFromJson(Map json) =>
    $checkedCreate('_AiChatRequestModel', json, ($checkedConvert) {
      final val = _AiChatRequestModel(
        message: $checkedConvert('message', (v) => v as String),
        history: $checkedConvert(
          'history',
          (v) => (v as List<dynamic>)
              .map(
                (e) =>
                    ChatMessage.fromJson(Map<String, dynamic>.from(e as Map)),
              )
              .toList(),
        ),
        resumeContext: $checkedConvert('resumeContext', (v) => v as String),
        mode: $checkedConvert('mode', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AiChatRequestModelToJson(_AiChatRequestModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'history': instance.history.map((e) => e.toJson()).toList(),
      'resumeContext': instance.resumeContext,
      'mode': instance.mode,
    };
