import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_chat_request_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_chat_response_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_preset_qa_response_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/domain/entities/chat_message.dart';

void main() {
  group('AI Chat Models and Entities Serialization Tests', () {
    test('ChatMessage json serialization and deserialization', () {
      final now = DateTime.now();
      final message = ChatMessage(
        id: 'msg-1',
        role: 'user',
        content: 'Hello AI',
        timestamp: now,
        isSending: true,
        isFailed: false,
      );

      final json = message.toJson();
      expect(json['id'], 'msg-1');
      expect(json['role'], 'user');
      expect(json['content'], 'Hello AI');
      expect(json['isSending'], isTrue);
      expect(json['isFailed'], isFalse);

      final fromJson = ChatMessage.fromJson(json);
      expect(fromJson.id, message.id);
      expect(fromJson.role, message.role);
      expect(fromJson.content, message.content);
      expect(fromJson.isSending, message.isSending);
    });

    test('AiChatRequestModel serialization with history', () {
      final message = ChatMessage(
        id: 'msg-0',
        role: 'user',
        content: 'Context message',
        timestamp: DateTime(2026, 1, 1),
      );

      final request = AiChatRequestModel(
        message: 'Tell me about the architecture',
        history: [message],
        resumeContext: 'Lead Engineer',
        mode: 'architect',
      );

      final json = request.toJson();
      expect(json['message'], 'Tell me about the architecture');
      expect((json['history'] as List).length, 1);
      expect(json['mode'], 'architect');

      final fromJson = AiChatRequestModel.fromJson(json);
      expect(fromJson.message, request.message);
      expect(fromJson.history.first.id, 'msg-0');
      expect(fromJson.mode, 'architect');
    });

    test('AiChatResponseModel serialization and defaults', () {
      final response = const AiChatResponseModel(
        reply: 'Response reply',
      );

      final json = response.toJson();
      expect(json['reply'], 'Response reply');

      final fromJson = AiChatResponseModel.fromJson(json);
      expect(fromJson.reply, 'Response reply');
    });

    test('AiPresetQaResponseModel serialization and multi-route mapping', () {
      final model = AiPresetQaResponseModel(
        qas: {
          'global': [
            const PresetQaItem(question: 'Q1', answer: 'A1'),
          ],
          '/home': [
            const PresetQaItem(question: 'Q2', answer: 'A2'),
          ],
        },
      );

      final json = model.toJson();
      expect(json['qas'], isNotNull);
      expect((json['qas'] as Map).containsKey('global'), isTrue);
      expect((json['qas'] as Map).containsKey('/home'), isTrue);

      final fromJson = AiPresetQaResponseModel.fromJson(json);
      expect(fromJson.qas['global']?.first.question, 'Q1');
      expect(fromJson.qas['/home']?.first.answer, 'A2');
    });
  });
}
