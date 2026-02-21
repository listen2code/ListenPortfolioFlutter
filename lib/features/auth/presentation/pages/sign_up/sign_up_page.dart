import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

class SignUpPage extends StatefulWidget {
  final Map<String, dynamic>? args;

  const SignUpPage({super.key, this.args});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Elegant parameter retrieval using AppNav static helper
    final String initialName = AppNav.getParam<String>(Routes.argName) ?? '';
    _nameController = TextEditingController(text: initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _pwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  void _handleSignUp(Color accentColor) {
    if (_formKey.currentState!.validate()) {
      CommonToast.show(I18nKeys.registrationSuccess.tr);
      AppNav.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = context.accentColor;

    return BaseStatelessPage(
      isEmptyTitle: true,
      body: (context, child) => SingleChildScrollView(
        padding: const EdgeInsets.all(20), // Stable layout padding
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              CommonText(
                I18nKeys.createAccount.tr,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w300,
                  color: context.isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                I18nKeys.signUpSubtitle.tr,
                style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              CommonTextField(
                controller: _nameController,
                labelText: I18nKeys.fullName.tr,
                prefixIcon: Icons.person_outline,
                validator: (value) => value!.isEmpty ? I18nKeys.fieldRequired.tr : null,
              ),
              const SizedBox(height: 20),
              CommonTextField(
                controller: _emailController,
                type: TextFieldType.email,
                labelText: I18nKeys.email.tr,
                prefixIcon: Icons.email_outlined,
                validator: (value) => value!.isEmpty ? I18nKeys.fieldRequired.tr : null,
              ),
              const SizedBox(height: 20),
              CommonTextField(
                controller: _pwdController,
                type: TextFieldType.password,
                labelText: I18nKeys.password.tr,
                prefixIcon: Icons.lock_outline,
                validator: (value) => value!.isEmpty ? I18nKeys.fieldRequired.tr : null,
              ),
              const SizedBox(height: 20),
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
              _buildSignUpButton(accentColor),
              const SizedBox(height: 30),
              _buildLoginLink(accentColor),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(colors: [accentColor, accentColor.withValues(alpha: 0.8)]),
        boxShadow: [
          BoxShadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5)),
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
        child: CommonText(
          I18nKeys.signUp.tr,
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLoginLink(Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: CommonText(
            I18nKeys.alreadyHaveAccount.tr,
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () => AppNav.back(),
          child: CommonText(
            I18nKeys.loginLink.tr,
            style: context.textTheme.bodyMedium?.copyWith(color: accentColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
