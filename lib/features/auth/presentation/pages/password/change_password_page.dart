import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';

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
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword(Color accentColor) {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(I18nKeys.passwordChangedSuccess.tr),
          behavior: SnackBarBehavior.floating,
          backgroundColor: accentColor,
        ),
      );
      Navigator.of(context).pop();
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
                _buildPasswordField(
                  controller: _oldPasswordController,
                  label: I18nKeys.oldPassword.tr,
                  obscureText: _obscureOld,
                  accentColor: accentColor,
                  onToggle: () => setState(() => _obscureOld = !_obscureOld),
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: _newPasswordController,
                  label: I18nKeys.newPassword.tr,
                  obscureText: _obscureNew,
                  accentColor: accentColor,
                  onToggle: () => setState(() => _obscureNew = !_obscureNew),
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: I18nKeys.confirmNewPassword.tr,
                  obscureText: _obscureConfirm,
                  accentColor: accentColor,
                  onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
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
                    boxShadow: [BoxShadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required Color accentColor,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.lock_outline, color: accentColor),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: accentColor),
          onPressed: onToggle,
        ),
      ),
      validator: validator ?? (value) => value!.isEmpty ? I18nKeys.requiredField.tr : null,
    );
  }
}
