import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'change_password_state.freezed.dart';

@freezed
abstract class ChangePasswordState extends BaseState with _$ChangePasswordState {
  const factory ChangePasswordState({
    @Default('') String oldPassword,
    @Default('') String newPassword,
    @Default('') String confirmPassword,
    String? oldPasswordError,
    String? newPasswordError,
    String? confirmPasswordError,
  }) = _ChangePasswordState;

  // Private constructor is required when using 'extends' with Freezed
  const ChangePasswordState._();
}
