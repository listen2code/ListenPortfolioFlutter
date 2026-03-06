import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_state.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_view_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseRefreshPage<ForgotPasswordViewModel, ForgotPasswordState>(
      isEmptyTitle: true,
      provider: forgotPasswordViewModelProvider,
      body: (context, child, viewModel, state) => SingleChildScrollView(
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
            // Reactive Email Input
            CommonTextField(
              controller: _emailController,
              type: TextFieldType.email,
              labelText: I18nKeys.emailAddress.tr,
              prefixIcon: Icons.email_outlined,
              errorText: state?.emailError,
              onChanged: (val) => viewModel?.handleIntent(ForgotPasswordIntent.emailChanged(val)),
            ),
            SizedBox(height: 32.f),
            // Submit Action
            CommonButton(
              text: I18nKeys.sendResetLink.tr,
              onPressed: () => viewModel?.handleIntent(const ForgotPasswordIntent.submitReset()),
              borderRadius: 15,
              height: 56.f,
            ),
            SizedBox(height: 40.f),
            // Footer Navigation
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
                  onPressed: () => viewModel?.handleIntent(const ForgotPasswordIntent.navigateToLogin()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
