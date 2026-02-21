import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

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
  void _handleChangePassword() {
    if (_formKey.currentState!.validate()) {
      CommonToast.show(I18nKeys.passwordChangedSuccess.tr);
      AppNav.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = context.accentColor;

    return BaseStatelessPage(
      isEmptyTitle: true,
      body: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.f),
                Text(
                  I18nKeys.changePassword.tr,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 12.f),
                Text(
                  I18nKeys.changePasswordSubtitle.tr,
                  style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5),
                ),
                SizedBox(height: 40.f),
                // Current Password Field
                CommonTextField(
                  controller: _oldPasswordController,
                  type: TextFieldType.password,
                  labelText: I18nKeys.oldPassword.tr,
                  prefixIcon: Icons.lock_outline,
                  validator: (value) => value!.isEmpty ? I18nKeys.requiredField.tr : null,
                ),
                SizedBox(height: 20.f),
                // New Password Field
                CommonTextField(
                  controller: _newPasswordController,
                  type: TextFieldType.password,
                  labelText: I18nKeys.newPassword.tr,
                  prefixIcon: Icons.lock_outline,
                  validator: (value) => value!.isEmpty ? I18nKeys.requiredField.tr : null,
                ),
                SizedBox(height: 20.f),
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
                SizedBox(height: 40.f),
                _buildUpdateButton(accentColor),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpdateButton(Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.f),
        gradient: LinearGradient(colors: [accentColor, accentColor.withValues(alpha: 0.8)]),
        boxShadow: [
          BoxShadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 10.f, offset: Offset(0, 5.f)),
        ],
      ),
      child: ElevatedButton(
        onPressed: _handleChangePassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 18.f),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.f)),
        ),
        child: CommonText(
          I18nKeys.updatePassword.tr,
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
