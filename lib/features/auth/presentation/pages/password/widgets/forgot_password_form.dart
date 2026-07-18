import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../forgot_password_state.dart';

class ForgotPasswordForm extends StatelessWidget {
  final TextEditingController emailController;
  final ForgotPasswordState state;
  final ValueChanged<String> onEmailChanged;
  final VoidCallback onSubmitReset;
  final VoidCallback onTapLogin;

  const ForgotPasswordForm({
    super.key,
    required this.emailController,
    required this.state,
    required this.onEmailChanged,
    required this.onSubmitReset,
    required this.onTapLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Reactive Email Input
        CommonTextField(
          controller: emailController,
          type: TextFieldType.email,
          labelText: I18nKeys.emailAddress.tr,
          prefixIcon: Icons.email_outlined,
          errorText: state.emailError,
          onChanged: onEmailChanged,
        ),
        SizedBox(height: 32.f),
        // Submit Action
        CommonButton(
          text: I18nKeys.sendResetLink.tr,
          onPressed: onSubmitReset,
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
              onPressed: onTapLogin,
            ),
          ],
        ),
      ],
    );
  }
}
