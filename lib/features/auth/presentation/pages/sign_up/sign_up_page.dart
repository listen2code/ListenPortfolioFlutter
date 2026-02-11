import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/shared/utils/snack_bar_util.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _pwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  // Handle registration logic
  void _handleSignUp(Color accentColor) {
    if (_formKey.currentState!.validate()) {
      SnackBarUtil.show(I18nKeys.registrationSuccess.tr);
      // Return to login screen
      AppNav.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = settingManager.accentColor;

    return BaseStatelessPage(
      isEmptyTitle: true,
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      body: (context, child) => SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              CommonText(
                I18nKeys.createAccount.tr,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w300,
                  color: theme.brightness == Brightness.light ? Colors.black87 : Colors.white,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 10),
              Text(
                I18nKeys.signUpSubtitle.tr,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              // Name Field
              CommonTextField(
                controller: _nameController,
                labelText: I18nKeys.fullName.tr,
                prefixIcon: Icons.person_outline,
                validator: (value) => value!.isEmpty ? I18nKeys.fieldRequired.tr : null,
              ),
              const SizedBox(height: 20),
              // Email Field
              CommonTextField(
                controller: _emailController,
                type: TextFieldType.email,
                labelText: I18nKeys.email.tr,
                prefixIcon: Icons.email_outlined,
                validator: (value) => value!.isEmpty ? I18nKeys.fieldRequired.tr : null,
              ),
              const SizedBox(height: 20),
              // Password Field
              CommonTextField(
                controller: _pwdController,
                type: TextFieldType.password,
                labelText: I18nKeys.password.tr,
                prefixIcon: Icons.lock_outline,
                validator: (value) => value!.isEmpty ? I18nKeys.fieldRequired.tr : null,
              ),
              const SizedBox(height: 20),
              // Confirm Password Field
              CommonTextField(
                controller: _confirmPwdController,
                type: TextFieldType.password,
                labelText: I18nKeys.confirmPassword.tr,
                prefixIcon: Icons.lock_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) return I18nKeys.fieldRequired.tr;
                  if (value != _pwdController.text) return I18nKeys.passwordsDoNotMatch.tr;
                  return null;
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
                  onPressed: () => _handleSignUp(accentColor),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    I18nKeys.signUp.tr,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: CommonText(I18nKeys.alreadyHaveAccount.tr, style: const TextStyle(color: Colors.grey), maxLines: 1),
                  ),
                  TextButton(
                    onPressed: () => AppNav.back(),
                    child: CommonText(
                      I18nKeys.loginLink.tr,
                      style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
