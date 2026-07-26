import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../shared/shared.dart';
import '../../../../auth/data/models/delete_account_request_model.dart';
import '../../../../auth/presentation/provider/auth_provider.dart';
import 'delete_account_intent.dart';
import 'delete_account_state.dart';

part 'delete_account_view_model.g.dart';

@riverpod
class DeleteAccountViewModel extends _$DeleteAccountViewModel
    with ViewModelMixin<DeleteAccountState, DeleteAccountIntent> {
  @override
  DeleteAccountState build() => const DeleteAccountState();

  @override
  FutureOr<void> onIntent(DeleteAccountIntent intent) {
    return intent.when<FutureOr<void>>(
      toggleConfirm: _onToggleConfirm,
      deleteAccount: _onDeleteAccount,
      confirmDelete: _onConfirmDelete,
    );
  }

  void _onToggleConfirm() {
    updateState(state.copyWith(isConfirmed: !state.isConfirmed));
  }

  Future<void> _onDeleteAccount() async {
    if (!state.isConfirmed) return;

    emitEffect(
      ConfirmEffect(
        title: I18nKeys.deleteAccountConfirmTitle.tr,
        message: I18nKeys.deleteAccountConfirmContent.tr,
        okText: I18nKeys.deleteAccount.tr,
        okColor: Colors.red,
        onResult: (confirmed) async {
          if (confirmed) {
            handleIntent(const DeleteAccountIntent.confirmDelete());
          }
        },
      ),
    );
  }

  Future<void> _onConfirmDelete() async {
    await call<void>(
      ref.execute<void, DeleteAccountRequestModel>(
        deleteAccountUseCaseProvider,
        param: DeleteAccountRequestModel(userId: authManager.state.user?.id ?? ''),
      ),
      showLoading: true,
      onSuccess: (_) async {
        // 1. First reset settings
        await settingManager.resetSettings();

        // 2. Then clear session
        authManager.logout();

        // 3. Show success message and redirect to login
        emitEffect(MessageEffect.info(I18nKeys.deleteAccountSuccess.tr));
        emitEffect(NavigationEffect<void>(target: Routes.login, isReplace: true));
      },
      onFailure: (failure) async {
        // Handle deletion error - user stays logged in
        emitEffect(MessageEffect.error(I18nKeys.deleteAccountFailed.tr));
      },
    );
  }
}
