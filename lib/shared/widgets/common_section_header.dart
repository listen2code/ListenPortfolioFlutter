import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../shared.dart';

class CommonSectionHeader extends StatelessWidget {
  final String title;
  final bool showVerticalBar;
  final Widget? trailing;

  const CommonSectionHeader({
    super.key,
    required this.title,
    this.showVerticalBar = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = context.accentColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showVerticalBar) ...[
              Container(
                width: 4.f,
                height: 18.f,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2.f),
                ),
              ),
              SizedBox(width: 8.f),
            ],
            CommonText(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: showVerticalBar
                    ? null
                    : context.theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        ?trailing,
      ],
    );
  }
}
