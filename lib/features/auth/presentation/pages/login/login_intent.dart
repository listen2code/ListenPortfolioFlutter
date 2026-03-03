import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'login_intent.freezed.dart';

@freezed
abstract class LoginIntent extends BaseIntent with _$LoginIntent {
  const factory LoginIntent.usernameChanged(String username) = _UsernameChanged;
  const factory LoginIntent.passwordChanged(String password) = _PasswordChanged;
  const factory LoginIntent.togglePasswordVisibility() = _TogglePasswordVisibility;
  const factory LoginIntent.toggleRememberMe() = _ToggleRememberMe;
  const factory LoginIntent.submitLogin() = _SubmitLogin;
  const factory LoginIntent.navigateToSignup() = _NavigateToSignup;
  const factory LoginIntent.navigateToForgotPassword() = _NavigateToForgotPassword;
  const factory LoginIntent.skipLogin() = _SkipLogin;
  const LoginIntent._();
}
