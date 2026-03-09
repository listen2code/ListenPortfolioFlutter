import 'package:flutter/material.dart';

/// A unified card component for project details, skill blocks, or profile sections.
class CommonCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final double elevation;
  final Color? color;
  final Color? shadowColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderSide? borderSide;

  const CommonCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 16,
    this.elevation = 0,
    this.color,
    this.shadowColor,
    this.padding,
    this.margin,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Default to a subtle background in both themes if color is null
    final effectiveColor = color ?? theme.cardColor;

    return Container(
      margin: margin,
      child: Card(
        color: effectiveColor,
        elevation: elevation,
        shadowColor: shadowColor ?? theme.shadowColor.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: borderSide ?? BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding ?? const EdgeInsets.all(16), child: child),
        ),
      ),
    );
  }
}
