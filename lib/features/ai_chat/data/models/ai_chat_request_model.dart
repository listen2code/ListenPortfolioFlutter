import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/chat_message.dart';

part 'ai_chat_request_model.freezed.dart';
part 'ai_chat_request_model.g.dart';

@freezed
abstract class AiChatRequestModel with _$AiChatRequestModel {
  const factory AiChatRequestModel({
    required String message,
    required List<ChatMessage> history,
    required String resumeContext,
    required String mode,
  }) = _AiChatRequestModel;

  factory AiChatRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AiChatRequestModelFromJson(json);
}
