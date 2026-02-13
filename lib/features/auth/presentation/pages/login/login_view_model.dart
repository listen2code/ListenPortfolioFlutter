import 'dart:async';

import 'package:listen_portfolio_flutter/core/base/base_view_model.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/login_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/shared/base/base_auth_listenable_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_state.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel with ConsumeViewModel<LoginState> {
  static const String _keyUsername = 'saved_username';
  static const String _keyPassword = 'saved_password';
  static const String _keyRememberMe = 'remember_me';

  @override
  LoginState build() {
    _loadSavedCredentials();
    return const LoginState();
  }

  // Load saved credentials from local storage
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_keyRememberMe) ?? false;
    if (rememberMe) {
      final username = prefs.getString(_keyUsername) ?? '';
      final password = prefs.getString(_keyPassword) ?? '';
      state = state.copyWith(username: username, password: password, rememberMe: true);
    }
  }

  /// Entry point for all UI interactions.
  /// Wraps intent processing with aspect logging for input and final state.
  FutureOr<void> handleIntent(LoginIntent intent) {
    return dispatch(
      intent,
      () => intent.when(
        usernameChanged: _onUsernameChanged,
        passwordChanged: _onPasswordChanged,
        togglePasswordVisibility: _onTogglePasswordVisibility,
        toggleRememberMe: _onToggleRememberMe,
        submitLogin: _onSubmitLogin,
        navigateToSignup: _onNavigateToSignup,
        navigateToForgotPassword: _onNavigateToForgotPassword,
        skipLogin: _onNavigateToBack,
      ),
    );
  }

  FutureOr<void> _onUsernameChanged(String username) {
    state = state.copyWith(username: username, usernameError: null, errorMessage: null);
    if (state.rememberMe) _saveOrClearCredentials();
  }

  FutureOr<void> _onPasswordChanged(String password) {
    state = state.copyWith(password: password, passwordError: null, errorMessage: null);
    if (state.rememberMe) _saveOrClearCredentials();
  }

  FutureOr<void> _onTogglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  Future<void> _onToggleRememberMe() async {
    state = state.copyWith(rememberMe: !state.rememberMe);
    await _saveOrClearCredentials();
  }

  Future<void> _onSubmitLogin() async {
    final usernameError = Validators.validateUsername(
      state.username,
      requiredMsg: I18nKeys.fieldRequired.tr,
      minLengthMsg: I18nKeys.minLengthMsg.trArgs(['3']),
    );
    final passwordError = Validators.validatePassword(
      state.password,
      requiredMsg: I18nKeys.fieldRequired.tr,
      minLengthMsg: I18nKeys.minLengthMsg.trArgs(['6']),
    );

    if (usernameError != null || passwordError != null) {
      state = state.copyWith(usernameError: usernameError, passwordError: passwordError);
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final loginUseCase = await ref.read(loginUseCaseProvider.future);
    final result = await loginUseCase(LoginParams(username: state.username, password: state.password));

    result.fold((failure) => state = state.copyWith(isLoading: false, errorMessage: failure.message), (user) {
      authManager.login(user);
      state = state.copyWith(isLoading: false, pendingNavigation: LoginNavigationTarget.success);
    });
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

  FutureOr<void> _onNavigateToSignup() =>
      state = state.copyWith(pendingNavigation: LoginNavigationTarget.signup);

  FutureOr<void> _onNavigateToForgotPassword() =>
      state = state.copyWith(pendingNavigation: LoginNavigationTarget.forgotPassword);

  FutureOr<void> _onNavigateToBack() => state = state.copyWith(pendingNavigation: LoginNavigationTarget.back);
}
