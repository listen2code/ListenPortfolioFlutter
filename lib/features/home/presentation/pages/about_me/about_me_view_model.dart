import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:listen_core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../shared/shared.dart';
import '../../../data/models/about_me_model.dart';
import '../../provider/about_me_provider.dart';
import 'about_me_intent.dart';
import 'about_me_state.dart';

part 'about_me_view_model.g.dart';

/// ViewModel for the About Me page
///
/// Manages the state and business logic for displaying and editing user profile information.
/// Handles data fetching, image selection, and state updates following the MVI pattern.
@riverpod
class AboutMeViewModel extends _$AboutMeViewModel with ViewModelMixin<AboutMeState, AboutMeIntent> {
  /// Initialize with default empty state
  @override
  AboutMeState build() => const AboutMeState();

  /// Lifecycle hook called when the widget becomes visible
  /// Triggers initial data load if not already loaded
  @override
  void onVisible() {
    super.onVisible();
    // Only fetch data on first visibility to avoid unnecessary network calls
    if (!state.isInitialLoaded) {
      handleIntent(const AboutMeIntent.refresh());
    }
  }

  /// Route incoming intents to their respective handlers
  @override
  FutureOr<void> onIntent(AboutMeIntent intent) {
    return intent.when<FutureOr<void>>(
      pickImage: (source) => _onPickImage(source),
      removeImage: () => updateState(state.copyWith(imageFile: null)),
      refresh: _onRefresh,
      shareApp: _onShareApp,
      toResume: () => emitEffect(NavigationEffect(target: Routes.resume)),
    );
  }

  /// Handle image selection from camera or gallery
  /// Updates state with the selected image file
  Future<void> _onPickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      updateState(state.copyWith(imageFile: File(pickedFile.path)));
    }
  }

  /// Fetch about me data from the repository
  /// Shows page-level loading indicator during the operation
  /// Updates state with fetched data on success
  Future<void> _onRefresh() async {
    await call(
      ref.execute<AboutMeModel, BaseParam>(getAboutMeUseCaseProvider),
      showLoading: true,
      loadingType: LoadingType.page,
      onSuccess: (aboutMe) {
        updateState(state.copyWith(data: aboutMe as AboutMeModel?, isInitialLoaded: true));
      },
    );
  }

  void _onShareApp() {
    emitEffect(
      ShareEffect(text: '${AppConstants.appName} - ${I18nKeys.shareApp.tr}: ${AppConstants.storeShare}'),
    );
  }
}
