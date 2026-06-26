import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class ThemeOptionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final ThemeMode mode;
  final ThemeMode currentThemeMode;
  final VoidCallback onTap;

  const ThemeOptionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.mode,
    required this.currentThemeMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = mode == currentThemeMode;
    final accentColor = context.accentColor;
    return ListTile(
      leading: SizedBox(width: 20.f, child: Icon(icon, color: isSelected ? accentColor : Colors.grey)),
      title: CommonText(label),
      trailing: isSelected ? Icon(Icons.check_circle, color: accentColor) : null,
      onTap: onTap,
    );
  }
}
