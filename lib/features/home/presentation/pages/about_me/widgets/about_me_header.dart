import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../about_me_intent.dart';
import '../about_me_state.dart';
import '../about_me_view_model.dart';

class AboutMeHeader extends StatelessWidget {
  final AboutMeViewModel viewModel;
  final AboutMeState state;

  const AboutMeHeader({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = context.accentColor;
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(3.f),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor, width: 2.f),
                ),
                child: state.imageFile != null
                    ? CommonImage.file(
                        state.imageFile!,
                        width: 120.f,
                        height: 120.f,
                        borderRadius: 60.f,
                        semanticLabel: I18nKeys.profilePhotoSemanticLabel.tr,
                      )
                    : CommonImage.url(
                        authManager.state.user?.avatarUrl ?? '',
                        width: 120.f,
                        height: 120.f,
                        borderRadius: 60.f,
                        semanticLabel: I18nKeys.profilePhotoSemanticLabel.tr,
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  color: accentColor,
                  shape: const CircleBorder(),
                  elevation: 4.f,
                  child: CommonClickable(
                    onTap: () => _showPickerMenu(context, viewModel, state),
                    borderRadius: BorderRadius.circular(20.f),
                    semanticLabel: I18nKeys.changeProfilePhoto.tr,
                    child: Padding(
                      padding: EdgeInsets.all(8.f),
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 20.f),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.f),
          CommonText(
            authManager.state.user?.name ?? AppConstants.author,
            style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          CommonText(
            state.data?.jobTitle ?? 'Senior Android / Flutter Engineer',
            style: TextStyle(color: accentColor, fontSize: 16.f),
          ),
          SizedBox(height: 8.f),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on_outlined, size: 14.f, color: Colors.grey),
              SizedBox(width: 4.f),
              CommonText(
                I18nKeys.locationJapanTokyo.tr,
                style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPickerMenu(BuildContext context, AboutMeViewModel viewModel, AboutMeState state) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.f))),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library_outlined, size: 24.f),
                title: CommonText(I18nKeys.chooseFromGallery.tr),
                onTap: () {
                  viewModel.handleIntent(const AboutMeIntent.pickImage(ImageSource.gallery));
                  AppNav.back();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt_outlined, size: 24.f),
                title: CommonText(I18nKeys.takePhoto.tr),
                onTap: () {
                  viewModel.handleIntent(const AboutMeIntent.pickImage(ImageSource.camera));
                  AppNav.back();
                },
              ),
              if (state.imageFile != null)
                ListTile(
                  leading: Icon(Icons.delete_outline, color: Colors.red, size: 24.f),
                  title: CommonText(I18nKeys.removePhoto.tr, style: const TextStyle(color: Colors.red)),
                  onTap: () {
                    viewModel.handleIntent(const AboutMeIntent.removeImage());
                    AppNav.back();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
