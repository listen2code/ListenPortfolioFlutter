import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:listen_core/core.dart';

import '../../../features/ai_chat/domain/entities/chat_message.dart';

/// ============================================================================
/// FirebaseAiService
/// ============================================================================
/// Direct client-side driver integrating the official Firebase AI SDK
/// (`firebase_ai`) powered by Google's Gemini LLM (`gemini-3.7-flash`).
///
/// ### Architecture & Design Decisions:
/// 1. **Client-Direct Architecture (Zero Proxy Overhead)**:
///    Instead of funneling prompt requests through a custom Spring Boot backend
///    proxy (which introduces extra hops, serialization overhead, and server hosting costs),
///    the mobile client communicates directly with Google's Gemini API endpoints.
///
/// 2. **Hardware & App Attestation Security (Firebase App Check)**:
///    To eliminate the risk of reverse-engineered API keys and unauthorized token abuse,
///    every outbound call is validated against Firebase App Check (enforcing Play Integrity
///    on Android, DeviceCheck / App Attest on iOS, and Debug Tokens in local dev).
///
/// 3. **Streaming First-Token Latency Optimization**:
///    Utilizes `sendMessageStream` to stream partial token chunks in real-time.
///    This drops Time-To-First-Token (TTFT) from multi-second full-response delays
///    down to sub-second perceived responsiveness.
///
/// 4. **Multi-Turn Conversational Context**:
///    Maintains a persistent [ChatSession] with historical message conversion
///    between domain entity [ChatMessage] and SDK-level [Content] instances.
class FirebaseAiService {
  /// The underlying Google Generative AI model instance.
  GenerativeModel? _model;

  /// Active chat session maintaining conversational state and context history.
  ChatSession? _chatSession;

  /// Internal flag indicating whether the SDK model has been successfully initialized.
  bool _initialized = false;

  /// The foundational system prompt grounding the AI's persona, knowledge scope,
  /// candidate profile, tone, language adaptation, and boundary constraints.
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
   - Knowledge Depth: You can explain architecture decisions, system design, performance metrics, app features, project highlights, and contact info.
   - Privacy Rule: Do NOT mention any real names other than "Listen".

3. Fallback:
   - If unsure about specific personal details, politely invite the user to check the "Projects", "Architecture", or "About Me" tab, or contact Listen via email.
''';

  /// Initializes the Gemini generative model with App Check security and system instructions.
  ///
  /// - [modelName]: The target Gemini model name (defaults to `gemini-3.7-flash` for high throughput).
  /// - [systemPrompt]: Optional dynamic contextual instructions prepended to [_defaultSystemPrompt].
  void initialize({
    String modelName = 'gemini-3.7-flash',
    String? systemPrompt,
  }) {
    appLogger.i('[FirebaseAiService] Initializing Gemini SDK: model=$modelName, releaseMode=$kReleaseMode');
    try {
      // Merge caller-provided contextual instructions with the master system prompt
      final fullPrompt = systemPrompt != null
          ? '$systemPrompt\n$_defaultSystemPrompt'
          : _defaultSystemPrompt;

      // Extract current FirebaseAppCheck instance for hardware attestation
      final appCheck = FirebaseAppCheck.instance;

      // Instantiate generative model backed by Google AI with AppCheck attestation
      _model = FirebaseAI.googleAI(appCheck: appCheck).generativeModel(
        model: modelName,
        systemInstruction: Content.system(fullPrompt),
      );

      // Start an initial empty chat session
      _chatSession = _model!.startChat();
      _initialized = true;
      appLogger.i('[FirebaseAiService] Initialized successfully with GoogleAI backend ($modelName) and AppCheck.');
    } catch (e, stack) {
      _initialized = false;
      appLogger.e('[FirebaseAiService] Failed to initialize FirebaseAiService: $e', error: e, stackTrace: stack);
    }
  }

  /// Whether the Firebase AI service is ready to accept queries.
  bool get isAvailable => _initialized && _model != null;

  /// Sends a prompt to the Gemini model and returns a real-time reactive stream of token chunks.
  ///
  /// - [prompt]: The user's input question or statement.
  /// - [history]: Optional historical messages used to reconstitute multi-turn conversation context.
  ///
  /// Throws [StateError] if service initialization fails completely.
  Stream<String> sendMessageStream(
    String prompt, {
    List<ChatMessage>? history,
  }) async* {
    // 1. Auto-recovery: If service is uninitialized, attempt on-demand initialization
    if (!isAvailable) {
      appLogger.w('[FirebaseAiService] Service not initialized, triggering auto-initialize...');
      initialize();
    }

    if (!isAvailable) {
      appLogger.e('[FirebaseAiService] Initialization failed. Cannot send message.');
      throw StateError('FirebaseAiService is not available.');
    }

    // 2. Re-anchor session with multi-turn history if session is absent
    if (_chatSession == null) {
      appLogger.i('[FirebaseAiService] ChatSession was null, creating new session with history...');
      resetChatSession(history: history);
    }

    final promptSnippet = prompt.length > 40 ? '${prompt.substring(0, 40)}...' : prompt;
    appLogger.i('[FirebaseAiService] Stream Request Started | prompt="$promptSnippet" | historyLength=${history?.length ?? 0}');

    final startTime = DateTime.now();
    int chunkCount = 0;
    int totalCharCount = 0;

    try {
      // Wrap user text prompt into SDK Content format
      final contentPrompt = Content.text(prompt);

      // Select multi-turn session stream if available, otherwise fallback to single-turn stream
      final responseStream = _chatSession != null
          ? _chatSession!.sendMessageStream(contentPrompt)
          : _model!.generateContentStream([contentPrompt]);

      // Yield token chunks as they arrive across the wire
      await for (final response in responseStream) {
        if (response.text != null && response.text!.isNotEmpty) {
          chunkCount++;
          totalCharCount += response.text!.length;

          // Track Time-To-First-Token (TTFT) for APM telemetry
          if (chunkCount == 1) {
            final firstChunkMs = DateTime.now().difference(startTime).inMilliseconds;
            appLogger.i('[FirebaseAiService] First token chunk received in ${firstChunkMs}ms');
          }
          yield response.text!;
        }
      }

      final totalMs = DateTime.now().difference(startTime).inMilliseconds;
      appLogger.i('[FirebaseAiService] Stream Finished Success | chunks=$chunkCount | totalChars=$totalCharCount | elapsed=${totalMs}ms');
    } catch (e, stack) {
      appLogger.e('[FirebaseAiService] Stream Error | type=${e.runtimeType} | error=$e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Resets the current chat session or recreates it with an existing conversation history.
  ///
  /// Useful when clearing chat history or synchronizing state with restored sessions.
  void resetChatSession({List<ChatMessage>? history}) {
    if (_model != null) {
      final formattedHistory = _convertHistory(history);
      final historyCount = formattedHistory?.length ?? 0;
      appLogger.i('[FirebaseAiService] Resetting chat session with $historyCount history items.');
      _chatSession = _model!.startChat(history: formattedHistory);
    }
  }

  /// Converts internal domain [ChatMessage] models into Gemini SDK [Content] objects.
  ///
  /// Filters out empty or sending messages to ensure only valid conversational
  /// turns are passed to the Gemini context window.
  List<Content>? _convertHistory(List<ChatMessage>? history) {
    if (history == null || history.isEmpty) return null;

    final List<Content> contents = [];
    for (final msg in history) {
      // Ignore blank or placeholder messages
      if (msg.content.trim().isEmpty) continue;

      // Map role: 'user' -> Content('user', ...), 'model' -> Content('model', ...)
      if (msg.role == 'user') {
        contents.add(Content('user', [TextPart(msg.content)]));
      } else if (msg.role == 'model') {
        contents.add(Content('model', [TextPart(msg.content)]));
      }
    }
    return contents.isEmpty ? null : contents;
  }
}

