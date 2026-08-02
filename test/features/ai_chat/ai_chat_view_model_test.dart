import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:mocktail/mocktail.dart';

import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_chat_request_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_chat_response_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_preset_qa_response_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/domain/entities/chat_message.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/domain/usecases/send_chat_message_use_case.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/domain/usecases/get_preset_qa_use_case.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/provider/ai_chat_provider.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/pages/ai_chat_intent.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/pages/ai_chat_view_model.dart';

class MockSendChatMessageUseCase extends Mock implements SendChatMessageUseCase {}
class MockGetPresetQaUseCase extends Mock implements GetPresetQaUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Register fallback values for mocktail parameter matching
  setUpAll(() {
    registerFallbackValue(const AiChatRequestModel(message: '', history: [], resumeContext: '', mode: ''));
    registerFallbackValue(const BaseParam());
  });

  group('AiChatViewModel Clean Architecture Tests', () {
    late ProviderContainer container;
    late AiChatViewModel viewModel;
    late MockSendChatMessageUseCase mockSendChatMessageUseCase;
    late MockGetPresetQaUseCase mockGetPresetQaUseCase;

    final mockPresetQas = AiPresetQaResponseModel(
      qas: {
        'global': [
          const PresetQaItem(
            question: '这个项目主要使用了哪些技术栈？',
            answer: '本项目全栈技术方案：Riverpod 3',
          ),
        ],
        '/home?tab=overview': [
          const PresetQaItem(
            question: '这个 Overview 页面展示的核心定位是什么？',
            answer: '总览（Overview）',
          ),
        ],
      },
    );

    setUp(() {
      mockSendChatMessageUseCase = MockSendChatMessageUseCase();
      mockGetPresetQaUseCase = MockGetPresetQaUseCase();

      // Configure default success for getPresetQAs
      when(() => mockGetPresetQaUseCase.call(param: any(named: 'param')))
          .thenAnswer((_) async => Right(mockPresetQas));

      container = ProviderContainer(
        overrides: [
          sendChatMessageUseCaseProvider.overrideWith((ref) => mockSendChatMessageUseCase),
          getPresetQaUseCaseProvider.overrideWith((ref) => mockGetPresetQaUseCase),
        ],
      );

      viewModel = container.read(aiChatViewModelProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('Should initialize correctly, load preset QAs, and add welcome message', () async {
      final sub = container.listen(aiChatViewModelProvider, (_, __) {});
      
      // Manually trigger lifecycle method since page skeleton isn't built in test
      viewModel.onInit();

      // Given & When - wait for async initialization
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final state = container.read(aiChatViewModelProvider);
      
      // Then
      expect(state.allPresetQAs, isNotEmpty);
      expect(state.messages, hasLength(1));
      expect(state.messages.first.role, 'model');
      expect(state.messages.first.content, contains('Listen')); // English default
      expect(state.presetQuestions, isNotEmpty);

      sub.close();
    });

    test('Should change mode and reload welcome message', () async {
      final sub = container.listen(aiChatViewModelProvider, (_, __) {});
      viewModel.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // When - Switch to interviewer mode
      await viewModel.handleIntent(const AiChatIntent.changeMode('interviewer'));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final state = container.read(aiChatViewModelProvider);
      expect(state.mode, 'interviewer');
      expect(state.messages, hasLength(1));
      expect(state.messages.first.content, contains('interview')); // English default contains 'interview'

      sub.close();
    });

    test('Should reply offline with preset answer for keyword matching queries', () async {
      final sub = container.listen(aiChatViewModelProvider, (_, __) {});
      viewModel.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // When - Send a question matching preset "技术栈"
      await viewModel.handleIntent(const AiChatIntent.sendMessage('这个项目使用的是什么技术栈？'));

      // Wait for simulated offline delay
      await Future<void>.delayed(const Duration(milliseconds: 700));

      final state = container.read(aiChatViewModelProvider);
      expect(state.messages, hasLength(3)); // Initial Welcome, User, Model response
      expect(state.messages[1].role, 'user');
      expect(state.messages[2].role, 'model');
      expect(state.messages[2].content, contains('Riverpod 3')); // Local preset answer from mock JSON

      sub.close();
    });

    test('Should fallback to SendChatMessageUseCase for unmatched custom queries', () async {
      final sub = container.listen(aiChatViewModelProvider, (_, __) {});
      viewModel.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Given - Mock usecase response
      const customQuery = '你觉得 Listen 写的代码怎么样？';
      const mockReply = 'Listen 的编码规范非常高，完美贴合 Clean Architecture 和 MVI 架构。';
      when(() => mockSendChatMessageUseCase.call(param: any(named: 'param')))
          .thenAnswer((_) async => const Right(AiChatResponseModel(reply: mockReply)));

      // When - Send custom question
      await viewModel.handleIntent(const AiChatIntent.sendMessage(customQuery));
      
      // Allow async future inside viewModel to resolve
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final state = container.read(aiChatViewModelProvider);
      expect(state.messages, hasLength(3));
      expect(state.messages[2].content, mockReply);

      sub.close();
    });
  });
}
