import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../sign_up_intent.dart';
import '../sign_up_view_model.dart';

class SignUpActionButtons extends StatelessWidget {
  final SignUpViewModel viewModel;

  const SignUpActionButtons({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Main Sign Up Action
        CommonButton(
          text: I18nKeys.signUp.tr,
          onPressed: () => viewModel.handleIntent(const SignUpIntent.submitSignUp()),
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
              onPressed: () => viewModel.handleIntent(const SignUpIntent.navigateToLogin()),
            ),
          ],
        ),
      ],
    );
  }
}
