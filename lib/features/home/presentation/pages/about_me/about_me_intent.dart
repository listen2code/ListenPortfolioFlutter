import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listen_core/core.dart';

import '../../../../../../shared/utils/playback_registry_init.dart';

part 'about_me_intent.freezed.dart';

@freezed
class AboutMeIntent extends BaseIntent with _$AboutMeIntent {
  const factory AboutMeIntent.pickImage(ImageSource source) = _PickImage;
  const factory AboutMeIntent.imagePicked(File? file) = _ImagePicked;
  const factory AboutMeIntent.removeImage() = _RemoveImage;
  const factory AboutMeIntent.refresh() = _Refresh;
  const factory AboutMeIntent.shareApp() = _ShareApp;
  const factory AboutMeIntent.toResume() = _ToResume;
  const AboutMeIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('AboutMeIntent', 'pickImage', (args) {
      final srcStr = args['source'] ?? '';
      final source = ImageSource.values.firstWhere(
        (e) => e.toString().split('.').last == srcStr || e.toString() == srcStr,
        orElse: () => ImageSource.gallery,
      );
      return AboutMeIntent.pickImage(source);
    });
    MviPlaybackRegistry.register('AboutMeIntent', 'removeImage', (args) => const AboutMeIntent.removeImage());
    MviPlaybackRegistry.register('AboutMeIntent', 'imagePicked', (args) {
      final fileStr = args['file'] ?? 'null';
      if (fileStr == 'null') {
        return const AboutMeIntent.imagePicked(null);
      }
      final pathRegex = RegExp(r"File:\s*'([^']+)'|File\('([^']+)'\)");
      final match = pathRegex.firstMatch(fileStr);
      final path = match?.group(1) ?? match?.group(2) ?? '';
      return AboutMeIntent.imagePicked(path.isNotEmpty ? File(path) : null);
    });
    MviPlaybackRegistry.register('AboutMeIntent', 'refresh', (args) => const AboutMeIntent.refresh());
    MviPlaybackRegistry.register('AboutMeIntent', 'shareApp', (args) => const AboutMeIntent.shareApp());
    MviPlaybackRegistry.register('AboutMeIntent', 'toResume', (args) => const AboutMeIntent.toResume());
  }
}
