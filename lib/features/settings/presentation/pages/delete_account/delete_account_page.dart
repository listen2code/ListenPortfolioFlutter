import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

import 'delete_account_intent.dart';
import 'delete_account_state.dart';
import 'delete_account_view_model.dart';

class DeleteAccountPage extends ConsumerWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRefreshPage<DeleteAccountViewModel, DeleteAccountState>(
      title: I18nKeys.deleteAccount.tr,
      provider: deleteAccountViewModelProvider,
      padding: EdgeInsets.all(24.f),
      body: (context, child, viewModel, state) {
        if (state == null) return const SizedBox.shrink();

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
                    _buildWarningItem(context, I18nKeys.deleteAccountWarningDataWiped.tr),
                    _buildWarningItem(context, I18nKeys.deleteAccountWarningIrreversible.tr),
                    _buildWarningItem(context, I18nKeys.deleteAccountWarningSubscriptions.tr),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.f),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(0, 1.f),
                  child: SizedBox(
                    width: 24.f,
                    height: 24.f,
                    child: Checkbox(
                      value: state.isConfirmed,
                      onChanged: (val) => viewModel?.handleIntent(const DeleteAccountIntent.toggleConfirm()),
                      activeColor: Colors.red,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
                SizedBox(width: 12.f),
                CommonButton(
                  text: I18nKeys.deleteAccountIUnderstand.tr,
                  type: ButtonType.text,
                  isFullWidth: false,
                  padding: EdgeInsets.zero,
                  foregroundColor: context.isDark ? Colors.white70 : Colors.black87,
                  fontSize: 13.f,
                  onPressed: () => viewModel?.handleIntent(const DeleteAccountIntent.toggleConfirm()),
                ),
              ],
            ),
            SizedBox(height: 24.f),
            CommonButton(
              text: I18nKeys.deleteAccount.tr,
              onPressed: state.isConfirmed
                  ? () => viewModel?.handleIntent(const DeleteAccountIntent.deleteAccount())
                  : null,
              backgroundColor: Colors.red,
              borderRadius: 12.f,
              height: 56.f,
            ),
            SizedBox(height: 20.f),
          ],
        );
      },
    );
  }

  Widget _buildWarningItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.f),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.f),
            child: Icon(Icons.circle, size: 6.f, color: Colors.grey),
          ),
          SizedBox(width: 12.f),
          Expanded(
            child: CommonText(
              text,
              style: context.textTheme.bodySmall?.copyWith(color: Colors.grey, height: 1.4),
              useFittedBox: false,
            ),
          ),
        ],
      ),
    );
  }
}
