import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class LoginActionButtons extends StatelessWidget {
  final VoidCallback onTapLogin;
  final VoidCallback onTapSkip;
  final VoidCallback onTapSignUp;

  const LoginActionButtons({
    super.key,
    required this.onTapLogin,
    required this.onTapSkip,
    required this.onTapSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CommonButton(
          text: I18nKeys.login.tr,
          onPressed: onTapLogin,
          borderRadius: 15,
          height: 56,
        ),
        const SizedBox(height: 15),
        CommonButton(
          text: I18nKeys.skipForNow.tr,
          type: ButtonType.text,
          foregroundColor: Colors.grey,
          onPressed: onTapSkip,
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
              onPressed: onTapSignUp,
            ),
          ],
        ),
      ],
    );
  }
}
