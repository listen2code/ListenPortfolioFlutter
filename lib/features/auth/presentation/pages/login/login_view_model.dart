import 'dart:async';

import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/login_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'login_state.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel
    with ViewModelMixin<LoginState>
    implements IStateOwner<LoginState> {
  @override
  LoginState build() {
    final rememberMe = SpUtil.getBool(AppConstants.loginRememberMeKey);
    if (rememberMe) {
      final username = SpUtil.getString(AppConstants.loginUsernameKey) ?? '';

      // Asynchronously load the password from secure storage to avoid blocking build()
      // and keep the state as LoginState instead of AsyncValue<LoginState>
      _loadSavedPassword();

      return LoginState(username: username, rememberMe: true);
    }

    return const LoginState();
  }

  /// Load the saved password from secure storage and update the state.
  Future<void> _loadSavedPassword() async {
    final password = await SecureStorageUtil.get(AppConstants.loginPasswordKey) ?? '';
    state = state.copyWith(password: password);
  }

  /// Entry point for all UI interactions.
  /// Wraps intent processing with aspect logging and automatic loading management.
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
      // Automatically show/hide global loading overlay via ILoadingProvider
      showLoading: intent is SubmitLogin,
    );
  }

  FutureOr<void> _onUsernameChanged(String username) {
    state = state.copyWith(username: username, usernameError: null);
    if (state.rememberMe) _saveOrClearCredentials();
  }

  FutureOr<void> _onPasswordChanged(String password) {
    state = state.copyWith(password: password, passwordError: null);
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

    final loginUseCase = await ref.read(loginUseCaseProvider.future);
    final result = await loginUseCase(LoginParams(username: state.username, password: state.password));

    result.fold(
      (failure) {
        // Emit error effect using the convenient factory
        emitEffect(MessageEffect.error(failure.message));
      },
      (user) {
        authManager.login(user);
        // Notify success and navigate via Effects
        emitEffect(MessageEffect(I18nKeys.loginSuccess.tr));
        emitEffect(NavigationEffect.back(result: true));
      },
    );
  }

  Future<void> _saveOrClearCredentials() async {
    if (state.rememberMe) {
      await SpUtil.put(AppConstants.loginUsernameKey, state.username);
      // Use SecureStorageUtil for password to ensure security
      await SecureStorageUtil.put(AppConstants.loginPasswordKey, state.password);
      await SpUtil.put(AppConstants.loginRememberMeKey, true);
    } else {
      await SpUtil.remove(AppConstants.loginUsernameKey);
      await SecureStorageUtil.remove(AppConstants.loginPasswordKey);
      await SpUtil.put(AppConstants.loginRememberMeKey, false);
    }
  }

  void _onNavigateToSignup() => emitEffect(NavigationEffect(target: Routes.signUp));

  void _onNavigateToForgotPassword() => emitEffect(NavigationEffect(target: Routes.forgotPassword));

  void _onNavigateToBack() => emitEffect(NavigationEffect.back(result: false));
}
