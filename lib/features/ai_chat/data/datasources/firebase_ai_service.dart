import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:listen_core/core.dart';

import '../../domain/entities/chat_message.dart';

/// Firebase AI (Vertex AI Gemini) Service for interactive portfolio Q&A.
class FirebaseAiService {
  GenerativeModel? _model;
  ChatSession? _chatSession;
  bool _initialized = false;

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

  /// Initialize Firebase Vertex AI Gemini model
  void initialize({String modelName = 'gemini-1.5-flash', String? systemPrompt}) {
    try {
      _model = FirebaseVertexAI.instance.generativeModel(
        model: modelName,
        systemInstruction: Content.system(systemPrompt ?? _defaultSystemPrompt),
      );
      _chatSession = _model!.startChat();
      _initialized = true;
      appLogger.i('FirebaseAiService initialized successfully with model: $modelName');
    } catch (e, stack) {
      _initialized = false;
      appLogger.e('Failed to initialize FirebaseAiService: $e', error: e, stackTrace: stack);
    }
  }

  /// Whether Firebase AI service is ready for queries
  bool get isAvailable => _initialized && _model != null;

  /// Send message to Gemini model and stream response tokens
  Stream<String> sendMessageStream(String prompt, {List<ChatMessage>? history, String? mode}) async* {
    if (!isAvailable) {
      initialize();
    }

    if (!isAvailable) {
      throw StateError('FirebaseAiService is not available.');
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

  /// Reset or start a new chat session (e.g., when switching interviewer/visitor mode)
  void resetChatSession() {
    if (_model != null) {
      _chatSession = _model!.startChat();
    }
  }
}
