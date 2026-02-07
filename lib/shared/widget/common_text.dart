import 'package:flutter/material.dart';

class CommonText extends Text {
  const CommonText(
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
    this.fit = BoxFit.scaleDown,
    this.alignment = Alignment.centerLeft,
    this.containerOptions,
    this.useFittedBox = true,
  });

  final BoxFit fit;

  final AlignmentGeometry alignment;

  final ContainerOptions? containerOptions;

  final bool useFittedBox;

  @override
  Widget build(BuildContext context) {
    Widget child = super.build(context);

    if (useFittedBox) {
      child = FittedBox(fit: fit ?? BoxFit.contain, alignment: alignment ?? Alignment.center, child: child);
    }

    if (containerOptions != null) {
      return Container(
        height: containerOptions!.height,
        padding: containerOptions!.padding,
        margin: containerOptions!.margin,
        alignment: containerOptions!.alignment,
        decoration:
            containerOptions!.decoration ??
            (containerOptions!.backgroundColor != null ? BoxDecoration(color: containerOptions!.backgroundColor) : null),
        child: child,
      );
    }

    return child;
  }
}

class ContainerOptions {
  const ContainerOptions({this.height, this.padding, this.margin, this.backgroundColor, this.decoration, this.alignment});

  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Decoration? decoration;
  final AlignmentGeometry? alignment;
}
