import 'dart:async';

import '../../../data/models/signup_request_model.dart';
import 'sign_up_intent.dart';
import '../../provider/auth_provider.dart';
import '../../../../../shared/shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'sign_up_state.dart';

part 'sign_up_view_model.g.dart';

@riverpod
class SignUpViewModel extends _$SignUpViewModel with ViewModelMixin<SignUpState, SignUpIntent> {
  @override
  SignUpState build() {
    final SignUpArguments? args = AppNav.getArgs<SignUpArguments>();
    final String initialName = args?.initialUsername ?? '';
    return SignUpState(fullName: initialName);
  }

  @override
  FutureOr<void> onIntent(SignUpIntent intent) {
    return intent.when<FutureOr<void>>(
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
        param: SignupRequestModel(userName: state.fullName, email: state.email, password: state.password),
      ),
      showLoading: true,
      onSuccess: (_) {
        emitEffect(MessageEffect(I18nKeys.registrationSuccess.tr));
        emitEffect(NavigationEffect.back(result: true));
      },
    );
  }
}
