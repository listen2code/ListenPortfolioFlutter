import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../i18n/translations_key.dart';
import '../../services/referrer/install_referrer_data.dart';

/// A comprehensive welcome dialog displayed on first install when the user arrived via a Google Play referral link.
/// Uses standard UI Kit components ([CommonButton], [CommonCard], [CommonText]) and displays all parsed parameters.
/// Includes a "Don't show again" checkbox that controls whether this referral is permanently marked as processed in SP.
class ReferralWelcomeDialog extends StatefulWidget {
  final InstallReferrerData data;
  final void Function(bool doNotShowAgain)? onConfirm;

  const ReferralWelcomeDialog({super.key, required this.data, this.onConfirm});

  @override
  State<ReferralWelcomeDialog> createState() => _ReferralWelcomeDialogState();
}

class _ReferralWelcomeDialogState extends State<ReferralWelcomeDialog> {
  bool _doNotShowAgain = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final data = widget.data;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      elevation: 8,
      backgroundColor: theme.dialogTheme.backgroundColor ?? colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420.0),
        child: SingleChildScrollView(
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
              const SizedBox(height: 18.0),

              // 4. Debug Referral Parameters Card (matching test.html)
              CommonCard(
                borderRadius: 16.0,
                color: colorScheme.surfaceContainerLow.withValues(alpha: 0.7),
                borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tune_outlined, size: 16.0, color: colorScheme.primary),
                        const SizedBox(width: 8.0),
                        CommonText(
                          I18nKeys.referralParamsDetailLabel.tr,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16.0, thickness: 0.8),
                    if (data.refer != null && data.refer!.isNotEmpty)
                      _buildParamRow('refer', data.refer!, theme, isPrimary: true),
                    if (data.targetRoute != null && data.targetRoute!.isNotEmpty)
                      _buildParamRow('target', data.targetRoute!, theme, isPrimary: true),
                    if (data.utmSource != null && data.utmSource!.isNotEmpty)
                      _buildParamRow('utm_source', data.utmSource!, theme),
                    if (data.rawReferrer.isNotEmpty) ...[
                      const SizedBox(height: 6.0),
                      CommonText(
                        '${I18nKeys.referralRawReferrerLabel.tr} (rawReferrer):',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.2)),
                        ),
                        child: SelectableText(
                          data.rawReferrer,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11.0,
                            fontFamily: 'monospace',
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16.0),

              // 5. "Don't show again" Checkbox
              CommonClickable(
                onTap: () {
                  setState(() {
                    _doNotShowAgain = !_doNotShowAgain;
                  });
                },
                borderRadius: BorderRadius.circular(8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: Checkbox(
                          value: _doNotShowAgain,
                          activeColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          onChanged: (val) {
                            setState(() {
                              _doNotShowAgain = val ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      CommonText(
                        I18nKeys.doNotShowAgain.tr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // 6. Action Button ("Get Started") using CommonButton
              CommonButton(
                text: I18nKeys.referralGetStarted.tr,
                height: 50.0,
                borderRadius: 14.0,
                fontSize: 16.0,
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  widget.onConfirm?.call(_doNotShowAgain);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildParamRow(String label, String? value, ThemeData theme, {bool isPrimary = false}) {
    final bool hasValue = value != null && value.isNotEmpty;
    final displayVal = hasValue ? value : '(null)';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105.0,
            child: CommonText(
              '$label:',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isPrimary ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                fontSize: 11.5,
                fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              displayVal,
              style: theme.textTheme.bodySmall?.copyWith(
                color: hasValue
                    ? (isPrimary ? theme.colorScheme.primary : theme.colorScheme.onSurface)
                    : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                fontSize: 11.5,
                fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
                fontStyle: hasValue ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
