import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class BioSection extends StatelessWidget {
  final String bio;
  final VoidCallback onTapResume;

  const BioSection({
    super.key,
    required this.bio,
    required this.onTapResume,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonSectionHeader(
          title: authManager.state.isAuthor ? I18nKeys.aboutMe.tr : I18nKeys.aboutAuthor.tr,
          showVerticalBar: true,
        ),
        SizedBox(height: 12.f),
        CommonText(bio, style: context.textTheme.bodyMedium?.copyWith(height: 1.6), useFittedBox: false),
        SizedBox(height: 16.f),
        SizedBox(
          width: double.infinity,
          child: CommonClickable(
            onTap: onTapResume,
            borderRadius: BorderRadius.circular(12.f),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.f, vertical: 12.f),
              decoration: BoxDecoration(
                border: Border.all(color: context.accentColor.withValues(alpha: 0.3), width: 1.f),
                borderRadius: BorderRadius.circular(12.f),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description_outlined, size: 16.f, color: context.accentColor),
                  SizedBox(width: 8.f),
                  Flexible(
                    child: CommonText(
                      authManager.state.isAuthor ? I18nKeys.viewFullResume.tr : I18nKeys.authorResume.tr,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
