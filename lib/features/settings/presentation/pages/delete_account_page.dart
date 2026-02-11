import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_page.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/shared/utils/snack_bar_util.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_dialog.dart';

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
      okText: I18nKeys.reset.tr,
      okColor: Colors.red,
    ).then((confirmed) async {
      if (confirmed == true) {
        // Reset all global and local settings
        await settingManager.resetSettings();

        if (mounted) {
          authManager.logout();
          // Redirect to login and show success message
          AppNav.off(const LoginPage());
          SnackBarUtil.show(I18nKeys.deleteAccountSuccess.tr);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseStatelessPage(
      title: I18nKeys.deleteAccount.tr,
      padding: const EdgeInsets.all(24),
      body: (context, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, size: 64, color: Colors.red),
          const SizedBox(height: 24),
          CommonText(
            I18nKeys.deleteAccountConfirmTitle.tr,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          Text(
            I18nKeys.deleteAccountConfirmContent.tr,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.6),
          ),
          const SizedBox(height: 32),
          _buildWarningItem('All your personal data will be wiped.'),
          _buildWarningItem('Account cannot be recovered.'),
          _buildWarningItem('Active subscriptions will be canceled.'),
          const Spacer(),
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _isConfirmed,
                  onChanged: (val) => setState(() => _isConfirmed = val ?? false),
                  activeColor: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isConfirmed = !_isConfirmed),
                  child: Text('I understand the consequences.', style: theme.textTheme.bodySmall),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isConfirmed ? _handleDeleteAccount : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(I18nKeys.reset.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWarningItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
