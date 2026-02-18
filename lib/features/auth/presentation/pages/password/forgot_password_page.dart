import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_toast.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_text_field.dart';

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
  void _handleResetPassword(Color accentColor) {
    if (_formKey.currentState!.validate()) {
      CommonToast.show('${I18nKeys.resetLinkSent.tr} ${_emailController.text}');
      // Return to previous screen
      AppNav.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = context.accentColor;

    return BaseStatelessPage(
      isEmptyTitle: true,
      body: (context, child) => Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
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
              Text(
                I18nKeys.forgotPasswordSubtitle.tr,
                style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5),
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.f),
                  gradient: LinearGradient(colors: [accentColor, accentColor.withValues(alpha: 0.8)]),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.3),
                      blurRadius: 10.f,
                      offset: Offset(0, 5.f),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => _handleResetPassword(accentColor),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 18.f),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.f)),
                  ),
                  child: CommonText(
                    I18nKeys.sendResetLink.tr,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.f),
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
                  TextButton(
                    onPressed: () => AppNav.back(),
                    child: CommonText(
                      I18nKeys.loginLink.tr,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
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
