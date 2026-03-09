import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../uikit.dart';

enum ButtonType { filled, outlined, text }

class CommonButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final IconData? icon;
  final bool isFullWidth;
  final double? fontSize;
  final bool useHaptic;
  final Duration debounceDuration;

  const CommonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.filled,
    this.isLoading = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 12,
    this.padding,
    this.icon,
    this.isFullWidth = true,
    this.fontSize,
    this.useHaptic = true,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  // Use timestamp to handle debounce without triggering setState and visual flickering
  int _lastClickTime = 0;

  void _handlePress() {
    if (widget.onPressed == null || widget.isLoading) return;

    final int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastClickTime < widget.debounceDuration.inMilliseconds) {
      // Ignore rapid clicks
      return;
    }
    _lastClickTime = now;

    if (widget.useHaptic) {
      HapticFeedback.lightImpact();
    }

    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Resolve accent color without depending on shared:
    // 1. Manual backgroundColor
    // 2. Original accent color from iconTheme
    // 3. M3 primary color
    final effectiveAccentColor = widget.backgroundColor ?? theme.iconTheme.color ?? theme.colorScheme.primary;
    final contentColor =
        widget.foregroundColor ?? (widget.type == ButtonType.filled ? Colors.white : effectiveAccentColor);

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(contentColor),
            ),
          ),
          const SizedBox(width: 10),
        ] else if (widget.icon != null) ...[
          Icon(widget.icon, size: 18, color: contentColor),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: CommonText(
            widget.text,
            style: theme.textTheme.labelLarge?.copyWith(
              color: contentColor,
              fontWeight: FontWeight.bold,
              fontSize: widget.fontSize ?? 16,
            ),
          ),
        ),
      ],
    );

    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.borderRadius));
    final padding = widget.padding ?? const EdgeInsets.symmetric(vertical: 12);

    // Visual 'enabled' state only depends on isLoading and provided callback.
    // Debounce is handled internally in _handlePress.
    final VoidCallback? effectiveOnPressed = (widget.onPressed == null || widget.isLoading)
        ? null
        : _handlePress;

    Widget button;
    switch (widget.type) {
      case ButtonType.filled:
        button = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveAccentColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: shape,
            padding: padding,
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.outlined:
        button = OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: effectiveAccentColor,
            side: BorderSide(color: effectiveAccentColor, width: 1.5),
            shape: shape,
            padding: padding,
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            foregroundColor: effectiveAccentColor,
            shape: shape,
            padding: padding,
            splashFactory: NoSplash.splashFactory,
          ),
          child: buttonChild,
        );
        break;
    }

    return SizedBox(
      width: widget.isFullWidth ? double.infinity : widget.width,
      height: widget.height ?? 52,
      child: button,
    );
  }
}
