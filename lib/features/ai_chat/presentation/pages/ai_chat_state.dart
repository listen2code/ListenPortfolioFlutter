import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../data/models/ai_preset_qa_response_model.dart';
import '../../domain/entities/chat_message.dart';

part 'ai_chat_state.freezed.dart';
part 'ai_chat_state.g.dart';

@freezed
abstract class AiChatState extends BaseState with _$AiChatState {
  const factory AiChatState({
    @Default([]) List<ChatMessage> messages,
    @Default(false) bool isLoading,
    @Default('visitor') String mode, // "visitor" or "interviewer"
    @Default('') String resumeContent,
    String? errorMessage,
    @Default([]) List<String> presetQuestions,
    @Default({}) Map<String, List<PresetQaItem>> allPresetQAs,
  }) = _AiChatState;

  const AiChatState._();

  factory AiChatState.fromJson(Map<String, dynamic> json) => _$AiChatStateFromJson(json);
}
