import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';
import 'delete_account_intent.dart';
import 'delete_account_state.dart';
import 'delete_account_view_model.dart';
import 'widgets/delete_account_confirm_actions.dart';
import 'widgets/delete_account_warning_list.dart';

class DeleteAccountPage extends ConsumerWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRefreshPage<DeleteAccountViewModel, DeleteAccountState>(
      title: I18nKeys.deleteAccount.tr,
      provider: deleteAccountViewModelProvider,
      padding: EdgeInsets.all(24.f),
      body: (context, child, viewModel, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 64.f, color: Colors.red),
                    SizedBox(height: 24.f),
                    CommonText(
                      I18nKeys.deleteAccountConfirmTitle.tr,
                      style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                    SizedBox(height: 16.f),
                    CommonText(
                      I18nKeys.deleteAccountConfirmContent.tr,
                      style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.6),
                      useFittedBox: false,
                    ),
                    SizedBox(height: 32.f),
                    DeleteAccountWarningList(
                      warnings: [
                        I18nKeys.deleteAccountWarningDataWiped.tr,
                        I18nKeys.deleteAccountWarningIrreversible.tr,
                        I18nKeys.deleteAccountWarningSubscriptions.tr,
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.f),
            DeleteAccountConfirmActions(
              isConfirmed: state.isConfirmed,
              onToggleConfirm: () => viewModel.handleIntent(const DeleteAccountIntent.toggleConfirm()),
              onDeleteAccount: () => viewModel.handleIntent(const DeleteAccountIntent.deleteAccount()),
            ),
            SizedBox(height: 20.f),
          ],
        );
      },
    );
  }
}
