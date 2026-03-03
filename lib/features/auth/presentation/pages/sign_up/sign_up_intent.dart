import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'sign_up_intent.freezed.dart';

@freezed
class SignUpIntent extends BaseIntent with _$SignUpIntent {
  const factory SignUpIntent.fullNameChanged(String name) = _FullNameChanged;
  const factory SignUpIntent.emailChanged(String email) = _EmailChanged;
  const factory SignUpIntent.passwordChanged(String password) = _PasswordChanged;
  const factory SignUpIntent.confirmPasswordChanged(String password) = _ConfirmPasswordChanged;
  const factory SignUpIntent.submitSignUp() = _SubmitSignUp;
  const factory SignUpIntent.navigateToLogin() = _NavigateToLogin;

  const SignUpIntent._();
}
