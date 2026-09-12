import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

/// ============================================================================
/// FontSizeOptionTile
/// ============================================================================
/// Interactive settings tile for selecting an [AppFontSize] scaling multiplier.
///
/// Features proportional leading iconography reflecting the relative size of
/// the typography option, title rendering via [CommonText], and active checkmark feedback.
class FontSizeOptionTile extends StatelessWidget {
  /// Localized display label for this font size tier.
  final String label;

  /// The font size tier represented by this option.
  final AppFontSize fontSize;

  /// The currently active font size tier in state.
  final AppFontSize currentFontSize;

  /// Callback executed when tapping this tile.
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
      trailing: Visibility(visible: isSelected, child: Icon(Icons.check_circle, color: accentColor)),
      onTap: onTap,
    );
  }
}
