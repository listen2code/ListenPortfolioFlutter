import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
}
