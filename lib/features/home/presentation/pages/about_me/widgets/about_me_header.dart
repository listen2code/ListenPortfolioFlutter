import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../about_me_state.dart';

class AboutMeHeader extends StatelessWidget {
  final AboutMeState state;
  final VoidCallback onTapCamera;
  final VoidCallback? onTapAvatar;

  const AboutMeHeader({super.key, required this.state, required this.onTapCamera, this.onTapAvatar});

  @override
  Widget build(BuildContext context) {
    final accentColor = context.accentColor;
    final imageFile = state.imageFile;

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CommonClickable(
                ripple: false,
                onTap: onTapAvatar,
                child: Container(
                  padding: EdgeInsets.all(3.f),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: accentColor, width: 2.f),
                  ),
                  child: Hero(
                    tag: 'avatar_preview',
                    child: imageFile != null
                        ? CommonImage.file(
                            imageFile,
                            width: 120.f,
                            height: 120.f,
                            borderRadius: 60.f,
                            semanticLabel: I18nKeys.profilePhotoSemanticLabel.tr,
                          )
                        : Visibility(
                            visible: authManager.state.user?.avatarUrl?.isNotEmpty == true,
                            replacement: Container(
                              width: 120.f,
                              height: 120.f,
                              decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                              child: Icon(Icons.person, size: 35.f, color: Colors.white70),
                            ),
                            child: CommonImage.url(
                              authManager.state.user?.avatarUrl ?? '',
                              width: 120.f,
                              height: 120.f,
                              borderRadius: 60.f,
                              semanticLabel: I18nKeys.profilePhotoSemanticLabel.tr,
                            ),
                          ),
                  ),
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
                    onTap: onTapCamera,
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
}
