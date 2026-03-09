import 'package:flutter/material.dart';

/// A unified divider component that supports both horizontal and vertical orientations
/// with consistent theme-based styling and optional padding.
class CommonDivider extends StatelessWidget {
  final double thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;
  final bool isVertical;
  final double? height; // For horizontal: total height of the container
  final double? width; // For vertical: total width of the container

  const CommonDivider({
    super.key,
    this.thickness = 1.0,
    this.indent,
    this.endIndent,
    this.color,
    this.height,
    this.width,
  }) : isVertical = false;

  const CommonDivider.vertical({
    super.key,
    this.thickness = 1.0,
    this.indent,
    this.endIndent,
    this.color,
    this.height,
    this.width,
  }) : isVertical = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.dividerColor.withValues(alpha: 0.1);

    if (isVertical) {
      return SizedBox(
        width: width ?? 16.0,
        height: height,
        child: VerticalDivider(
          thickness: thickness,
          indent: indent,
          endIndent: endIndent,
          color: effectiveColor,
        ),
      );
    }

    return Divider(
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: effectiveColor,
      height: height ?? 16.0,
    );
  }
}
