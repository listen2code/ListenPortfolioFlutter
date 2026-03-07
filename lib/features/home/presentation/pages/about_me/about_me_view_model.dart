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
    if (!state.isInitialLoaded) {
      handleIntent(const AboutMeIntent.refresh());
    }
  }

  @override
  FutureOr<void> onIntent(AboutMeIntent intent) {
    return intent.when<FutureOr<void>>(
      pickImage: (source) => _onPickImage(source),
      removeImage: () => updateState(state.copyWith(imageFile: null)),
      refresh: _onRefresh,
    );
  }

  Future<void> _onPickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      updateState(state.copyWith(imageFile: File(pickedFile.path)));
    }
  }

  Future<void> _onRefresh() async {
    emitEffect(LoadingEffect(true));
    // Simulate initial data loading delay
    await Future.delayed(const Duration(milliseconds: 1000));
    updateState(state.copyWith(isInitialLoaded: true));
    emitEffect(LoadingEffect(false));
  }
}
