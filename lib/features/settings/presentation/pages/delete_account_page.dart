import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_page.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_dialog.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_toast.dart';

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
          AppNav.off(const LoginPage());
          CommonToast.show(I18nKeys.deleteAccountSuccess.tr, type: ToastType.error);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseStatelessPage(
      title: I18nKeys.deleteAccount.tr,
      padding: EdgeInsets.all(24.f),
      body: (context, child) => Column(
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
                  Text(
                    I18nKeys.deleteAccountConfirmContent.tr,
                    style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.6),
                  ),
                  SizedBox(height: 32.f),
                  _buildWarningItem(I18nKeys.deleteAccountWarningDataWiped.tr),
                  _buildWarningItem(I18nKeys.deleteAccountWarningIrreversible.tr),
                  _buildWarningItem(I18nKeys.deleteAccountWarningSubscriptions.tr),
                ],
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 24.f,
                height: 24.f,
                child: Checkbox(
                  value: _isConfirmed,
                  onChanged: (val) => setState(() => _isConfirmed = val ?? false),
                  activeColor: Colors.red,
                ),
              ),
              SizedBox(width: 12.f),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isConfirmed = !_isConfirmed),
                  child: Text(I18nKeys.deleteAccountIUnderstand.tr, style: context.textTheme.bodySmall),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.f),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isConfirmed ? _handleDeleteAccount : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.f),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.f)),
                elevation: 0,
              ),
              child: Text(I18nKeys.deleteAccount.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
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
          Icon(Icons.circle, size: 6.f, color: Colors.grey),
          SizedBox(width: 12.f),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
