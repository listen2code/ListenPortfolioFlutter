import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_page.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/shared/i18n/translations_key.dart';
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
    return BasePage(
      isEmptyTitle: true,
      body: (context, child) => SingleChildScrollView(
        padding: EdgeInsets.all(20.f),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.f),
              CommonText(
                I18nKeys.changePassword.tr,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.isDark ? Colors.white : Colors.black87,
                ),
                maxLines: 1,
              ),
              SizedBox(height: 12.f),
              CommonText(
                I18nKeys.changePasswordSubtitle.tr,
                style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5),
                maxLines: 2,
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
              // Update Button
              CommonButton(
                text: I18nKeys.updatePassword.tr,
                onPressed: _handleChangePassword,
                borderRadius: 15,
                height: 56.f,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
