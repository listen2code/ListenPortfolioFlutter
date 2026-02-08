import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/login_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/shared/extension/navigation_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_state.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel with ConsumeNavigableViewModel<LoginState> {
  static const String _keyUsername = 'saved_username';
  static const String _keyPassword = 'saved_password';
  static const String _keyRememberMe = 'remember_me';

  @override
  LoginState build() {
    _loadSavedCredentials();
    return const LoginState();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_keyRememberMe) ?? false;
    if (rememberMe) {
      final username = prefs.getString(_keyUsername) ?? '';
      final password = prefs.getString(_keyPassword) ?? '';
      state = state.copyWith(username: username, password: password, rememberMe: true);
    }
  }

  FutureOr handleIntent(LoginIntent intent) {
    return intent.when(
      usernameChanged: _onUsernameChanged,
      passwordChanged: _onPasswordChanged,
      togglePasswordVisibility: _onTogglePasswordVisibility,
      toggleRememberMe: _onToggleRememberMe,
      submitLogin: _onSubmitLogin,
      navigateToSignup: _onNavigateToSignup,
      navigateToForgotPassword: _onNavigateToForgotPassword,
      skipLogin: _onNavigateToHome,
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

  void _onToggleRememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  Future<void> _onSubmitLogin() async {
    final usernameError = Validators.validateUsername(state.username);
    final passwordError = Validators.validatePassword(state.password);

    if (usernameError != null || passwordError != null) {
      state = state.copyWith(usernameError: usernameError, passwordError: passwordError);
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final loginUseCase = await ref.read(loginUseCaseProvider.future);
    final result = await loginUseCase(LoginParams(username: state.username, password: state.password));

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (user) async {
        await _saveOrClearCredentials();
        state = state.copyWith(isLoading: false, pendingNavigation: LoginNavigationTarget.home);
      },
    );
  }

  Future<void> _saveOrClearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (state.rememberMe) {
      await prefs.setString(_keyUsername, state.username);
      await prefs.setString(_keyPassword, state.password);
      await prefs.setBool(_keyRememberMe, true);
    } else {
      await prefs.remove(_keyUsername);
      await prefs.remove(_keyPassword);
      await prefs.setBool(_keyRememberMe, false);
    }
  }

  void _onNavigateToSignup() {
    state = state.copyWith(pendingNavigation: LoginNavigationTarget.signup);
  }

  void _onNavigateToForgotPassword() {
    state = state.copyWith(pendingNavigation: LoginNavigationTarget.forgotPassword);
  }

  void _onNavigateToHome() {
    state = state.copyWith(pendingNavigation: LoginNavigationTarget.home);
  }
}
