import 'package:flutter/material.dart';

import '../uikit.dart';

/// A small UI component to display status, counts, or categories.
/// Supports optional icons and granular style control to match specific UI designs.
class CommonBadge extends StatelessWidget {
  final String? text;
  final Widget? child; // Added to support custom widgets like CommonAuthText
  final IconData? icon;
  final double? iconSize;
  final Color? color;
  final Color? textColor;
  final Color? borderColor; // Added for precise border control
  final bool isOutline;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final double? borderWidth;
  final double? spacing;
  final double? letterSpacing;

  const CommonBadge({
    super.key,
    this.text,
    this.child,
    this.icon,
    this.iconSize,
    this.color,
    this.textColor,
    this.borderColor,
    this.isOutline = false,
    this.borderRadius = 4.0,
    this.padding,
    this.fontSize = 11.0,
    this.borderWidth,
    this.spacing = 4.0,
    this.letterSpacing,
  }) : assert(text != null || child != null, 'Either text or child must be provided');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    final effectiveTextColor = textColor ?? (isOutline ? effectiveColor : Colors.white);

    // Logic: Use provided borderColor, or fall back to effectiveColor if outlined,
    // or transparent if solid with no border width specified.
    final effectiveBorderColor =
        borderColor ??
        (isOutline ? effectiveColor : (borderWidth != null ? effectiveColor : Colors.transparent));

    // If child is provided, use it. Otherwise, wrap text in CommonText.
    final Widget labelWidget =
        child ??
        CommonText(
          text ?? "",
          style: theme.textTheme.labelSmall?.copyWith(
            color: effectiveTextColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: letterSpacing,
          ),
          maxLines: 1,
          useFittedBox: false,
        );

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isOutline ? Colors.transparent : effectiveColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: (isOutline || borderWidth != null || borderColor != null)
            ? Border.all(color: effectiveBorderColor, width: borderWidth ?? 1.0)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize ?? 12.0, color: effectiveTextColor),
            SizedBox(width: spacing),
          ],
          labelWidget,
        ],
      ),
    );
  }
}
