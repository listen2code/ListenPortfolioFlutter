import 'package:flutter/material.dart';

import '../uikit.dart';

/// A compact UI element that represents an attribute, text, or entity.
/// Supports selection and deletion.
class CommonChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final IconData? icon;
  final Color? color;
  final Color? selectedColor;
  final Color? textColor;

  const CommonChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.onDelete,
    this.icon,
    this.color,
    this.selectedColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.iconTheme.color ?? theme.colorScheme.primary;

    final effectiveColor = isSelected
        ? (selectedColor ?? accentColor)
        : (color ?? theme.dividerColor.withValues(alpha: 0.05));

    final effectiveTextColor = isSelected ? Colors.white : (textColor ?? theme.textTheme.bodyMedium?.color);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 14, color: effectiveTextColor), const SizedBox(width: 6)],
            CommonText(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: effectiveTextColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onDelete,
                child: Icon(Icons.close, size: 14, color: effectiveTextColor?.withValues(alpha: 0.6)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
