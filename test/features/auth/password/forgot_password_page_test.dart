import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/forgot_password_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_view_model.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/widgets/forgot_password_form.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/widgets/forgot_password_header.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_uikit/uikit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class FakeForgotPasswordRequestModel extends Fake implements ForgotPasswordRequestModel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuthRepo;
  late ProviderContainer container;

  setUpAll(() async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    settingManager.loadSettings();
    registerFallbackValue(FakeForgotPasswordRequestModel());
  });

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWith((ref) => Future.value(mockAuthRepo)),
        forgotPasswordUseCaseProvider.overrideWith((ref) => Future.value(ForgotPasswordUseCase(mockAuthRepo))),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ForgotPasswordViewModel Tests', () {
    test('emailChanged intent updates email state', () {
      final viewModel = container.read(forgotPasswordViewModelProvider.notifier);
      viewModel.handleIntent(const ForgotPasswordIntent.emailChanged('user@test.com'));

      final state = container.read(forgotPasswordViewModelProvider);
      expect(state.email, 'user@test.com');
    });

    test('submitReset with empty email sets emailError', () async {
      final viewModel = container.read(forgotPasswordViewModelProvider.notifier);
      await viewModel.handleIntent(const ForgotPasswordIntent.submitReset());

      final state = container.read(forgotPasswordViewModelProvider);
      expect(state.emailError, isNotNull);
    });

    test('submitReset success emits message and navigates back', () async {
      when(() => mockAuthRepo.forgotPassword(param: any(named: 'param'))).thenAnswer((_) async => const Right(null));

      final viewModel = container.read(forgotPasswordViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      viewModel.handleIntent(const ForgotPasswordIntent.emailChanged('user@test.com'));
      await viewModel.handleIntent(const ForgotPasswordIntent.submitReset());
      await pumpEventQueue();

      expect(effects.isNotEmpty, isTrue);
    });

    test('navigateToLogin intent emits NavigationEffect back', () async {
      final viewModel = container.read(forgotPasswordViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      await viewModel.handleIntent(const ForgotPasswordIntent.navigateToLogin());
      await pumpEventQueue();

      expect(effects.whereType<NavigationEffect>().isNotEmpty, isTrue);
    });
  });

  group('ForgotPasswordPage Widget Tests', () {
    testWidgets('should render form and handle input and submission', (WidgetTester tester) async {
      when(() => mockAuthRepo.forgotPassword(param: any(named: 'param'))).thenAnswer((_) async => const Right(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWith((ref) => Future.value(mockAuthRepo)),
            forgotPasswordUseCaseProvider.overrideWith((ref) => Future.value(ForgotPasswordUseCase(mockAuthRepo))),
          ],
          child: const MaterialApp(
            home: ForgotPasswordPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordHeader), findsOneWidget);
      expect(find.byType(ForgotPasswordForm), findsOneWidget);
      expect(find.byType(CommonTextField), findsOneWidget);

      // Enter email
      await tester.enterText(find.byType(CommonTextField), 'developer@test.com');
      await tester.pumpAndSettle();

      // Submit reset
      final submitBtn = find.text(I18nKeys.sendResetLink.tr);
      expect(submitBtn, findsOneWidget);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // Tap back to login
      final loginLink = find.text(I18nKeys.loginLink.tr);
      expect(loginLink, findsOneWidget);
      await tester.tap(loginLink);
      await tester.pumpAndSettle();
    });
  });
}
