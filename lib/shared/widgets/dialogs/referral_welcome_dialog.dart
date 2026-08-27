import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../i18n/translations_key.dart';
import '../../services/referrer/install_referrer_data.dart';

/// A welcome dialog displayed on first install when the user arrived via a Google Play referral link.
/// Uses standard UI Kit components ([CommonButton], [CommonCard], [CommonText]).
class ReferralWelcomeDialog extends StatelessWidget {
  final InstallReferrerData data;
  final VoidCallback? onConfirm;

  const ReferralWelcomeDialog({super.key, required this.data, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      elevation: 8,
      backgroundColor: theme.dialogTheme.backgroundColor ?? colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Festive Header Icon
            Container(
              width: 64.0,
              height: 64.0,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const CommonText('🎉', style: TextStyle(fontSize: 32.0)),
            ),
            const SizedBox(height: 18.0),

            // 2. Welcome Title
            CommonText(
              I18nKeys.referralWelcomeTitle.tr,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),

            // 3. Welcome Body Message
            CommonText(
              I18nKeys.referralWelcomeMessage.tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                height: 1.4,
                fontSize: 14.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),

            // 4. Referral Source Information Card using CommonCard
            if (data.displaySource.isNotEmpty)
              CommonCard(
                borderRadius: 16.0,
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.campaign_outlined, size: 18.0, color: colorScheme.primary),
                        const SizedBox(width: 8.0),
                        CommonText(
                          I18nKeys.referralSourceLabel.tr,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 26.0),
                      child: CommonText(
                        data.displaySource,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    if (data.targetRoute != null && data.targetRoute!.isNotEmpty) ...[
                      const SizedBox(height: 6.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 26.0),
                        child: CommonText(
                          '${I18nKeys.referralTargetRouteLabel.tr}: ${data.targetRoute}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.secondary,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 24.0),

            // 5. Action Button ("Get Started") using CommonButton
            CommonButton(
              text: I18nKeys.referralGetStarted.tr,
              height: 52.0,
              borderRadius: 14.0,
              fontSize: 16.0,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                onConfirm?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
