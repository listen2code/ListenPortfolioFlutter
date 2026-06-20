import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

class ConfirmEffect extends BaseEffect {
  final String title;
  final String message;
  final String? okText;
  final String? cancelText;
  final Color? okColor;
  final bool barrierDismissible;
  final void Function(bool confirmed) onResult;

  ConfirmEffect({
    required this.title,
    required this.message,
    this.okText,
    this.cancelText,
    this.okColor,
    this.barrierDismissible = false,
    required this.onResult,
  });
}

class ConfirmProviderImpl extends BaseProvider<ConfirmEffect> {
  const ConfirmProviderImpl();

  @override
  void handleEffect(ConfirmEffect effect) {
    CommonDialog.showConfirm(
      title: effect.title,
      message: effect.message,
      okText: effect.okText,
      cancelText: effect.cancelText,
      okColor: effect.okColor,
      barrierDismissible: effect.barrierDismissible,
    ).then((result) {
      effect.onResult(result ?? false);
    });
  }
}
