import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'forgot_password_intent.freezed.dart';

@freezed
class ForgotPasswordIntent extends BaseIntent with _$ForgotPasswordIntent {
  const factory ForgotPasswordIntent.emailChanged(String email) = _EmailChanged;
  const factory ForgotPasswordIntent.submitReset() = _SubmitReset;
  const factory ForgotPasswordIntent.navigateToLogin() = _NavigateToLogin;
  const ForgotPasswordIntent._();
}
