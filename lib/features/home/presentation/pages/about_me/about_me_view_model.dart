import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' show ImageSource;
import 'package:listen_core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../shared/shared.dart';
import '../../../../auth/presentation/provider/auth_provider.dart';
import '../../../../auth/data/models/user_model.dart';
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
      imagePicked: (file) => _onImagePicked(file),
      removeImage: _onRemoveImage,
      refresh: _onRefresh,
      shareApp: _onShareApp,
      toResume: () => emitEffect(NavigationEffect(target: Routes.resume)),
      showPickerMenu: _onShowPickerMenu,
    );
  }

  void _onShowPickerMenu() {
    emitEffect(
      ActionSheetEffect(
        options: [
          ActionSheetOption(
            label: I18nKeys.chooseFromGallery.tr,
            icon: Icons.photo_library_outlined,
            onTap: () => handleIntent(const AboutMeIntent.pickImage(ImageSource.gallery)),
          ),
          ActionSheetOption(
            label: I18nKeys.takePhoto.tr,
            icon: Icons.camera_alt_outlined,
            onTap: () => handleIntent(const AboutMeIntent.pickImage(ImageSource.camera)),
          ),
          ActionSheetOption(
            label: I18nKeys.removePhoto.tr,
            icon: Icons.delete_outline,
            color: Colors.red,
            visible: state.imageFile != null,
            onTap: () => handleIntent(const AboutMeIntent.removeImage()),
          ),
        ],
      ),
    );
  }

  /// Handle image selection from camera or gallery
  /// Updates state with the selected image file
  Future<void> _onPickImage(ImageSource source) async {
    emitEffect(
      PickImageEffect(
        source: source,
        onResult: (file) {
          handleIntent(AboutMeIntent.imagePicked(file));
        },
      ),
    );
  }

  Future<void> _onImagePicked(File? file) async {
    if (file != null) {
      updateState(state.copyWith(imageFile: file));
      
      // Perform base64 conversion and upload to backend
      final bytes = await file.readAsBytes();
      final String base64Data = base64Encode(bytes);
      final String mimeType = file.path.imageMimeType;
      final String dataUrl = 'data:$mimeType;base64,$base64Data';
      
      await call(
        ref.execute<UserModel?, String>(uploadAvatarUseCaseProvider, param: dataUrl),
        showLoading: true,
        loadingMessage: I18nKeys.uploading.tr,
        onSuccess: (userModel) {
          if (userModel != null) {
            // Update authManager state globally
            authManager.login(userModel);
            // Reset imageFile to null so the screen renders from authManager.state.user.avatarUrl
            updateState(state.copyWith(imageFile: null));
            emitEffect(MessageEffect.info(I18nKeys.avatarUploadSuccess.tr));
          }
        },
        onFailure: (failure) {
          updateState(state.copyWith(imageFile: null));
          emitEffect(MessageEffect.error(I18nKeys.avatarUploadFailed.tr));
        },
      );
    }
  }

  Future<void> _onRemoveImage() async {
    updateState(state.copyWith(imageFile: null));
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
