import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_toast.dart';
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
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.f),
              CommonText(
                I18nKeys.createAccount.tr,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w300,
                  color: context.isDark ? Colors.white : Colors.black87,
                ),
                maxLines: 1,
              ),
              SizedBox(height: 10.f),
              Text(
                I18nKeys.signUpSubtitle.tr,
                style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              SizedBox(height: 40.f),
              CommonTextField(
                controller: _nameController,
                labelText: I18nKeys.fullName.tr,
                prefixIcon: Icons.person_outline,
                validator: (value) => value!.isEmpty ? I18nKeys.fieldRequired.tr : null,
              ),
              SizedBox(height: 20.f),
              CommonTextField(
                controller: _emailController,
                type: TextFieldType.email,
                labelText: I18nKeys.email.tr,
                prefixIcon: Icons.email_outlined,
                validator: (value) => value!.isEmpty ? I18nKeys.fieldRequired.tr : null,
              ),
              SizedBox(height: 20.f),
              CommonTextField(
                controller: _pwdController,
                type: TextFieldType.password,
                labelText: I18nKeys.password.tr,
                prefixIcon: Icons.lock_outline,
                validator: (value) => value!.isEmpty ? I18nKeys.fieldRequired.tr : null,
              ),
              SizedBox(height: 20.f),
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
              SizedBox(height: 40.f),
              _buildSignUpButton(accentColor),
              SizedBox(height: 30.f),
              _buildLoginLink(accentColor),
              SizedBox(height: 40.f),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.f),
        gradient: LinearGradient(colors: [accentColor, accentColor.withValues(alpha: 0.8)]),
        boxShadow: [
          BoxShadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 10.f, offset: Offset(0, 5.f)),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _handleSignUp(accentColor),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 18.f),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.f)),
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
            maxLines: 1,
          ),
        ),
        TextButton(
          onPressed: () => AppNav.back(),
          child: CommonText(
            I18nKeys.loginLink.tr,
            style: context.textTheme.bodyMedium?.copyWith(color: accentColor, fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
