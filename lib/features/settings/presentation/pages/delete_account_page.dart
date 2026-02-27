import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool _isConfirmed = false;

  // Cleanup session and notify user after double confirmation
  void _handleDeleteAccount() {
    if (!_isConfirmed) return;

    CommonDialog.showConfirm(
      title: I18nKeys.deleteAccountConfirmTitle.tr,
      message: I18nKeys.deleteAccountConfirmContent.tr,
      okText: I18nKeys.deleteAccount.tr,
      okColor: Colors.red,
    ).then((confirmed) async {
      if (confirmed == true) {
        // Reset all global and local settings
        await settingManager.resetSettings();

        if (mounted) {
          // Clear user session and force logout
          authManager.logout();

          // Redirect to login page
          AppNav.off(Routes.login);
          CommonToast.show(I18nKeys.deleteAccountSuccess.tr, type: ToastType.error);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: I18nKeys.deleteAccount.tr,
      padding: EdgeInsets.all(24.f),
      body: (context, child, viewModel) => Column(
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
                  _buildWarningItem(I18nKeys.deleteAccountWarningDataWiped.tr),
                  _buildWarningItem(I18nKeys.deleteAccountWarningIrreversible.tr),
                  _buildWarningItem(I18nKeys.deleteAccountWarningSubscriptions.tr),
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
                    value: _isConfirmed,
                    onChanged: (val) => setState(() => _isConfirmed = val ?? false),
                    activeColor: Colors.red,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
              SizedBox(width: 12.f),
              Expanded(
                child: CommonButton(
                  text: I18nKeys.deleteAccountIUnderstand.tr,
                  type: ButtonType.text,
                  isFullWidth: false,
                  padding: EdgeInsets.zero,
                  foregroundColor: context.isDark ? Colors.white70 : Colors.black87,
                  fontSize: 13.f,
                  onPressed: () => setState(() => _isConfirmed = !_isConfirmed),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.f),
          CommonButton(
            text: I18nKeys.deleteAccount.tr,
            onPressed: _isConfirmed ? _handleDeleteAccount : null,
            backgroundColor: Colors.red,
            borderRadius: 12.f,
            height: 56.f,
          ),
          SizedBox(height: 20.f),
        ],
      ),
    );
  }

  Widget _buildWarningItem(String text) {
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
