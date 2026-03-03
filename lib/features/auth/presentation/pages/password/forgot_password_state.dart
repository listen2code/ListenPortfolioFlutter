import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'forgot_password_state.freezed.dart';

@freezed
abstract class ForgotPasswordState extends BaseState with _$ForgotPasswordState {
  const factory ForgotPasswordState({@Default('') String email, String? emailError}) = _ForgotPasswordState;

  // Added private constructor to allow inheritance and custom methods
  const ForgotPasswordState._();
}
