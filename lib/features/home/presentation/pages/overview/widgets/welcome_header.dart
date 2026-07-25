import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../../../../../auth/data/models/user_model.dart';
import '../overview_state.dart';

class WelcomeHeader extends StatelessWidget {
  final UserModel? userModel;
  final OverviewState state;

  const WelcomeHeader({
    super.key,
    required this.userModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = context.accentColor;
    final String name = userModel?.name ?? AppConstants.author;
    final String jobTitle = state.aboutMe?.jobTitle ?? 'Senior Android / Flutter Engineer';
    final String graduationYear = state.aboutMe?.graduationYear ?? '2013';
    final String major = state.aboutMe?.major?.tr ?? I18nKeys.softwareEngineering.tr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          I18nKeys.hello.trArgs([name]),
          style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 1,
        ),
        SizedBox(height: 4.f),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CommonText(
              '$jobTitle (${I18nKeys.graduated.tr}',
              style: context.textTheme.labelSmall?.copyWith(color: accentColor, fontWeight: FontWeight.w600),
              maxLines: 1,
            ),
            CommonAuthText(
              ' $graduationYear ',
              style: context.textTheme.labelSmall?.copyWith(color: accentColor, fontWeight: FontWeight.w600),
              maxLines: 1,
              blurLevel: AuthBlurLevel.low,
            ),
            CommonAuthText(
              '| $major)',
              style: context.textTheme.labelSmall?.copyWith(color: accentColor, fontWeight: FontWeight.w600),
              maxLines: 1,
              blurLevel: AuthBlurLevel.low,
            ),
          ],
        ),
        SizedBox(height: 8.f),
        // Certifications section
        if (state.aboutMe?.certifications != null || userModel == null)
          Row(
            children: (state.aboutMe?.certifications ?? [I18nKeys.jlptN1, I18nKeys.bjtJ2])
                .map(
                  (certKey) => Padding(
                    padding: EdgeInsets.only(right: 8.f),
                    child: _buildCertBadge(accentColor, certKey.tr),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildCertBadge(Color color, String label) {
    return CommonBadge(
      icon: Icons.workspace_premium_outlined,
      iconSize: 12.f,
      color: color.withValues(alpha: 0.1),
      borderColor: color.withValues(alpha: 0.3),
      borderWidth: 0.5.f,
      borderRadius: 6.f,
      padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 3.f),
      spacing: 4.f,
      child: CommonAuthText(
        label,
        style: TextStyle(color: color, fontSize: 10.f, fontWeight: FontWeight.w600),
        blurLevel: AuthBlurLevel.low,
      ),
    );
  }
}
