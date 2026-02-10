import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/shared/base_auth_listenable_page.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_text.dart';

/// A text widget that blurs content for guest users and shows it for authenticated users.
class CommonAuthText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final ContainerOptions? containerOptions;
  final bool useFittedBox;
  final double blurSigma;

  const CommonAuthText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.fit = BoxFit.scaleDown,
    this.alignment = Alignment.centerLeft,
    this.containerOptions,
    this.useFittedBox = true,
    this.blurSigma = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return BaseAuthListenablePage(
      builder: (context, child) {
        // Check if user is logged in via the global authManager
        final bool isGuest = authManager.state.isGuest;

        Widget content = CommonText(
          text,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          fit: fit,
          alignment: alignment,
          containerOptions: containerOptions,
          useFittedBox: useFittedBox,
        );

        if (isGuest) {
          // Apply blur filter for guest users
          return ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: content,
          );
        }

        return content;
      },
    );
  }
}
