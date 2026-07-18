import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:listen_core/core.dart';

/// Single-use UI side-effect to launch the image picker (camera/gallery).
class PickImageEffect extends BaseEffect {
  final ImageSource source;
  final void Function(File? file)? onResult;

  PickImageEffect({
    required this.source,
    this.onResult,
  });

  @override
  String toString() => 'PickImageEffect(source: $source)';
}

/// Concrete provider implementation that orchestrates image picking using [ImagePicker].
class PickImageProviderImpl extends BaseProvider<PickImageEffect> {
  const PickImageProviderImpl();

  @override
  void handleEffect(PickImageEffect effect) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: effect.source);
      if (pickedFile != null) {
        effect.onResult?.call(File(pickedFile.path));
      } else {
        effect.onResult?.call(null);
      }
    } catch (e) {
      appLogger.e('PickImageProviderImpl: Failed to pick image: $e');
      effect.onResult?.call(null);
    }
  }
}
