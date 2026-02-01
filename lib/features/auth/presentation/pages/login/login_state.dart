import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

/// Immutable state for login feature
/// Represents the complete UI state at any point in time
@freezed
abstract class LoginState with _$LoginState {
  const LoginState._();

  const factory LoginState({
    @Default('') String username,
    @Default('') String password,
    @Default(false) bool isPasswordVisible,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? errorMessage,
    String? usernameError,
    String? passwordError,
  }) = _LoginState;
}
