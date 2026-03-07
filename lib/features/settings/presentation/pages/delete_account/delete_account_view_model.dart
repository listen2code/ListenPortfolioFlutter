import 'dart:async';
import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/widgets/common_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
    intent.when(toggleConfirm: _onToggleConfirm, deleteAccount: _onDeleteAccount);
  }

  void _onToggleConfirm() {
    updateState(state.copyWith(isConfirmed: !state.isConfirmed));
  }

  Future<void> _onDeleteAccount() async {
    if (!state.isConfirmed) return;

    final confirmed = await CommonDialog.showConfirm(
      title: I18nKeys.deleteAccountConfirmTitle.tr,
      message: I18nKeys.deleteAccountConfirmContent.tr,
      okText: I18nKeys.deleteAccount.tr,
      okColor: Colors.red,
    );

    if (confirmed == true) {
      emitEffect(LoadingEffect(true));
      try {
        // 1. Reset settings
        await settingManager.resetSettings();

        // 2. Clear session
        authManager.logout();

        // 3. Success effect and redirect
        emitEffect(MessageEffect.info(I18nKeys.deleteAccountSuccess.tr));
        emitEffect(NavigationEffect(target: Routes.login, isReplace: true));
      } finally {
        emitEffect(LoadingEffect(false));
      }
    }
  }
}
