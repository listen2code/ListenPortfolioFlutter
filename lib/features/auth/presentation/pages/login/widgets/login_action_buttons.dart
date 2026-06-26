import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../login_intent.dart';
import '../login_view_model.dart';

class LoginActionButtons extends StatelessWidget {
  final LoginViewModel viewModel;

  const LoginActionButtons({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CommonButton(
          text: I18nKeys.login.tr,
          onPressed: () => viewModel.handleIntent(const LoginIntent.submitLogin()),
          borderRadius: 15,
          height: 56,
        ),
        const SizedBox(height: 15),
        CommonButton(
          text: I18nKeys.skipForNow.tr,
          type: ButtonType.text,
          foregroundColor: Colors.grey,
          onPressed: () => viewModel.handleIntent(const LoginIntent.skipLogin()),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: CommonText(
                I18nKeys.noAccount.tr,
                style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),
            const SizedBox(width: 10),
            CommonButton(
              text: I18nKeys.signUp.tr,
              type: ButtonType.text,
              isFullWidth: false,
              onPressed: () => viewModel.handleIntent(const LoginIntent.navigateToSignup()),
            ),
          ],
        ),
      ],
    );
  }
}
