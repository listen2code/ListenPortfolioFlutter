import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listen_core/core.dart';

part 'about_me_intent.freezed.dart';

@freezed
class AboutMeIntent extends BaseIntent with _$AboutMeIntent {
  const factory AboutMeIntent.pickImage(ImageSource source) = _PickImage;
  const factory AboutMeIntent.removeImage() = _RemoveImage;
  const factory AboutMeIntent.refresh() = _Refresh;
  const factory AboutMeIntent.shareApp() = _ShareApp;
  const factory AboutMeIntent.toResume() = _ToResume;
  const AboutMeIntent._();
}
