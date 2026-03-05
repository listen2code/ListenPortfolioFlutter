import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'about_me_intent.dart';
import 'about_me_state.dart';

part 'about_me_view_model.g.dart';

@riverpod
class AboutMeViewModel extends _$AboutMeViewModel with ViewModelMixin<AboutMeState, AboutMeIntent> {
  @override
  AboutMeState build() => const AboutMeState();

  @override
  void onVisible() {
    super.onVisible();
    // Refresh about me info from profile if needed
  }

  @override
  FutureOr<void> onIntent(AboutMeIntent intent) {
    intent.when(
      pickImage: (source) => _onPickImage(source),
      removeImage: () => updateState(state.copyWith(imageFile: null)),
    );
  }

  Future<void> _onPickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      updateState(state.copyWith(imageFile: File(pickedFile.path)));
    }
  }
}
