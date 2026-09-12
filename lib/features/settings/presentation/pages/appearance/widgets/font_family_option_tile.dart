import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

/// ============================================================================
/// FontFamilyOptionTile
/// ============================================================================
/// Interactive settings tile for selecting a specific [AppFontFamily].
///
/// ### Architecture & UX Rationale:
/// - **WYSIWYG Live Typography Preview**:
///   Both the left-hand 'Aa' badge container and the tile's [title] are explicitly
///   rendered using the target option's [AppFontFamily.fontFamilyName] and
///   [AppFontFamily.fontFamilyFallback]. This gives users an instant, true visual
///   preview of the typeface geometry, weight, and stroke characteristics prior to selection.
/// - **Responsive Scaling**:
///   Uses the `.f` extension (`32.f`, `14.f`) to ensure that the preview badge and
///   typography scale in harmony with the active global font factor.
/// - **Selection Feedback**:
///   Highlights the badge boundary and displays a distinct checkmark trailing icon
///   in the active [accentColor].
class FontFamilyOptionTile extends StatelessWidget {
  /// Localized title string for this font family option.
  final String label;

  /// The font family represented by this tile.
  final AppFontFamily fontFamily;

  /// The currently active font family in the application state.
  final AppFontFamily currentFontFamily;

  /// Callback executed when the user taps this option tile.
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
            fontFamilyFallback: fontFamily.fontFamilyFallback,
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
          fontFamilyFallback: fontFamily.fontFamilyFallback,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: Visibility(visible: isSelected, child: Icon(Icons.check_circle, color: accentColor)),
      onTap: onTap,
    );
  }
}
