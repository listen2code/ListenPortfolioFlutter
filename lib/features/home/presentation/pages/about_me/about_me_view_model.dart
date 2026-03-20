import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/provider/about_me_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
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
    await call(
      ref.execute(getAboutMeUseCaseProvider, const NoParams()),
      showLoading: true,
      loadingType: LoadingType.page,
      onSuccess: (aboutMe) {
        updateState(state.copyWith(data: aboutMe, isInitialLoaded: true));
      },
    );
  }
}
