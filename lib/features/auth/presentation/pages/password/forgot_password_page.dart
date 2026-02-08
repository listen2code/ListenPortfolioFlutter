import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword(Color accentColor) {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${I18nKeys.resetLinkSent.tr} ${_emailController.text}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: accentColor,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = settingManager.accentColor;

    return BaseStatelessPage(
      title: '', // Shows AppBar with back button but no title text
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              I18nKeys.forgotPassword.tr,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.brightness == Brightness.light ? Colors.black87 : Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              I18nKeys.forgotPasswordSubtitle.tr,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 48),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: I18nKeys.emailAddress.tr,
                prefixIcon: Icon(Icons.email_outlined, color: accentColor),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return I18nKeys.invalidEmail.tr;
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(colors: [accentColor, accentColor.withValues(alpha: 0.8)]),
                boxShadow: [
                  BoxShadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => _handleResetPassword(accentColor),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  I18nKeys.sendResetLink.tr,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(I18nKeys.rememberPassword.tr, style: const TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    I18nKeys.loginLink.tr,
                    style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
