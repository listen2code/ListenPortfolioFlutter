import 'dart:io';

import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

/// UI side-effect to open the circular avatar crop page using AppNav.
class CropAvatarEffect extends BaseEffect {
  final File imageFile;
  final void Function(File? file)? onResult;

  CropAvatarEffect({
    required this.imageFile,
    this.onResult,
  });

  @override
  String toString() => 'CropAvatarEffect(imageFile: $imageFile)';
}

/// Concrete provider implementation that displays the [CommonImageCropper] via AppNav.
class CropAvatarProviderImpl extends BaseProvider<CropAvatarEffect> {
  const CropAvatarProviderImpl();

  @override
  void handleEffect(CropAvatarEffect effect) async {
    // Navigate using AppNav, passing the crop page widget instance.
    // The crop page will pop using AppNav.back(croppedFile) which returns the cropped File.
    final File? croppedFile = await AppNav.to<File?>(
      CommonImageCropper(
        imageFile: effect.imageFile,
        cropShape: BoxShape.circle,
      ),
    );
    effect.onResult?.call(croppedFile);
  }
}
