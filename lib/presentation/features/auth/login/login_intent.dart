import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_intent.freezed.dart';

/// Intent/Event classes for login feature
/// Represents all possible user actions on the login page
@freezed
class LoginIntent with _$LoginIntent {
  const factory LoginIntent.usernameChanged(String username) = UsernameChanged;
  const factory LoginIntent.passwordChanged(String password) = PasswordChanged;
  const factory LoginIntent.togglePasswordVisibility() = TogglePasswordVisibility;
  const factory LoginIntent.submitLogin() = SubmitLogin;
  const factory LoginIntent.navigateToSignup() = NavigateToSignup;
  const factory LoginIntent.navigateToForgotPassword() = NavigateToForgotPassword;
}
