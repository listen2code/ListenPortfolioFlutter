import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/login_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_state.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_view_model.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late MockLoginUseCase mockUseCase;
  late ProviderContainer container;

  setUp(() {
    mockUseCase = MockLoginUseCase();
    container = ProviderContainer(overrides: [loginUseCaseProvider.overrideWith((ref) => Future.value(mockUseCase))]);
    registerFallbackValue(LoginParams(username: '', password: ''));
  });

  tearDown(() => container.dispose());

  group('LoginViewModel Tests', () {
    test('Initial state should be correct', () {
      final state = container.read(loginViewModelProvider);
      expect(state.username, '');
      expect(state.isLoading, false);
      expect(state.pendingNavigation, null);
    });

    test('Intent: usernameChanged should update state', () async {
      final notifier = container.read(loginViewModelProvider.notifier);
      await notifier.handleIntent(const LoginIntent.usernameChanged('admin'));
      expect(container.read(loginViewModelProvider).username, 'admin');
    });

    test('Intent: submitLogin success should navigate home', () async {
      final notifier = container.read(loginViewModelProvider.notifier);
      final testUser = UserModel(id: '1', name: 'Listen', email: 'test@test.com', createdAt: DateTime.now().toString());

      // Mock success result
      when(() => mockUseCase.call(any())).thenAnswer((_) async => Right(testUser));

      // Set valid inputs to pass internal validation
      notifier.handleIntent(const LoginIntent.usernameChanged('validUser'));
      notifier.handleIntent(const LoginIntent.passwordChanged('validPassword123'));

      await notifier.handleIntent(const LoginIntent.submitLogin());

      final state = container.read(loginViewModelProvider);
      expect(state.pendingNavigation, LoginNavigationTarget.home);
      expect(state.isLoading, false);
    });

    test('Intent: submitLogin failure should set errorMessage', () async {
      final notifier = container.read(loginViewModelProvider.notifier);
      const failure = ServerFailure('Invalid credentials');

      when(() => mockUseCase.call(any())).thenAnswer((_) async => const Left(failure));

      notifier.handleIntent(const LoginIntent.usernameChanged('user'));
      notifier.handleIntent(const LoginIntent.passwordChanged('pass123'));

      await notifier.handleIntent(const LoginIntent.submitLogin());

      final state = container.read(loginViewModelProvider);
      expect(state.errorMessage, 'Invalid credentials');
      expect(state.isLoading, false);
    });

    test('Intent: skipLogin should navigate home', () {
      container.read(loginViewModelProvider.notifier).handleIntent(const LoginIntent.skipLogin());
      expect(container.read(loginViewModelProvider).pendingNavigation, LoginNavigationTarget.home);
    });

    test('Logic: navigationConsumed should reset pendingNavigation', () async {
      final notifier = container.read(loginViewModelProvider.notifier);
      await notifier.handleIntent(const LoginIntent.navigateToSignup());

      expect(container.read(loginViewModelProvider).pendingNavigation, LoginNavigationTarget.signup);

      notifier.navigationConsumed();
      expect(container.read(loginViewModelProvider).pendingNavigation, null);
    });
  });
}
