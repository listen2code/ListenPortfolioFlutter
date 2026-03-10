import 'package:flutter/material.dart';

import '../uikit.dart';

/// A standard list item component with a leading icon, title, subtitle, and trailing widget.
/// Commonly used for settings, menus, or simple data lists.
class CommonListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool showDivider;
  final Color? backgroundColor;

  const CommonListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.padding,
    this.showDivider = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = Column(
      children: [
        ListTile(
          contentPadding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          tileColor: backgroundColor,
          leading: leading,
          title: CommonText(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
          subtitle: subtitle != null
              ? CommonText(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodySmall?.color),
                )
              : null,
          trailing:
              trailing ??
              (onTap != null
                  ? Icon(Icons.chevron_right, color: theme.dividerColor.withValues(alpha: 0.4))
                  : null),
          onTap: onTap,
        ),
        if (showDivider) const CommonDivider(height: 1, indent: 16, endIndent: 16),
      ],
    );

    return content;
  }
}
