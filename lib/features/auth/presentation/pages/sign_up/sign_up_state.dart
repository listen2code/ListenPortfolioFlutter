import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';

part 'sign_up_state.freezed.dart';

@freezed
abstract class SignUpState extends BaseState with _$SignUpState {
  const factory SignUpState({
    @Default('') String fullName,
    @Default('') String email,
    @Default('') String password,
    @Default('') String confirmPassword,
    String? fullNameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
  }) = _SignUpState;
  const SignUpState._();
}
