import 'dart:async';

import 'package:listen_core/core.dart';
import '../../../data/models/change_password_request_model.dart';
import 'change_password_intent.dart';
import 'change_password_state.dart';
import '../../provider/auth_provider.dart';
import '../../../../../shared/shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password_view_model.g.dart';

@riverpod
class ChangePasswordViewModel extends _$ChangePasswordViewModel
    with ViewModelMixin<ChangePasswordState, ChangePasswordIntent> {
  @override
  ChangePasswordState build() => const ChangePasswordState();

  @override
  FutureOr<void> onIntent(ChangePasswordIntent intent) {
    return intent.when<FutureOr<void>>(
      oldPasswordChanged: (pwd) => updateState(state.copyWith(oldPassword: pwd, oldPasswordError: null)),
      newPasswordChanged: (pwd) => updateState(state.copyWith(newPassword: pwd, newPasswordError: null)),
      confirmPasswordChanged: (pwd) =>
          updateState(state.copyWith(confirmPassword: pwd, confirmPasswordError: null)),
      submitChange: _onSubmitChange,
    );
  }

  Future<void> _onSubmitChange() async {
    // 1. Level 1 UI Validation
    final oldPasswordError = state.oldPassword.isEmpty ? I18nKeys.fieldRequired.tr : null;
    final newPasswordError = Validators.validatePassword(
      state.newPassword,
      requiredMsg: I18nKeys.fieldRequired.tr,
      minLengthMsg: I18nKeys.minLengthMsg.trArgs(['6']),
    );

    String? confirmPasswordError;
    if (state.confirmPassword.isEmpty) {
      confirmPasswordError = I18nKeys.fieldRequired.tr;
    } else if (state.confirmPassword != state.newPassword) {
      confirmPasswordError = I18nKeys.passwordsDoNotMatch.tr;
    }

    if (oldPasswordError != null || newPasswordError != null || confirmPasswordError != null) {
      updateState(
        state.copyWith(
          oldPasswordError: oldPasswordError,
          newPasswordError: newPasswordError,
          confirmPasswordError: confirmPasswordError,
        ),
      );
      return;
    }

    // 2. Real Password Update via UseCase
    await call<void>(
      ref.execute(
        changePasswordUseCaseProvider,
        param: ChangePasswordRequestModel(
          userId: authManager.state.user?.id ?? '',
          oldPassword: state.oldPassword,
          newPassword: state.newPassword,
        ),
      ),
      showLoading: true,
      onSuccess: (_) {
        // Show success and navigate back
        emitEffect(LogoutEffect(message: I18nKeys.passwordChangedSuccess.tr));
      },
    );
  }
}
