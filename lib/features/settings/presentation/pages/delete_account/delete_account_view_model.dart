import 'dart:async';

import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/delete_account_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
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
    return intent.when<FutureOr<void>>(toggleConfirm: _onToggleConfirm, deleteAccount: _onDeleteAccount);
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
      await call<void>(
        ref.execute(
          deleteAccountUseCaseProvider,
          param: DeleteAccountRequestModel(userId: authManager.state.user?.id ?? ""),
        ),
        showLoading: true,
        onSuccess: (_) async {
          // 1. First reset settings
          await settingManager.resetSettings();

          // 2. Then clear session
          authManager.logout();

          // 3. Show success message and redirect to login
          emitEffect(MessageEffect.info(I18nKeys.deleteAccountSuccess.tr));
          emitEffect(NavigationEffect(target: Routes.login, isReplace: true));
        },
        onFailure: (failure) async {
          // Handle deletion error - user stays logged in
          emitEffect(MessageEffect.error(I18nKeys.deleteAccountFailed.tr));
        },
      );
    }
  }
}
