import 'dart:async';

import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/usecases/signup_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/sign_up/sign_up_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'sign_up_state.dart';

part 'sign_up_view_model.g.dart';

@riverpod
class SignUpViewModel extends _$SignUpViewModel with ViewModelMixin<SignUpState, SignUpIntent> {
  @override
  SignUpState build() {
    final String initialName = AppNav.getArgs<String>() ?? '';
    return SignUpState(fullName: initialName);
  }

  @override
  FutureOr<void> onIntent(SignUpIntent intent) {
    intent.when(
      fullNameChanged: (name) => updateState(state.copyWith(fullName: name, fullNameError: null)),
      emailChanged: (email) => updateState(state.copyWith(email: email, emailError: null)),
      passwordChanged: (password) => updateState(state.copyWith(password: password, passwordError: null)),
      confirmPasswordChanged: (password) =>
          updateState(state.copyWith(confirmPassword: password, confirmPasswordError: null)),
      submitSignUp: _onSubmitSignUp,
      navigateToLogin: () => emitEffect(NavigationEffect.back()),
    );
  }

  Future<void> _onSubmitSignUp() async {
    // 1. Validation Logic
    final fullNameError = state.fullName.isEmpty ? I18nKeys.fieldRequired.tr : null;
    final emailError = Validators.validateEmail(
      state.email,
      requiredMsg: I18nKeys.fieldRequired.tr,
      invalidMsg: I18nKeys.invalidEmail.tr,
    );
    final passwordError = Validators.validatePassword(
      state.password,
      requiredMsg: I18nKeys.fieldRequired.tr,
      minLengthMsg: I18nKeys.minLengthMsg.trArgs(['6']),
    );

    String? confirmPasswordError;
    if (state.confirmPassword.isEmpty) {
      confirmPasswordError = I18nKeys.fieldRequired.tr;
    } else if (state.confirmPassword != state.password) {
      confirmPasswordError = I18nKeys.passwordsDoNotMatch.tr;
    }

    if (fullNameError != null ||
        emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      updateState(
        state.copyWith(
          fullNameError: fullNameError,
          emailError: emailError,
          passwordError: passwordError,
          confirmPasswordError: confirmPasswordError,
        ),
      );
      return;
    }

    // 2. Execute registration request via UseCase
    await call<void>(
      ref.execute(
        signupUseCaseProvider,
        SignupParams(name: state.fullName, email: state.email, password: state.password),
      ),
      showLoading: true,
      onSuccess: (_) {
        emitEffect(MessageEffect(I18nKeys.registrationSuccess.tr));
        emitEffect(NavigationEffect.back(result: true));
      },
    );
  }
}
