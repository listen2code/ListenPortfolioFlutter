import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/shared/utils/snack_bar_util.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_text_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Handle password update logic
  void _handleChangePassword(Color accentColor) {
    if (_formKey.currentState!.validate()) {
      SnackBarUtil.show(I18nKeys.passwordChangedSuccess.tr);
      AppNav.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseStatelessPage(
      isEmptyTitle: true,
      padding: const EdgeInsets.all(24.0),
      body: (context, child) {
        final theme = Theme.of(context);
        final accentColor = settingManager.accentColor;
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  I18nKeys.changePassword.tr,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.brightness == Brightness.light ? Colors.black87 : Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  I18nKeys.changePasswordSubtitle.tr,
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5),
                ),
                const SizedBox(height: 40),
                // Current Password Field
                CommonTextField(
                  controller: _oldPasswordController,
                  type: TextFieldType.password,
                  labelText: I18nKeys.oldPassword.tr,
                  prefixIcon: Icons.lock_outline,
                  validator: (value) => value!.isEmpty ? I18nKeys.requiredField.tr : null,
                ),
                const SizedBox(height: 20),
                // New Password Field
                CommonTextField(
                  controller: _newPasswordController,
                  type: TextFieldType.password,
                  labelText: I18nKeys.newPassword.tr,
                  prefixIcon: Icons.lock_outline,
                  validator: (value) => value!.isEmpty ? I18nKeys.requiredField.tr : null,
                ),
                const SizedBox(height: 20),
                // Confirm New Password Field
                CommonTextField(
                  controller: _confirmPasswordController,
                  type: TextFieldType.password,
                  labelText: I18nKeys.confirmNewPassword.tr,
                  prefixIcon: Icons.lock_outline,
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return I18nKeys.passwordsDoNotMatch.tr;
                    }
                    return value!.isEmpty ? I18nKeys.pleaseConfirmPassword.tr : null;
                  },
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(colors: [accentColor, accentColor.withValues(alpha: 0.8)]),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => _handleChangePassword(accentColor),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text(
                      I18nKeys.updatePassword.tr,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
