import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/shared.dart';
import '../../../home/presentation/pages/home_view_model.dart';
import '../../data/models/ai_preset_qa_response_model.dart';
import '../../domain/entities/chat_message.dart';
import '../provider/ai_chat_provider.dart';
import 'ai_chat_intent.dart';
import 'ai_chat_state.dart';

part 'ai_chat_view_model.g.dart';

/// ============================================================================
/// AiChatViewModel
/// ============================================================================
/// The core MVI ViewModel orchestrating the interactive AI Assistant conversation.
///
/// ### Architecture & Key Responsibilities:
/// 1. **MVI Architecture with ViewModelMixin**:
///    Encapsulates immutable [AiChatState] transformations driven strictly by
///    incoming [AiChatIntent] events (`init`, `sendMessage`, `clearHistory`).
///
/// 2. **Two-Tier Hybrid Intelligence Architecture**:
///    - **Tier 1 (Local 0-Token Interceptor)**: Intercepts frequent, known architectural
///      and candidate questions using an in-memory fuzzy keyword matcher ([_matchLocalPresetQA]).
///      Provides instantaneous answers with zero network latency and zero LLM token costs.
///    - **Tier 2 (Cloud Gemini 3.7 Flash Stream)**: Directly queries Google Gemini via
///      [FirebaseAiService] using reactive token-by-token streaming, rendering dynamic
///      markdown responses in real time.
///
/// 3. **Contextual Route & Tab Awareness**:
///    Continuously inspects the host navigation state ([_getCurrentPath]), automatically
///    re-indexing recommended questions when the user navigates between Overview,
///    AboutMe, Projects, and Architecture tabs.
///
/// 4. **Graceful Stream Lifecycle & Error Isolation**:
///    Allocates a temporary placeholder message ID, incrementally updates partial text
///    chunks without triggering UI rebuild storms, and isolates network failures into
///    user-friendly error bubbles with retry markers.
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
    // Dispatch initial intent upon ViewModel creation
    handleIntent(const AiChatIntent.init());
  }

  @override
  FutureOr<void> onIntent(AiChatIntent intent) {
    return intent.when<FutureOr<void>>(
      init: _onInit,
      sendMessage: _onSendMessage,
      clearHistory: _onClearHistory,
    );
  }

  /// Handles [AiChatIntent.init] by fetching preset QA knowledge from the repository
  /// and initializing the conversation with an adaptive welcome message.
  Future<void> _onInit() async {
    updateState(state.copyWith(errorMessage: null));

    // Call UseCase via base ViewModel runner with automatic Either fold handling
    await call<AiPresetQaResponseModel?>(
      ref.execute<AiPresetQaResponseModel?, String>(getPresetQaUseCaseProvider),
      onSuccess: (data) {
        if (data != null) {
          // Store dictionary of route -> List<PresetQaItem>
          updateState(state.copyWith(allPresetQAs: data.qas, errorMessage: null));
          // Refresh question chips tailored to the current screen route/tab
          updatePresetQuestions();
          // Seed the initial welcome bubble if this is a fresh conversation
          if (state.messages.isEmpty) {
            _addWelcomeMessage();
          }
        }
      },
      onFailure: (failure) {
        updateState(state.copyWith(errorMessage: I18nKeys.aiChatLoadFailed.trArgs([failure.message])));
      },
    );
  }

  /// Refreshes the recommended question chips according to the user's active page and tab.
  ///
  /// Combines path-specific questions (e.g. `/home?tab=resume`) with global fallback questions,
  /// capping the display at the top 4 items to prevent horizontal clutter.
  void updatePresetQuestions() {
    final currentPath = _getCurrentPath();
    final allQAs = state.allPresetQAs;
    final List<String> questions = [];

    // 1. Load path-specific questions matching current active route/tab
    if (allQAs.containsKey(currentPath)) {
      final list = allQAs[currentPath]!;
      for (final item in list) {
        questions.add(item.question);
      }
    }

    // 2. Load global fallback questions applicable across all pages
    if (allQAs.containsKey('global')) {
      final list = allQAs['global']!;
      for (final item in list) {
        questions.add(item.question);
      }
    }

    // Limit to top 4 chips for visual balance in UI
    updateState(state.copyWith(presetQuestions: questions.take(4).toList()));
  }

  /// Appends the localized welcome message from the AI Assistant persona.
  void _addWelcomeMessage() {
    final welcomeText = I18nKeys.aiChatWelcomeVisitor.tr;

    final welcomeMsg = ChatMessage(
      id: _uuid.v4(),
      role: 'model',
      content: welcomeText,
      timestamp: DateTime.now(),
    );

    updateState(state.copyWith(messages: [welcomeMsg]));
  }

  /// Handles sending a message via the Two-Tier Hybrid Answering Pipeline.
  ///
  /// ### Pipeline Execution Flow:
  /// 1. Validation & User Message Appending.
  /// 2. Tier 1 Intercept: Checks local preset QA cache. If matched, returns immediately.
  /// 3. Tier 2 Fallback: Connects to Firebase Gemini AI SDK stream.
  /// 4. Reactive Chunk Buffering: Incrementally maps chunks into an in-progress placeholder message.
  /// 5. Error Containment: Flags message failures without corrupting the chat state.
  Future<void> _onSendMessage(String text) async {
    if (text.trim().isEmpty || state.isLoading) return;

    // 1. Append user message to immutable state
    final userMsg = ChatMessage(id: _uuid.v4(), role: 'user', content: text, timestamp: DateTime.now());
    updateState(state.copyWith(messages: [...state.messages, userMsg], isLoading: true));

    // 2. Tier 1 Interception: Match against local pre-cached Q&A dictionary (0 Token / 0 Latency)
    final localReply = _matchLocalPresetQA(text);
    if (localReply != null) {
      // Simulate natural typing delay (500ms) for smoother UX
      await Future<void>.delayed(const Duration(milliseconds: 500));
      final modelMsg = ChatMessage(
        id: _uuid.v4(),
        role: 'model',
        content: localReply,
        timestamp: DateTime.now(),
      );
      updateState(state.copyWith(messages: [...state.messages, modelMsg], isLoading: false));
      return;
    }

    // 3. Tier 2 Fallback: Client-Direct Firebase AI SDK Execution
    final firebaseAi = ref.read(firebaseAiServiceProvider);
    if (!firebaseAi.isAvailable) {
      firebaseAi.initialize();
    }

    final modelMsgId = _uuid.v4();
    var modelMsg = ChatMessage(id: modelMsgId, role: 'model', content: '', timestamp: DateTime.now());

    // Insert an initial empty placeholder message for real-time stream accumulation
    updateState(state.copyWith(messages: [...state.messages, modelMsg], isLoading: true));

    try {
      // Stream tokens directly from Gemini with multi-turn conversation history
      final stream = firebaseAi.sendMessageStream(text, history: state.messages);
      var fullText = '';
      await for (final chunk in stream) {
        fullText += chunk;
        modelMsg = modelMsg.copyWith(content: fullText);
        updateState(
          state.copyWith(messages: state.messages.map((m) => m.id == modelMsgId ? modelMsg : m).toList()),
        );
      }

      updateState(state.copyWith(isLoading: false));
    } catch (e, stack) {
      appLogger.e('Firebase AI direct SDK stream error: $e', error: e, stackTrace: stack);

      // In case of network or API error, mark the user message as failed and present a friendly error bubble
      final failedMsg = userMsg.copyWith(isFailed: true);
      final modelErrorMsg = ChatMessage(
        id: _uuid.v4(),
        role: 'model',
        content: I18nKeys.aiChatServiceUnavailable.tr,
        timestamp: DateTime.now(),
      );

      updateState(
        state.copyWith(
          messages:
              state.messages
                  .where((m) => m.id != modelMsgId && m.content.isNotEmpty)
                  .map((m) => m.id == userMsg.id ? failedMsg : m)
                  .toList() +
              [modelErrorMsg],
          isLoading: false,
        ),
      );
    }
  }

  /// Clears active chat history and resets the conversation to the welcome state.
  void _onClearHistory() {
    updateState(state.copyWith(messages: []));
    _addWelcomeMessage();
  }

  // --- Context Detection & Local Q&A Matching Helpers ---

  /// Determines the normalized current route path including active sub-tabs.
  ///
  /// For instance, if the user is on the Home page viewing the Resume tab,
  /// this returns `'/home?tab=resume'`.
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

  /// Checks if the query text matches any questions in the local preset QA database.
  ///
  /// Uses a two-stage evaluation strategy:
  /// - **Stage 1 (Exact / Substring containment)**: Direct phrase match.
  /// - **Stage 2 (Keyword Density Intersection)**: Extracts domain-specific keywords
  ///   and triggers a match if at least 50% of the keywords are present in the query.
  String? _matchLocalPresetQA(String query) {
    final allQAs = state.allPresetQAs;
    final normalizedQuery = query.trim().toLowerCase();

    // Iterate through all route categories to find matching questions
    for (final list in allQAs.values) {
      for (final item in list) {
        final question = item.question.toLowerCase();
        final answer = item.answer;

        // 1. Exact match or query contains full question
        if (question == normalizedQuery || normalizedQuery.contains(question)) {
          return answer;
        }

        // 2. High-value keyword density matching to save tokens
        final keywords = _extractKeywords(question);
        int matchCount = 0;
        for (final keyword in keywords) {
          if (normalizedQuery.contains(keyword)) {
            matchCount++;
          }
        }

        // If query satisfies >= 50% keyword density, return preset answer
        if (keywords.isNotEmpty && matchCount >= (keywords.length / 2).ceil()) {
          return answer;
        }
      }
    }
    return null;
  }

  /// Extracts domain-specific keywords from a given question string.
  ///
  /// Strips punctuation, splits on whitespace, and filters by recognized
  /// technical and biographical vocabulary.
  List<String> _extractKeywords(String text) {
    final cleanText = text.replaceAll(RegExp(r'[？?！!。，,、]'), '');
    final parts = cleanText.split(RegExp(r'\s+'));
    final List<String> keywords = [];

    // Curated high-value vocabulary for candidate & portfolio domain
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

