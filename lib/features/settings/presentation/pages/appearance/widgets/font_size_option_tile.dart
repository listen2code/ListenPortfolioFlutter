import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class FontSizeOptionTile extends StatelessWidget {
  final String label;
  final AppFontSize fontSize;
  final AppFontSize currentFontSize;
  final VoidCallback onTap;

  const FontSizeOptionTile({
    super.key,
    required this.label,
    required this.fontSize,
    required this.currentFontSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = fontSize == currentFontSize;
    final accentColor = context.accentColor;
    return ListTile(
      leading: SizedBox(
        width: 20.f,
        child: Icon(
          Icons.text_fields,
          size: fontSize.iconSize,
          color: isSelected ? accentColor : Colors.grey,
        ),
      ),
      title: CommonText(label),
      trailing: isSelected ? Icon(Icons.check_circle, color: accentColor) : null,
      onTap: onTap,
    );
  }
}
