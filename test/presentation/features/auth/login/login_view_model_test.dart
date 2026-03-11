import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  final String keyUsername = AppConstants.loginUsernameKey;
  final String keyPassword = AppConstants.loginPasswordKey;
  final String keyRememberMe = AppConstants.loginRememberMeKey;

  setUp(() async {
    // Force reset the mock values for each test case
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();

    FlutterSecureStorage.setMockInitialValues({});
    await SecureStorageUtil.init();

    mockUseCase = MockLoginUseCase();
    container = ProviderContainer(
      overrides: [loginUseCaseProvider.overrideWith((ref) => Future.value(mockUseCase))],
    );

    // CRITICAL: Keep the auto-dispose provider alive
    container.listen(loginViewModelProvider, (previous, next) {});

    registerFallbackValue(LoginParams(username: '', password: ''));
  });

  tearDown(() => container.dispose());

  group('LoginViewModel Intent Tests', () {
    test('Initial state should be empty by default', () {
      final state = container.read(loginViewModelProvider);
      expect(state.username, '');
      expect(state.password, '');
      expect(state.rememberMe, false);
    });

    test('Should load saved credentials on initialization if rememberMe is true', () async {
      await SpUtil.put(keyRememberMe, true);
      await SpUtil.put(keyUsername, 'saved_user');
      await SecureStorageUtil.put(keyPassword, 'saved_password');

      final newContainer = ProviderContainer(
        overrides: [loginUseCaseProvider.overrideWith((ref) => Future.value(mockUseCase))],
      );
      newContainer.listen(loginViewModelProvider, (previous, next) {});

      var state = newContainer.read(loginViewModelProvider);
      expect(state.username, 'saved_user');
      expect(state.rememberMe, true);

      // Wait for async password load from secure storage
      await Future.delayed(const Duration(milliseconds: 100));

      state = newContainer.read(loginViewModelProvider);
      expect(state.password, 'saved_password');

      newContainer.dispose();
    });

    test('Intent: usernameChanged should update state', () async {
      final notifier = container.read(loginViewModelProvider.notifier);
      await notifier.handleIntent(const LoginIntent.usernameChanged('new_user'));

      final state = container.read(loginViewModelProvider);
      expect(state.username, 'new_user');
    });

    test('Intent: toggleRememberMe should persist credentials', () async {
      final notifier = container.read(loginViewModelProvider.notifier);

      // 1. Setup values
      await notifier.handleIntent(const LoginIntent.usernameChanged('test_user'));
      await notifier.handleIntent(const LoginIntent.passwordChanged('test_pass'));

      // 2. Perform toggle
      await notifier.handleIntent(const LoginIntent.toggleRememberMe());

      // Ensure all internal Notifier state updates are committed
      await Future.delayed(Duration.zero);

      final state = container.read(loginViewModelProvider);
      expect(state.rememberMe, true, reason: 'Expected rememberMe state to be true after toggle');

      // 3. Verify persistence
      expect(SpUtil.getBool(keyRememberMe), true);
      expect(SpUtil.getString(keyUsername), 'test_user');
      expect(await SecureStorageUtil.get(keyPassword), 'test_pass');
    });

    test('Intent: submitLogin success should navigate back', () async {
      final notifier = container.read(loginViewModelProvider.notifier);
      final testUser = UserModel(id: '1', name: 'Listen', email: 'test@test.com');

      when(() => mockUseCase.call(any())).thenAnswer((_) async => Right(testUser));

      await notifier.handleIntent(const LoginIntent.usernameChanged('validUser'));
      await notifier.handleIntent(const LoginIntent.passwordChanged('validPassword123'));

      expectLater(
        notifier.effectStream,
        emitsInOrder([
          isA<LoadingEffect>().having((e) => e.show, 'show', true),
          isA<MessageEffect>(),
          isA<NavigationEffect>().having((e) => e.isBack, 'isBack', true),
          isA<LoadingEffect>().having((e) => e.show, 'show', false),
        ]),
      );

      await notifier.handleIntent(const LoginIntent.submitLogin());
    });

    group('LoginViewModel Side Effects', () {
      test('Should clear credentials when rememberMe is toggled to false', () async {
        final notifier = container.read(loginViewModelProvider.notifier);

        // Pre-setup state
        await notifier.handleIntent(const LoginIntent.usernameChanged('user'));
        await notifier.handleIntent(const LoginIntent.passwordChanged('pass'));

        // Ensure state is true first
        if (!container.read(loginViewModelProvider).rememberMe) {
          await notifier.handleIntent(const LoginIntent.toggleRememberMe());
        }
        expect(container.read(loginViewModelProvider).rememberMe, true);

        // Toggle to false
        await notifier.handleIntent(const LoginIntent.toggleRememberMe());

        await Future.delayed(Duration.zero);
        expect(container.read(loginViewModelProvider).rememberMe, false);

        // Verify cleared
        expect(SpUtil.getBool(keyRememberMe), false);
        expect(SpUtil.getString(keyUsername), null);
        expect(await SecureStorageUtil.get(keyPassword), null);
      });
    });
  });
}
