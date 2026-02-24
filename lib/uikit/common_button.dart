import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
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
    final accentColor = backgroundColor ?? context.accentColor;
    final contentColor = foregroundColor ?? (type == ButtonType.filled ? Colors.white : accentColor);

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18.f,
            height: 18.f,
            child: CircularProgressIndicator(
              strokeWidth: 2.f,
              valueColor: AlwaysStoppedAnimation<Color>(contentColor),
            ),
          ),
          SizedBox(width: 10.f),
        ] else if (icon != null) ...[
          Icon(icon, size: 18.f, color: contentColor),
          SizedBox(width: 8.f),
        ],
        Flexible(
          child: CommonText(
            text,
            style: context.textTheme.labelLarge?.copyWith(
              color: contentColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize ?? 16.f,
            ),
          ),
        ),
      ],
    );

    ButtonStyle style;
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius.f));

    switch (type) {
      case ButtonType.filled:
        style = ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: shape,
          padding: padding ?? EdgeInsets.symmetric(vertical: 12.f),
        );
        break;
      case ButtonType.outlined:
        style = OutlinedButton.styleFrom(
          foregroundColor: accentColor,
          side: BorderSide(color: accentColor, width: 1.5.f),
          shape: shape,
          padding: padding ?? EdgeInsets.symmetric(vertical: 12.f),
        );
        break;
      case ButtonType.text:
        style = TextButton.styleFrom(
          foregroundColor: accentColor,
          shape: shape,
          padding: padding ?? EdgeInsets.symmetric(vertical: 12.f),
          splashFactory: NoSplash.splashFactory,
          // Remove splash
          overlayColor: Colors.transparent, // Remove overlay highlight
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

    return SizedBox(width: isFullWidth ? double.infinity : width, height: height ?? 52.f, child: button);
  }
}
