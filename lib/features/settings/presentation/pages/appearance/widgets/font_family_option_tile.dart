import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class FontFamilyOptionTile extends StatelessWidget {
  final String label;
  final AppFontFamily fontFamily;
  final AppFontFamily currentFontFamily;
  final VoidCallback onTap;

  const FontFamilyOptionTile({
    super.key,
    required this.label,
    required this.fontFamily,
    required this.currentFontFamily,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = fontFamily == currentFontFamily;
    final accentColor = context.accentColor;
    return ListTile(
      leading: Container(
        width: 32.f,
        height: 32.f,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withValues(alpha: 0.15) : context.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8.f),
          border: Border.all(
            color: isSelected ? accentColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: CommonText(
          'Aa',
          style: TextStyle(
            fontFamily: fontFamily.fontFamilyName,
            fontWeight: FontWeight.bold,
            fontSize: 14.f,
            color: isSelected ? accentColor : context.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      title: CommonText(
        label,
        style: TextStyle(
          fontFamily: fontFamily.fontFamilyName,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: Visibility(visible: isSelected, child: Icon(Icons.check_circle, color: accentColor)),
      onTap: onTap,
    );
  }
}
