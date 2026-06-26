import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../shared.dart';

class CommonSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final AuthBlurLevel blurLevel;

  const CommonSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
    this.blurLevel = AuthBlurLevel.none,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = context.accentColor;
    final iconSize = 20.f * 0.8;

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.f, vertical: 4.f),
      leading: Container(
        padding: EdgeInsets.all(8.f),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10.f),
        ),
        child: Icon(icon, color: accentColor, size: iconSize),
      ),
      title: CommonAuthText(
        title,
        style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        maxLines: 1,
        blurLevel: blurLevel,
        onTap: onTap,
      ),
      subtitle: subtitle != null
          ? CommonText(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall?.copyWith(color: Colors.grey),
            )
          : null,
      trailing: trailing ?? Icon(Icons.chevron_right_rounded, size: 20.f, color: Colors.grey),
      onTap: onTap,
    );
  }
}
