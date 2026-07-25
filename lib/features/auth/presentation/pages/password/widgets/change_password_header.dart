import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class ChangePasswordHeader extends StatelessWidget {
  const ChangePasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.f),
        CommonText(
          I18nKeys.changePassword.tr,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.isDark ? Colors.white : Colors.black87,
          ),
          maxLines: 1,
        ),
        SizedBox(height: 12.f),
        CommonText(
          I18nKeys.changePasswordSubtitle.tr,
          style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5),
          maxLines: 2,
        ),
      ],
    );
  }
}
