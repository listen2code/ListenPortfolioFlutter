import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/login_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_view_model.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLoginUseCase mockUseCase;
  late ProviderContainer container;

  const String keyUsername = 'saved_username';
  const String keyRememberMe = 'remember_me';

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockUseCase = MockLoginUseCase();
    container = ProviderContainer(
      overrides: [loginUseCaseProvider.overrideWith((ref) => Future.value(mockUseCase))],
    );
    registerFallbackValue(LoginParams(username: '', password: ''));
  });

  tearDown(() => container.dispose());

  group('LoginViewModel Intent Tests', () {
    test('Initial state should be correct', () {
      final state = container.read(loginViewModelProvider);
      expect(state.username, '');
      expect(state.rememberMe, false);
    });

    test('Intent: usernameChanged should update state', () {
      final notifier = container.read(loginViewModelProvider.notifier);
      notifier.handleIntent(const LoginIntent.usernameChanged('new_user'));
      expect(container.read(loginViewModelProvider).username, 'new_user');
    });

    test('Intent: toggleRememberMe should persist state immediately', () async {
      final notifier = container.read(loginViewModelProvider.notifier);
      notifier.handleIntent(const LoginIntent.usernameChanged('test_user'));
      notifier.handleIntent(const LoginIntent.passwordChanged('test_pass'));

      await notifier.handleIntent(const LoginIntent.toggleRememberMe());
      expect(container.read(loginViewModelProvider).rememberMe, true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(keyRememberMe), true);
      expect(prefs.getString(keyUsername), 'test_user');
    });

    test('Intent: submitLogin success should emit correct sequence of effects', () async {
      final notifier = container.read(loginViewModelProvider.notifier);
      final testUser = UserModel(
        id: '1',
        name: 'Listen',
        email: 'test@test.com',
        createdAt: DateTime.now().toString(),
      );

      when(() => mockUseCase.call(any())).thenAnswer((_) async => Right(testUser));

      notifier.handleIntent(const LoginIntent.usernameChanged('validUser'));
      notifier.handleIntent(const LoginIntent.passwordChanged('validPassword123'));

      // Verify that the effects are emitted in the correct order:
      // 1. Loading starts
      // 2. Success message emitted
      // 3. Navigation back with result: true
      // 4. Loading ends
      expectLater(
        notifier.effectStream,
        emitsInOrder([
          isA<LoadingEffect>().having((e) => e.show, 'show', true),
          isA<MessageEffect>(),
          isA<NavigationEffect>()
              .having((e) => e.isBack, 'isBack', true)
              .having((e) => e.arguments, 'arguments', true),
          isA<LoadingEffect>().having((e) => e.show, 'show', false),
        ]),
      );

      await notifier.handleIntent(const LoginIntent.submitLogin());
    });

    test('Intent: submitLogin failure should emit ErrorEffect', () async {
      final notifier = container.read(loginViewModelProvider.notifier);
      when(() => mockUseCase.call(any())).thenAnswer((_) async => const Left(ServerFailure('Invalid')));

      notifier.handleIntent(const LoginIntent.usernameChanged('validUser'));
      notifier.handleIntent(const LoginIntent.passwordChanged('validPassword123'));

      expectLater(
        notifier.effectStream,
        emitsInOrder([
          isA<LoadingEffect>().having((e) => e.show, 'show', true),
          isA<MessageEffect>().having((e) => e.type, 'type', MessageType.error),
          isA<LoadingEffect>().having((e) => e.show, 'show', false),
        ]),
      );

      await notifier.handleIntent(const LoginIntent.submitLogin());
    });

    test('Intent: navigateToSignup should emit NavigationEffect', () {
      final notifier = container.read(loginViewModelProvider.notifier);
      expectLater(
        notifier.effectStream,
        emits(isA<NavigationEffect>().having((e) => e.target, 'target', Routes.signUp)),
      );
      notifier.handleIntent(const LoginIntent.navigateToSignup());
    });

    test('Intent: skipLogin should emit NavigationEffect.back with result false', () {
      final notifier = container.read(loginViewModelProvider.notifier);
      expectLater(
        notifier.effectStream,
        emits(
          isA<NavigationEffect>()
              .having((e) => e.isBack, 'isBack', true)
              .having((e) => e.arguments, 'arguments', false),
        ),
      );
      notifier.handleIntent(const LoginIntent.skipLogin());
    });
  });
}
