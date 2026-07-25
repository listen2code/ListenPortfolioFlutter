import 'dart:io';

import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

/// UI side-effect to open the fullscreen image preview page using AppNav.
class PreviewImageEffect extends BaseEffect {
  final String? imageUrl;
  final File? imageFile;
  final String? heroTag;

  PreviewImageEffect({
    this.imageUrl,
    this.imageFile,
    this.heroTag,
  });

  @override
  String toString() => 'PreviewImageEffect(imageUrl: $imageUrl, imageFile: $imageFile, heroTag: $heroTag)';
}

/// Concrete provider implementation that displays the [CommonImagePreview] via AppNav.
class PreviewImageProviderImpl extends BaseProvider<PreviewImageEffect> {
  const PreviewImageProviderImpl();

  @override
  void handleEffect(PreviewImageEffect effect) {
    AppNav.to(
      CommonImagePreview(
        imageUrl: effect.imageUrl,
        imageFile: effect.imageFile,
        heroTag: effect.heroTag,
      ),
    );
  }
}
