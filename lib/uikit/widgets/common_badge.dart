import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

/// A small UI component to display status, counts, or categories.
class CommonBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final bool isOutline;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;

  const CommonBadge({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    this.isOutline = false,
    this.borderRadius = 4.0,
    this.padding,
    this.fontSize = 11.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    final effectiveTextColor = textColor ?? (isOutline ? effectiveColor : Colors.white);

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isOutline ? Colors.transparent : effectiveColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: isOutline ? Border.all(color: effectiveColor, width: 1) : null,
      ),
      child: CommonText(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: effectiveTextColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
