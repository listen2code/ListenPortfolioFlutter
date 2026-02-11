import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/shared/base/base_auth_listenable_page.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_text.dart';

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
/// Automatically handles login redirection on click if in guest mode.
class CommonAuthText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final ContainerOptions? containerOptions;
  final bool useFittedBox;
  final AuthBlurLevel blurLevel;
  final VoidCallback? onTap;
  final StrutStyle? strutStyle;

  const CommonAuthText(
    this.text, {
    super.key,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.maxLines,
    this.fit = BoxFit.scaleDown,
    this.alignment = Alignment.centerLeft,
    this.containerOptions,
    this.useFittedBox = true,
    this.blurLevel = AuthBlurLevel.none,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseAuthListenablePage(
      builder: (context, child) {
        final bool isGuest = authManager.state.isGuest;
        final bool shouldBlur = blurLevel != AuthBlurLevel.none && isGuest;

        Widget content = CommonText(
          text,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          fit: fit,
          alignment: alignment,
          containerOptions: containerOptions,
          useFittedBox: useFittedBox,
          strutStyle: strutStyle,
        );

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

        return GestureDetector(
          onTap: finalTap,
          behavior: shouldBlur ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
          child: content,
        );
      },
    );
  }
}
