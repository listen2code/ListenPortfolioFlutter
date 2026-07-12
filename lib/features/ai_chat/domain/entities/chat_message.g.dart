// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map json) =>
    $checkedCreate('_ChatMessage', json, ($checkedConvert) {
      final val = _ChatMessage(
        id: $checkedConvert('id', (v) => v as String),
        role: $checkedConvert('role', (v) => v as String),
        content: $checkedConvert('content', (v) => v as String),
        timestamp: $checkedConvert(
          'timestamp',
          (v) => DateTime.parse(v as String),
        ),
        isSending: $checkedConvert('isSending', (v) => v as bool? ?? false),
        isFailed: $checkedConvert('isFailed', (v) => v as bool? ?? false),
      );
      return val;
    });

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
      'isSending': instance.isSending,
      'isFailed': instance.isFailed,
    };
