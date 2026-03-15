import 'dart:async';

import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/forgot_password_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_state.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'forgot_password_view_model.g.dart';

@riverpod
class ForgotPasswordViewModel extends _$ForgotPasswordViewModel
    with ViewModelMixin<ForgotPasswordState, ForgotPasswordIntent> {
  @override
  ForgotPasswordState build() => const ForgotPasswordState();

  @override
  FutureOr<void> onIntent(ForgotPasswordIntent intent) {
    return intent.when<FutureOr<void>>(
      emailChanged: (email) => updateState(state.copyWith(email: email, emailError: null)),
      submitReset: _onSubmitReset,
      navigateToLogin: () => emitEffect(NavigationEffect.back()),
    );
  }

  Future<void> _onSubmitReset() async {
    // 1. Level 1 UI Validation
    final emailError = Validators.validateEmail(
      state.email,
      requiredMsg: I18nKeys.fieldRequired.tr,
      invalidMsg: I18nKeys.invalidEmail.tr,
    );

    if (emailError != null) {
      updateState(state.copyWith(emailError: emailError));
      return;
    }

    // 2. Real Reset Link Request via UseCase
    await call<void>(
      ref.execute(forgotPasswordUseCaseProvider, ForgotPasswordRequestModel(email: state.email)),
      showLoading: true,
      onSuccess: (_) {
        // Show success message and go back to login
        emitEffect(MessageEffect('${I18nKeys.resetLinkSent.tr} ${state.email}'));
        emitEffect(NavigationEffect.back());
      },
    );
  }
}
