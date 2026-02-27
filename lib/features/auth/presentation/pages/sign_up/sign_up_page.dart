import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

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
    // Safe and clean parameter retrieval via global route snapshot
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

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      CommonToast.show(I18nKeys.registrationSuccess.tr);
      AppNav.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = context.accentColor;

    return BasePage(
      isEmptyTitle: true,
      body: (context, child, viewModel) => SingleChildScrollView(
        padding: EdgeInsets.all(20.f),
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
              ),
              SizedBox(height: 10.f),
              CommonText(
                I18nKeys.signUpSubtitle.tr,
                style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                maxLines: 2,
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
              // Main Sign Up Button
              CommonButton(
                text: I18nKeys.signUp.tr,
                onPressed: _handleSignUp,
                borderRadius: 15,
                height: 56.f,
              ),
              SizedBox(height: 30.f),
              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: CommonText(
                      I18nKeys.alreadyHaveAccount.tr,
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
              SizedBox(height: 40.f),
            ],
          ),
        ),
      ),
    );
  }
}
