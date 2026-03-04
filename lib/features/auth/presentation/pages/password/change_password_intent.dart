import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'change_password_intent.freezed.dart';

@freezed
class ChangePasswordIntent extends BaseIntent with _$ChangePasswordIntent {
  const factory ChangePasswordIntent.oldPasswordChanged(String password) = _OldPasswordChanged;
  const factory ChangePasswordIntent.newPasswordChanged(String password) = _NewPasswordChanged;
  const factory ChangePasswordIntent.confirmPasswordChanged(String password) = _ConfirmPasswordChanged;
  const factory ChangePasswordIntent.submitChange() = _SubmitChange;

  const ChangePasswordIntent._();
}
