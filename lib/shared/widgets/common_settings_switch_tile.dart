import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../shared.dart';

class CommonSettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CommonSettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
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
      title: CommonText(
        title,
        style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        maxLines: 1,
      ),
      trailing: CommonSwitch(value: value, onChanged: onChanged),
      onTap: () => onChanged(!value),
    );
  }
}
