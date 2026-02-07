import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/login_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/shared/extension/navigation_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'login_state.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel with ConsumeNavigableViewModel<LoginState> {
  @override
  LoginState build() {
    return const LoginState();
  }

  FutureOr handleIntent(LoginIntent intent) {
    return intent.when(
      usernameChanged: _onUsernameChanged,
      passwordChanged: _onPasswordChanged,
      togglePasswordVisibility: _onTogglePasswordVisibility,
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
      (user) {
        state = state.copyWith(isLoading: false, pendingNavigation: LoginNavigationTarget.home);
      },
    );
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
