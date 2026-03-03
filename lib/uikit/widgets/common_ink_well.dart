import 'package:flutter/material.dart';

/// A universal wrapper that adds Material ripple effects to any widget.
/// It solves the common issue where ripples are hidden by the child's background color.
class CommonInkWell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Color? highlightColor;

  const CommonInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.splashColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    // If no callback is provided, just return the child without interaction layers.
    if (onTap == null && onLongPress == null) {
      return child;
    }

    return Material(
      color: Colors.transparent, // Keeps the background transparent to show underlying colors
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: borderRadius ?? BorderRadius.circular(0),
        splashColor: splashColor,
        highlightColor: highlightColor,
        child: child,
      ),
    );
  }
}
