import 'dart:async';
import 'package:listen_core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/shared.dart';
import '../../../home/presentation/pages/home_view_model.dart';
import '../../data/models/ai_chat_request_model.dart';
import '../../data/models/ai_chat_response_model.dart';
import '../../data/models/ai_preset_qa_response_model.dart';
import '../../domain/entities/chat_message.dart';
import '../provider/ai_chat_provider.dart';
import 'ai_chat_intent.dart';
import 'ai_chat_state.dart';

part 'ai_chat_view_model.g.dart';

@riverpod
class AiChatViewModel extends _$AiChatViewModel with ViewModelMixin<AiChatState, AiChatIntent> {
  static const _uuid = Uuid();

  @override
  AiChatState build() {
    return const AiChatState();
  }

  @override
  void onInit() {
    super.onInit();
    handleIntent(const AiChatIntent.init());
  }

  @override
  FutureOr<void> onIntent(AiChatIntent intent) {
    return intent.when<FutureOr<void>>(
      init: _onInit,
      sendMessage: _onSendMessage,
      changeMode: _onChangeMode,
      clearHistory: _onClearHistory,
    );
  }

  Future<void> _onInit() async {
    updateState(state.copyWith(errorMessage: null));
    await call<AiPresetQaResponseModel?>(
      ref.execute<AiPresetQaResponseModel?, String>(getPresetQaUseCaseProvider),
      onSuccess: (data) {
        if (data != null) {
          updateState(state.copyWith(allPresetQAs: data.qas, errorMessage: null));
          updatePresetQuestions();
          if (state.messages.isEmpty) {
            _addWelcomeMessage();
          }
        }
      },
      onFailure: (failure) {
        updateState(state.copyWith(errorMessage: 'Failed to load QAs: ${failure.message}'));
      },
    );
  }

  void updatePresetQuestions() {
    final currentPath = _getCurrentPath();
    final allQAs = state.allPresetQAs;
    final List<String> questions = [];

    // Load path-specific questions
    if (allQAs.containsKey(currentPath)) {
      final list = allQAs[currentPath]!;
      for (final item in list) {
        questions.add(item.question);
      }
    }

    // Load global fallback questions
    if (allQAs.containsKey('global')) {
      final list = allQAs['global']!;
      for (final item in list) {
        questions.add(item.question);
      }
    }

    updateState(state.copyWith(presetQuestions: questions.take(4).toList()));
  }

  void _addWelcomeMessage() {
    final isVisitor = state.mode == 'visitor';
    final welcomeText = isVisitor ? I18nKeys.aiChatWelcomeVisitor.tr : I18nKeys.aiChatWelcomeInterviewer.tr;

    final welcomeMsg = ChatMessage(
      id: _uuid.v4(),
      role: 'model',
      content: welcomeText,
      timestamp: DateTime.now(),
    );

    updateState(state.copyWith(messages: [welcomeMsg]));
  }

  Future<void> _onSendMessage(String text) async {
    if (text.trim().isEmpty || state.isLoading) return;

    // 1. Append user message
    final userMsg = ChatMessage(id: _uuid.v4(), role: 'user', content: text, timestamp: DateTime.now());

    updateState(state.copyWith(messages: [...state.messages, userMsg], isLoading: true));

    // 2. Check local preset QA knowledge base for matches to save token usage
    final localReply = _matchLocalPresetQA(text);
    if (localReply != null) {
      await Future<void>.delayed(const Duration(milliseconds: 600)); // Simulated typing animation
      final modelMsg = ChatMessage(
        id: _uuid.v4(),
        role: 'model',
        content: localReply,
        timestamp: DateTime.now(),
      );
      updateState(state.copyWith(messages: [...state.messages, modelMsg], isLoading: false));
      return;
    }

    // 3. Fallback to API call (targets remote datasource / LocalMockServer in developer mode)
    final request = AiChatRequestModel(
      message: text,
      history: state.messages.take(state.messages.length - 1).toList(), // Exclude the last message
      resumeContext: state.resumeContent,
      mode: state.mode,
    );

    await call<AiChatResponseModel?>(
      ref.execute<AiChatResponseModel?, AiChatRequestModel>(sendChatMessageUseCaseProvider, param: request),
      onSuccess: (response) {
        if (response != null) {
          final modelMsg = ChatMessage(
            id: _uuid.v4(),
            role: 'model',
            content: response.reply,
            timestamp: DateTime.now(),
          );
          updateState(state.copyWith(messages: [...state.messages, modelMsg], isLoading: false));
        }
      },
      onFailure: (failure) {
        final failedMsg = userMsg.copyWith(isFailed: true);
        final modelErrorMsg = ChatMessage(
          id: _uuid.v4(),
          role: 'model',
          content: '抱歉，网络连接失败：${failure.message}。您可以点击刚才的问题重试，或尝试使用预设推荐问题获取离线回答。',
          timestamp: DateTime.now(),
        );
        updateState(
          state.copyWith(
            messages:
                state.messages.map((m) => m.id == userMsg.id ? failedMsg : m).toList() + [modelErrorMsg],
            isLoading: false,
          ),
        );
      },
    );
  }

  void _onChangeMode(String newMode) {
    if (state.mode == newMode) return;
    updateState(
      state.copyWith(
        mode: newMode,
        messages: [], // Reset history for new context
      ),
    );
    _addWelcomeMessage();
  }

  void _onClearHistory() {
    updateState(state.copyWith(messages: []));
    _addWelcomeMessage();
  }

  // --- Helper Methods ---

  String _getCurrentPath() {
    final currentRoute = AppNav.currentRouteName ?? '';
    if (currentRoute == Routes.home || currentRoute == '/') {
      try {
        final homeState = ref.read(homeViewModelProvider);
        return '${Routes.home}?tab=${homeState.currentTab.name}';
      } catch (_) {
        return '${Routes.home}?tab=overview';
      }
    }
    return currentRoute;
  }

  /// Check if the query text matches any questions in portfolio_qa.json
  String? _matchLocalPresetQA(String query) {
    final allQAs = state.allPresetQAs;
    final normalizedQuery = query.trim().toLowerCase();

    // Iterate through all categories to find matching questions
    for (final list in allQAs.values) {
      for (final item in list) {
        final question = item.question.toLowerCase();
        final answer = item.answer;

        // 1. Exact match or query matches question prefix
        if (question == normalizedQuery || normalizedQuery.contains(question)) {
          return answer;
        }

        // 2. High-value keyword similarity matching to avoid token waste
        final keywords = _extractKeywords(question);
        int matchCount = 0;
        for (final keyword in keywords) {
          if (normalizedQuery.contains(keyword)) {
            matchCount++;
          }
        }
        // If query matches key concepts, return preset answer
        if (keywords.isNotEmpty && matchCount >= (keywords.length / 2).ceil()) {
          return answer;
        }
      }
    }
    return null;
  }

  List<String> _extractKeywords(String text) {
    final cleanText = text.replaceAll(RegExp(r'[？\?！!。，,、]'), '');
    final parts = cleanText.split(RegExp(r'\s+'));
    final List<String> keywords = [];

    // Simple keyword extraction for project-specific contexts
    const keyVocabs = [
      '技术栈',
      '经历',
      '年限',
      '日语',
      '作品',
      'pdf',
      '简历',
      '联系',
      'listencore',
      'listenuikit',
      '架构',
      '设置',
      '性能',
      'apm',
      '异常',
      '日志',
    ];
    for (final vocab in keyVocabs) {
      if (cleanText.contains(vocab)) {
        keywords.add(vocab);
      }
    }
    return keywords.isEmpty ? parts : keywords;
  }
}
