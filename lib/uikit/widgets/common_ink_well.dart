import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A universal wrapper that adds Material ripple effects to any widget.
/// Integrated with [HapticFeedback] for a better tactile experience.
class CommonInkWell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Color? highlightColor;

  /// Whether to trigger a light haptic feedback on tap.
  final bool useHaptic;

  const CommonInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.splashColor,
    this.highlightColor,
    this.useHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    // If no callback is provided, just return the child without interaction layers.
    if (onTap == null && onLongPress == null) {
      return child;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (useHaptic) {
            HapticFeedback.lightImpact();
          }
          onTap?.call();
        },
        onLongPress: () {
          if (useHaptic) {
            HapticFeedback.mediumImpact();
          }
          onLongPress?.call();
        },
        borderRadius: borderRadius ?? BorderRadius.circular(0),
        splashColor: splashColor,
        highlightColor: highlightColor,
        child: child,
      ),
    );
  }
}
