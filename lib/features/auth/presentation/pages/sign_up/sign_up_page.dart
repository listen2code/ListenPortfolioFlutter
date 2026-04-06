import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'sign_up_intent.dart';
import 'sign_up_state.dart';
import 'sign_up_view_model.dart';
import '../../../../../shared/shared.dart';
import 'package:listen_uikit/uikit.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  // Controllers are kept to maintain cursor position and text selection during reactive updates
  late final TextEditingController _nameController;
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initialState = ref.read(signUpViewModelProvider);
    _nameController = TextEditingController(text: initialState.fullName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _pwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseRefreshPage<SignUpViewModel, SignUpState>(
      isEmptyTitle: true,
      provider: signUpViewModelProvider,
      body: (context, child, viewModel, state) => SingleChildScrollView(
        padding: EdgeInsets.all(20.f),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            // Full Name Input
            CommonTextField(
              controller: _nameController,
              labelText: I18nKeys.fullName.tr,
              prefixIcon: Icons.person_outline,
              errorText: state?.fullNameError,
              onChanged: (val) => viewModel?.handleIntent(SignUpIntent.fullNameChanged(val)),
            ),
            SizedBox(height: 20.f),
            // Email Input
            CommonTextField(
              controller: _emailController,
              type: TextFieldType.email,
              labelText: I18nKeys.email.tr,
              prefixIcon: Icons.email_outlined,
              errorText: state?.emailError,
              onChanged: (val) => viewModel?.handleIntent(SignUpIntent.emailChanged(val)),
            ),
            SizedBox(height: 20.f),
            // Password Input
            CommonTextField(
              controller: _pwdController,
              type: TextFieldType.password,
              labelText: I18nKeys.password.tr,
              prefixIcon: Icons.lock_outline,
              errorText: state?.passwordError,
              onChanged: (val) => viewModel?.handleIntent(SignUpIntent.passwordChanged(val)),
            ),
            SizedBox(height: 20.f),
            // Confirm Password Input
            CommonTextField(
              controller: _confirmPwdController,
              type: TextFieldType.password,
              labelText: I18nKeys.confirmPassword.tr,
              prefixIcon: Icons.lock_outline,
              errorText: state?.confirmPasswordError,
              onChanged: (val) => viewModel?.handleIntent(SignUpIntent.confirmPasswordChanged(val)),
            ),
            SizedBox(height: 40.f),
            // Main Sign Up Action
            CommonButton(
              text: I18nKeys.signUp.tr,
              onPressed: () => viewModel?.handleIntent(const SignUpIntent.submitSignUp()),
              borderRadius: 15,
              height: 56.f,
            ),
            SizedBox(height: 30.f),
            // Back to Login Link
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
                  onPressed: () => viewModel?.handleIntent(const SignUpIntent.navigateToLogin()),
                ),
              ],
            ),
            SizedBox(height: 40.f),
          ],
        ),
      ),
    );
  }
}
