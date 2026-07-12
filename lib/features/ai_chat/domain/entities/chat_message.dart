import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String role, // "user" or "model"
    required String content,
    required DateTime timestamp,
    @Default(false) bool isSending,
    @Default(false) bool isFailed,
  }) = _ChatMessage;

  const ChatMessage._();

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}
