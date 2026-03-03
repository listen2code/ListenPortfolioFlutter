import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LoginState extends BaseState with _$LoginState {
  const LoginState._();

  const factory LoginState({
    @Default('') String username,
    @Default('') String password,
    @Default(false) bool isPasswordVisible,
    @Default(false) bool rememberMe,
    String? usernameError,
    String? passwordError,
  }) = _LoginState;
}
