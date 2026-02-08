import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_intent.freezed.dart';

@freezed
class LoginIntent with _$LoginIntent {
  const factory LoginIntent.usernameChanged(String username) = UsernameChanged;
  const factory LoginIntent.passwordChanged(String password) = PasswordChanged;
  const factory LoginIntent.togglePasswordVisibility() = TogglePasswordVisibility;
  const factory LoginIntent.toggleRememberMe() = ToggleRememberMe;
  const factory LoginIntent.submitLogin() = SubmitLogin;
  const factory LoginIntent.navigateToSignup() = NavigateToSignup;
  const factory LoginIntent.navigateToForgotPassword() = NavigateToForgotPassword;
  const factory LoginIntent.skipLogin() = SkipLogin;
}
