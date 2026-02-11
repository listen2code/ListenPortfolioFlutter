import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/login_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_state.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_view_model.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLoginUseCase mockUseCase;
  late ProviderContainer container;

  const String keyUsername = 'saved_username';
  const String keyPassword = 'saved_password';
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
      expect(state.isLoading, false);
    });

    test('Intent: usernameChanged should update state', () {
      final notifier = container.read(loginViewModelProvider.notifier);
      notifier.handleIntent(const LoginIntent.usernameChanged('new_user'));
      expect(container.read(loginViewModelProvider).username, 'new_user');
    });

    test('Intent: passwordChanged should update state', () {
      final notifier = container.read(loginViewModelProvider.notifier);
      notifier.handleIntent(const LoginIntent.passwordChanged('new_pass'));
      expect(container.read(loginViewModelProvider).password, 'new_pass');
    });

    test('Intent: togglePasswordVisibility should toggle state', () {
      final notifier = container.read(loginViewModelProvider.notifier);
      final initialVisibility = container.read(loginViewModelProvider).isPasswordVisible;

      notifier.handleIntent(const LoginIntent.togglePasswordVisibility());
      expect(container.read(loginViewModelProvider).isPasswordVisible, !initialVisibility);
    });

    test('Intent: toggleRememberMe should persist state immediately', () async {
      final notifier = container.read(loginViewModelProvider.notifier);
      notifier.handleIntent(const LoginIntent.usernameChanged('test_user'));
      notifier.handleIntent(const LoginIntent.passwordChanged('test_pass'));

      // 1. Toggle ON
      await notifier.handleIntent(const LoginIntent.toggleRememberMe());
      expect(container.read(loginViewModelProvider).rememberMe, true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(keyRememberMe), true);
      expect(prefs.getString(keyUsername), 'test_user');
      expect(prefs.getString(keyPassword), 'test_pass');

      // 2. Toggle OFF
      await notifier.handleIntent(const LoginIntent.toggleRememberMe());
      expect(container.read(loginViewModelProvider).rememberMe, false);
      expect(prefs.getBool(keyRememberMe), false);
      expect(prefs.containsKey(keyUsername), false); // Should be removed
    });

    test('Persistence: changing fields while rememberMe is true should update SP', () async {
      final notifier = container.read(loginViewModelProvider.notifier);

      // Turn on rememberMe
      await notifier.handleIntent(const LoginIntent.toggleRememberMe());

      // Change username
      notifier.handleIntent(const LoginIntent.usernameChanged('live_user'));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(keyUsername), 'live_user');
    });

    test('Intent: submitLogin with invalid inputs should show errors', () async {
      final notifier = container.read(loginViewModelProvider.notifier);

      // Empty inputs
      await notifier.handleIntent(const LoginIntent.submitLogin());

      final state = container.read(loginViewModelProvider);
      expect(state.usernameError, isNotNull);
      expect(state.passwordError, isNotNull);
      verifyNever(() => mockUseCase.call(any()));
    });

    test('Intent: submitLogin success should navigate home', () async {
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

      await notifier.handleIntent(const LoginIntent.submitLogin());

      final state = container.read(loginViewModelProvider);
      expect(state.pendingNavigation, LoginNavigationTarget.success);
      expect(state.isLoading, false);
    });

    test('Intent: navigateToSignup should update state', () {
      container.read(loginViewModelProvider.notifier).handleIntent(const LoginIntent.navigateToSignup());
      expect(container.read(loginViewModelProvider).pendingNavigation, LoginNavigationTarget.signup);
    });

    test('Intent: navigateToForgotPassword should update state', () {
      container
          .read(loginViewModelProvider.notifier)
          .handleIntent(const LoginIntent.navigateToForgotPassword());
      expect(container.read(loginViewModelProvider).pendingNavigation, LoginNavigationTarget.forgotPassword);
    });

    test('Intent: skipLogin should navigate home', () {
      container.read(loginViewModelProvider.notifier).handleIntent(const LoginIntent.skipLogin());
      expect(container.read(loginViewModelProvider).pendingNavigation, LoginNavigationTarget.back);
    });
  });
}
