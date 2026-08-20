import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_chat_request_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_chat_response_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_preset_qa_response_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/domain/repositories/ai_chat_repository.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/domain/usecases/get_preset_qa_use_case.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/domain/usecases/send_chat_message_use_case.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/pages/ai_chat_state.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/pages/ai_chat_view_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/provider/ai_chat_provider.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/domain/entities/chat_message.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/widgets/ai_chat_header.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/widgets/ai_chat_input_bar.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/widgets/ai_chat_message_bubble.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/widgets/ai_chat_mode_selector.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/widgets/ai_chat_panel.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/presentation/widgets/ai_preset_questions.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_uikit/uikit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAiChatRepository extends Mock implements AiChatRepository {}
class FakeAiChatRequestModel extends Fake implements AiChatRequestModel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAiChatRepository mockRepo;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    settingManager.loadSettings();
    registerFallbackValue(FakeAiChatRequestModel());
  });

  setUp(() {
    mockRepo = MockAiChatRepository();
  });

  Widget wrapWithTheme(Widget child) {
    return ProviderScope(
      overrides: [
        aiChatRepositoryProvider.overrideWith((ref) => Future.value(mockRepo)),
        sendChatMessageUseCaseProvider.overrideWith((ref) => Future.value(SendChatMessageUseCase(mockRepo))),
        getPresetQaUseCaseProvider.overrideWith((ref) => Future.value(GetPresetQaUseCase(mockRepo))),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }

  group('AiChat Widgets Tests', () {
    testWidgets('AiChatHeader should display title, subtitle, clear button, and close button', (WidgetTester tester) async {
      var closed = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiChatRepositoryProvider.overrideWith((ref) => Future.value(mockRepo)),
            sendChatMessageUseCaseProvider.overrideWith((ref) => Future.value(SendChatMessageUseCase(mockRepo))),
            getPresetQaUseCaseProvider.overrideWith((ref) => Future.value(GetPresetQaUseCase(mockRepo))),
          ],
          child: Consumer(
            builder: (context, ref, _) {
              final viewModel = ref.read(aiChatViewModelProvider.notifier);
              const state = AiChatState(mode: 'visitor');
              return MaterialApp(
                home: Scaffold(
                  body: AiChatHeader(
                    chatViewModel: viewModel,
                    chatState: state,
                    onClose: () => closed = true,
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text(I18nKeys.aiChatTitle.tr), findsOneWidget);
      expect(find.text(I18nKeys.aiChatSubtitle.tr), findsOneWidget);
      expect(find.byIcon(Icons.delete_sweep_outlined), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      // Tap close button
      await tester.tap(find.byIcon(Icons.close_rounded));
      expect(closed, isTrue);

      // Tap clear history button
      await tester.tap(find.byIcon(Icons.delete_sweep_outlined));
      await tester.pump();
    });

    testWidgets('AiChatModeSelector should switch modes on tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiChatRepositoryProvider.overrideWith((ref) => Future.value(mockRepo)),
            sendChatMessageUseCaseProvider.overrideWith((ref) => Future.value(SendChatMessageUseCase(mockRepo))),
            getPresetQaUseCaseProvider.overrideWith((ref) => Future.value(GetPresetQaUseCase(mockRepo))),
          ],
          child: Consumer(
            builder: (context, ref, _) {
              final viewModel = ref.read(aiChatViewModelProvider.notifier);
              const state = AiChatState(mode: 'visitor');
              return MaterialApp(
                home: Scaffold(
                  body: AiChatModeSelector(
                    chatViewModel: viewModel,
                    chatState: state,
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text(I18nKeys.aiModeVisitor.tr), findsOneWidget);
      expect(find.text(I18nKeys.aiModeInterviewer.tr), findsOneWidget);

      // Tap interviewer mode
      await tester.tap(find.text(I18nKeys.aiModeInterviewer.tr));
      await tester.pump();
    });

    testWidgets('AiChatInputBar should send message and invoke callback on send button tap', (WidgetTester tester) async {
      when(() => mockRepo.sendChatMessage(param: any(named: 'param'))).thenAnswer(
        (_) async => const Right(AiChatResponseModel(reply: 'Hello back')),
      );

      final controller = TextEditingController(text: 'Hello AI');
      var sendCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiChatRepositoryProvider.overrideWith((ref) => Future.value(mockRepo)),
            sendChatMessageUseCaseProvider.overrideWith((ref) => Future.value(SendChatMessageUseCase(mockRepo))),
            getPresetQaUseCaseProvider.overrideWith((ref) => Future.value(GetPresetQaUseCase(mockRepo))),
          ],
          child: Consumer(
            builder: (context, ref, _) {
              final viewModel = ref.read(aiChatViewModelProvider.notifier);
              return MaterialApp(
                home: Scaffold(
                  body: AiChatInputBar(
                    controller: controller,
                    chatViewModel: viewModel,
                    onSend: () => sendCalled = true,
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byType(CommonTextField), findsOneWidget);
      expect(find.byIcon(Icons.send_rounded), findsOneWidget);

      // Tap send button
      await tester.tap(find.byIcon(Icons.send_rounded));
      await tester.pump();

      expect(sendCalled, isTrue);
      expect(controller.text, isEmpty);
    });

    testWidgets('AiChatPanel should render all components and handle close', (WidgetTester tester) async {
      when(() => mockRepo.getPresetQAs(route: any(named: 'route'))).thenAnswer(
        (_) async => const Right(AiPresetQaResponseModel(qas: {
          'home': [PresetQaItem(question: 'Question 1', answer: 'Answer 1')],
        })),
      );
      when(() => mockRepo.sendChatMessage(param: any(named: 'param'))).thenAnswer(
        (_) async => const Right(AiChatResponseModel(reply: 'Hello back')),
      );

      var closed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          AiChatPanel(onClose: () => closed = true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AiChatHeader), findsOneWidget);
      expect(find.byType(AiChatModeSelector), findsOneWidget);
      expect(find.byType(AiChatInputBar), findsOneWidget);

      // Tap close button in header
      await tester.tap(find.byIcon(Icons.close_rounded));
      expect(closed, isTrue);
    });

    testWidgets('AiChatMessageBubble should render user message and model failure states', (WidgetTester tester) async {
      final userMsg = ChatMessage(
        id: '1',
        role: 'user',
        content: 'User query message',
        timestamp: DateTime.now(),
      );
      final modelFailMsg = ChatMessage(
        id: '2',
        role: 'model',
        content: 'Model error message',
        timestamp: DateTime.now(),
        isFailed: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AiChatMessageBubble(message: userMsg),
                AiChatMessageBubble(message: modelFailMsg),
              ],
            ),
          ),
        ),
      );

      expect(find.text('User query message'), findsOneWidget);
      expect(find.text('Model error message'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets('AiPresetQuestions renders horizontal chips and handles selection', (WidgetTester tester) async {
      var selected = false;
      final state = const AiChatState(presetQuestions: ['Question 1', 'Question 2']);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiChatRepositoryProvider.overrideWith((ref) => Future.value(mockRepo)),
            sendChatMessageUseCaseProvider.overrideWith((ref) => Future.value(SendChatMessageUseCase(mockRepo))),
            getPresetQaUseCaseProvider.overrideWith((ref) => Future.value(GetPresetQaUseCase(mockRepo))),
          ],
          child: Consumer(
            builder: (context, ref, _) {
              final viewModel = ref.read(aiChatViewModelProvider.notifier);
              return MaterialApp(
                home: Scaffold(
                  body: AiPresetQuestions(
                    chatViewModel: viewModel,
                    chatState: state,
                    onSelectQuestion: () => selected = true,
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Question 1'), findsOneWidget);
      expect(find.text('Question 2'), findsOneWidget);

      await tester.tap(find.text('Question 1'));
      await tester.pump();
      expect(selected, isTrue);
    });
  });
}
