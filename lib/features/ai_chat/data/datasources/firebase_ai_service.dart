import 'package:firebase_ai/firebase_ai.dart';
import 'package:listen_core/core.dart';

import '../../domain/entities/chat_message.dart';

/// Firebase AI (Gemini) Service for interactive portfolio Q&A via direct client SDK.
class FirebaseAiService {
  GenerativeModel? _model;
  ChatSession? _chatSession;
  bool _initialized = false;
  String _currentMode = 'visitor';

  static const String _defaultSystemPrompt = '''
You are the AI Intelligent Assistant for Listen's Interactive Portfolio App (lPortfolio).
Your name is "Listen AI Assistant".
Your creator/author is Listen (a Senior Mobile & Full-Stack Architect / Lead Engineer based in Japan / Tokyo).

Context & Guidelines:
1. Candidate Profile:
   - Name: Listen
   - Location: Tokyo, Japan
   - Expertise: Flutter (Dart), Android (Kotlin/Java), iOS (Swift), Java / Spring Boot Backend, Clean Architecture, MVI/MVVM, CI/CD, APM, Performance Optimization.
   - Core Projects in Portfolio:
     * ListenCore: Cross-platform core framework for Flutter with MVI architecture, network layer, and BaseViewModel.
     * ListenUiKit: Reusable UI component library with responsive design and dynamic color tokens.
     * ListenPortfolio: This interactive portfolio application.

2. Interaction Rules:
   - Response Tone: Professional, friendly, technical, helpful, and concise.
   - Language Adaptation: Always respond in the exact language used by the user (English, Chinese, or Japanese).
   - Mode Adaptation:
     * If mode is "interviewer": Focus on Listen's technical leadership, architectural decisions, code quality, performance achievements, and engineering management experience.
     * If mode is "visitor": Focus on app features, project highlights, interactive demos, and contact info (GitHub/Email).
   - Privacy Rule: Do NOT mention any real names other than "Listen".

3. Fallback:
   - If unsure about specific personal details, politely invite the user to check the "Projects" or "About Me" tab, or contact Listen via email.
''';

  /// Initialize Firebase AI Gemini model
  void initialize({
    String modelName = 'gemini-1.5-flash',
    String? systemPrompt,
    String mode = 'visitor',
  }) {
    try {
      _currentMode = mode;
      final fullPrompt = '$systemPrompt\n[Active Mode: $mode]\n$_defaultSystemPrompt';
      _model = FirebaseAI.vertexAI().generativeModel(
        model: modelName,
        systemInstruction: Content.system(fullPrompt),
      );
      _chatSession = _model!.startChat();
      _initialized = true;
      appLogger.i('FirebaseAiService initialized successfully (model: $modelName, mode: $mode)');
    } catch (e, stack) {
      _initialized = false;
      appLogger.e('Failed to initialize FirebaseAiService: $e', error: e, stackTrace: stack);
    }
  }

  /// Whether Firebase AI service is ready for queries
  bool get isAvailable => _initialized && _model != null;

  /// Send message to Gemini model and stream response tokens with multi-turn history support
  Stream<String> sendMessageStream(
    String prompt, {
    List<ChatMessage>? history,
    String? mode,
  }) async* {
    if (!isAvailable) {
      initialize(mode: mode ?? _currentMode);
    }

    if (!isAvailable) {
      throw StateError('FirebaseAiService is not available.');
    }

    // Re-initialize chat session with history if mode changed or session expired
    if (mode != null && mode != _currentMode) {
      _currentMode = mode;
      resetChatSession(history: history);
    } else if (_chatSession == null) {
      resetChatSession(history: history);
    }

    try {
      final contentPrompt = Content.text(prompt);
      final responseStream = _chatSession != null
          ? _chatSession!.sendMessageStream(contentPrompt)
          : _model!.generateContentStream([contentPrompt]);

      await for (final response in responseStream) {
        if (response.text != null && response.text!.isNotEmpty) {
          yield response.text!;
        }
      }
    } catch (e, stack) {
      appLogger.e('FirebaseAiService.sendMessageStream error: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Reset or start a new chat session with optional multi-turn history
  void resetChatSession({List<ChatMessage>? history}) {
    if (_model != null) {
      final formattedHistory = _convertHistory(history);
      _chatSession = _model!.startChat(history: formattedHistory);
    }
  }

  /// Convert ChatMessage list into Gemini Content list for multi-turn history
  List<Content>? _convertHistory(List<ChatMessage>? history) {
    if (history == null || history.isEmpty) return null;

    final List<Content> contents = [];
    for (final msg in history) {
      if (msg.content.trim().isEmpty) continue;
      if (msg.role == 'user') {
        contents.add(Content('user', [TextPart(msg.content)]));
      } else if (msg.role == 'model') {
        contents.add(Content('model', [TextPart(msg.content)]));
      }
    }
    return contents.isEmpty ? null : contents;
  }
}

