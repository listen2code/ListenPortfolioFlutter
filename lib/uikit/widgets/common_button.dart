import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

enum ButtonType { filled, outlined, text }

class CommonButton extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Resolve accent color without depending on shared:
    // 1. Manual backgroundColor
    // 2. Original accent color from iconTheme
    // 3. M3 primary color
    final effectiveAccentColor = backgroundColor ?? theme.iconTheme.color ?? theme.colorScheme.primary;

    final contentColor = foregroundColor ?? (type == ButtonType.filled ? Colors.white : effectiveAccentColor);

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(contentColor),
            ),
          ),
          const SizedBox(width: 10),
        ] else if (icon != null) ...[
          Icon(icon, size: 18, color: contentColor),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: CommonText(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              color: contentColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize ?? 16,
            ),
          ),
        ),
      ],
    );

    ButtonStyle style;
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius));

    switch (type) {
      case ButtonType.filled:
        style = ElevatedButton.styleFrom(
          backgroundColor: effectiveAccentColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: shape,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
        );
        break;
      case ButtonType.outlined:
        style = OutlinedButton.styleFrom(
          foregroundColor: effectiveAccentColor,
          side: BorderSide(color: effectiveAccentColor, width: 1.5),
          shape: shape,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
        );
        break;
      case ButtonType.text:
        style = TextButton.styleFrom(
          foregroundColor: effectiveAccentColor,
          shape: shape,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
          splashFactory: NoSplash.splashFactory,
          overlayColor: Colors.transparent,
        );
        break;
    }

    Widget button;
    if (type == ButtonType.filled) {
      button = ElevatedButton(onPressed: isLoading ? null : onPressed, style: style, child: buttonChild);
    } else if (type == ButtonType.outlined) {
      button = OutlinedButton(onPressed: isLoading ? null : onPressed, style: style, child: buttonChild);
    } else {
      button = TextButton(onPressed: isLoading ? null : onPressed, style: style, child: buttonChild);
    }

    return SizedBox(width: isFullWidth ? double.infinity : width, height: height ?? 52, child: button);
  }
}
