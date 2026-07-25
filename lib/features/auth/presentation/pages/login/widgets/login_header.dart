import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../generated/r.dart';
import '../../../../../../shared/shared.dart';
import '../../../../../splash/presentation/pages/splash_page.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = context.accentColor;

    return Column(
      children: [
        const SizedBox(height: 40),
        Hero(
          tag: SplashPage.logo,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CommonImage.asset(
                R.imagesIcLauncherAdaptiveFore,
                width: 60,
                height: 60,
                color: accentColor,
                semanticLabel: I18nKeys.appLogoSemanticLabel.tr,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Column(
          children: [
            CommonText(
              I18nKeys.welcomeBack.tr,
              style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CommonText(
              I18nKeys.signInToContinue.tr,
              style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
