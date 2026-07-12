// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiChatState _$AiChatStateFromJson(
  Map json,
) => $checkedCreate('_AiChatState', json, ($checkedConvert) {
  final val = _AiChatState(
    messages: $checkedConvert(
      'messages',
      (v) =>
          (v as List<dynamic>?)
              ?.map(
                (e) =>
                    ChatMessage.fromJson(Map<String, dynamic>.from(e as Map)),
              )
              .toList() ??
          const [],
    ),
    isLoading: $checkedConvert('isLoading', (v) => v as bool? ?? false),
    mode: $checkedConvert('mode', (v) => v as String? ?? 'visitor'),
    resumeContent: $checkedConvert('resumeContent', (v) => v as String? ?? ''),
    errorMessage: $checkedConvert('errorMessage', (v) => v as String?),
    presetQuestions: $checkedConvert(
      'presetQuestions',
      (v) =>
          (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    ),
    allPresetQAs: $checkedConvert(
      'allPresetQAs',
      (v) =>
          (v as Map?)?.map(
            (k, e) => MapEntry(
              k as String,
              (e as List<dynamic>)
                  .map(
                    (e) => PresetQaItem.fromJson(
                      Map<String, dynamic>.from(e as Map),
                    ),
                  )
                  .toList(),
            ),
          ) ??
          const {},
    ),
  );
  return val;
});

Map<String, dynamic> _$AiChatStateToJson(_AiChatState instance) =>
    <String, dynamic>{
      'messages': instance.messages.map((e) => e.toJson()).toList(),
      'isLoading': instance.isLoading,
      'mode': instance.mode,
      'resumeContent': instance.resumeContent,
      'errorMessage': instance.errorMessage,
      'presetQuestions': instance.presetQuestions,
      'allPresetQAs': instance.allPresetQAs.map(
        (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
      ),
    };
