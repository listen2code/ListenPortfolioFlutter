import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/base/base_view_model.dart';

part 'login_state.freezed.dart';

/// Navigation targets for the login flow
enum LoginNavigationTarget { signup, forgotPassword, success, back }

@freezed
abstract class LoginState with _$LoginState implements BaseState<LoginNavigationTarget> {
  const LoginState._();

  const factory LoginState({
    @Default('') String username,
    @Default('') String password,
    @Default(false) bool isPasswordVisible,
    @Default(false) bool rememberMe,
    @Default(false) bool isLoading,
    String? usernameError,
    String? passwordError,
    String? errorMessage,
    LoginNavigationTarget? pendingNavigation,
  }) = _LoginState;
}
