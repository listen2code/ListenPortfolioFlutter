import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import '../shared.dart';
import 'package:listen_uikit/uikit.dart';

/// Predefined blur intensities for unauthorized content
enum AuthBlurLevel {
  none(0.0),
  low(2.0),
  medium(5.0),
  high(10.0);

  final double sigma;

  const AuthBlurLevel(this.sigma);
}

/// A text widget that blurs content for guest users and shows it for authenticated users.
/// Extends [CommonText] to leverage its layout and container capabilities.
class CommonAuthText extends CommonText {
  final AuthBlurLevel blurLevel;
  final VoidCallback? onTap;

  const CommonAuthText(
    super.text, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaler,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
    super.fit,
    super.alignment,
    super.containerOptions,
    super.useFittedBox,
    this.blurLevel = AuthBlurLevel.none,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseAuthPage(
      builder: (context, child) {
        final bool isGuest = authManager.state.isGuest;
        final bool shouldBlur = blurLevel != AuthBlurLevel.none && isGuest;

        // Use the base build method from CommonText to get the rendered text widget
        Widget content = super.build(context);

        if (shouldBlur) {
          content = ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blurLevel.sigma, sigmaY: blurLevel.sigma),
            child: content,
          );
        }

        // Intercept taps if content is blurred for guest.
        // Otherwise, use provided onTap or let it pass through.
        final VoidCallback? finalTap = shouldBlur
            ? () => AppNav.tryLogin(onSuccess: () => onTap?.call())
            : onTap;

        return CommonClickable(
          ripple: false,
          onTap: finalTap,
          excludeFromSemantics: finalTap == null,
          child: content,
        );
      },
    );
  }
}
