import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';

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
  bool _isPasswordVisible = false;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(I18nKeys.registrationSuccess.tr),
          behavior: SnackBarBehavior.floating,
          backgroundColor: accentColor,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingManager,
      builder: (context, child) {
        final theme = Theme.of(context);
        final accentColor = settingManager.accentColor;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: theme.brightness == Brightness.light ? Colors.black87 : Colors.white,
          ),
          body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor.withValues(alpha: 0.05), theme.scaffoldBackgroundColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        I18nKeys.createAccount.tr,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w300,
                          color: theme.brightness == Brightness.light ? Colors.black87 : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        I18nKeys.signUpSubtitle.tr,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 40),
                      _buildTextField(
                        controller: _nameController,
                        hintText: I18nKeys.fullName.tr,
                        icon: Icons.person_outline,
                        accentColor: accentColor,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _emailController,
                        hintText: I18nKeys.email.tr,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        accentColor: accentColor,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _pwdController,
                        hintText: I18nKeys.password.tr,
                        icon: Icons.lock_outline,
                        obscureText: !_isPasswordVisible,
                        accentColor: accentColor,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: accentColor,
                          ),
                          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _confirmPwdController,
                        hintText: I18nKeys.confirmPassword.tr,
                        icon: Icons.lock_outline,
                        accentColor: accentColor,
                        obscureText: !_isPasswordVisible,
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
                          Text(I18nKeys.alreadyHaveAccount.tr, style: const TextStyle(color: Colors.grey)),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              I18nKeys.loginLink.tr,
                              style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required Color accentColor,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: accentColor),
        suffixIcon: suffixIcon,
      ),
      validator: (value) => value!.isEmpty ? I18nKeys.fieldRequired.tr : null,
    );
  }
}
