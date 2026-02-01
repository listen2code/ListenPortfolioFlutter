import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/login_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'login_state.dart';

part 'login_view_model.g.dart';

/// ViewModel for login feature
/// Handles user intents and emits new states
/// Implements unidirectional data flow (MVI pattern)
@riverpod
class LoginViewModel extends _$LoginViewModel {
  late final LoginUseCase _loginUseCase;

  @override
  LoginState build() {
    // Initialize synchronously
    appLogger.d('LoginViewModel: initialized');
    _initializeUseCase();
    return const LoginState();
  }

  void _initializeUseCase() async {
    _loginUseCase = await ref.read(loginUseCaseProvider.future);
  }

  /// Handle user intents
  void handleIntent(LoginIntent intent) {
    appLogger.d('LoginViewModel: handling intent: $intent');
    intent.when(
      usernameChanged: _onUsernameChanged,
      passwordChanged: _onPasswordChanged,
      togglePasswordVisibility: _onTogglePasswordVisibility,
      submitLogin: _onSubmitLogin,
      navigateToSignup: _onNavigateToSignup,
      navigateToForgotPassword: _onNavigateToForgotPassword,
    );
  }

  void _onUsernameChanged(String username) {
    state = state.copyWith(username: username, usernameError: null, errorMessage: null);
  }

  void _onPasswordChanged(String password) {
    state = state.copyWith(password: password, passwordError: null, errorMessage: null);
  }

  void _onTogglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  Future<void> _onSubmitLogin() async {
    appLogger.i('LoginViewModel: submitting login');

    // Validate inputs
    final usernameError = Validators.validateUsername(state.username);
    final passwordError = Validators.validatePassword(state.password);

    if (usernameError != null || passwordError != null) {
      state = state.copyWith(usernameError: usernameError, passwordError: passwordError);
      appLogger.w('LoginViewModel: validation failed');
      return;
    }

    // Start loading
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Execute use case
    final result = await _loginUseCase(LoginParams(username: state.username, password: state.password));

    // Handle result
    result.fold(
      (failure) {
        appLogger.e('LoginViewModel: login failed: ${failure.message}');
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (user) {
        appLogger.i('LoginViewModel: login successful for user: ${user.name}');
        state = state.copyWith(isLoading: false, isSuccess: true);
      },
    );
  }

  void _onNavigateToSignup() {
    appLogger.d('LoginViewModel: navigate to signup requested');
    // Navigation handled by page
  }

  void _onNavigateToForgotPassword() {
    appLogger.d('LoginViewModel: navigate to forgot password requested');
    // Navigation handled by page
  }
}
