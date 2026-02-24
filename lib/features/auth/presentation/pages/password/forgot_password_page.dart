import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

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

  // Handle password reset request
  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      CommonToast.show('${I18nKeys.resetLinkSent.tr} ${_emailController.text}');
      // Return to previous screen
      AppNav.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      isEmptyTitle: true,
      body: (context, child) => Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.f),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.f),
              CommonText(
                I18nKeys.forgotPassword.tr,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.isDark ? Colors.white : Colors.black87,
                ),
                maxLines: 1,
              ),
              SizedBox(height: 12.f),
              CommonText(
                I18nKeys.forgotPasswordSubtitle.tr,
                style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5),
                maxLines: 2,
              ),
              SizedBox(height: 48.f),
              // Email Input Field
              CommonTextField(
                controller: _emailController,
                type: TextFieldType.email,
                labelText: I18nKeys.emailAddress.tr,
                prefixIcon: Icons.email_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return I18nKeys.invalidEmail.tr;
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.f),
              // Main Action Button
              CommonButton(
                text: I18nKeys.sendResetLink.tr,
                onPressed: _handleResetPassword,
                borderRadius: 15,
                height: 56,
              ),
              SizedBox(height: 40.f),
              // Footer link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: CommonText(
                      I18nKeys.rememberPassword.tr,
                      style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width: 8.f),
                  CommonButton(
                    text: I18nKeys.loginLink.tr,
                    type: ButtonType.text,
                    isFullWidth: false,
                    padding: EdgeInsets.zero,
                    fontSize: 14.f,
                    onPressed: () => AppNav.back(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
