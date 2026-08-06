import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onTapAboutMe;
  final VoidCallback onTapArchitecture;
  final VoidCallback onTapGithub;
  final VoidCallback onTapContactMe;

  const QuickActions({
    super.key,
    required this.onTapAboutMe,
    required this.onTapArchitecture,
    required this.onTapGithub,
    required this.onTapContactMe,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = context.accentColor;
    return Column(
      children: [
        Row(
          children: [
            _buildActionCard(
              context,
              authManager.state.isAuthor ? I18nKeys.aboutMe.tr : I18nKeys.aboutAuthor.tr,
              Icons.person_outline_rounded,
              accentColor,
              onTapAboutMe,
              subtitle: I18nKeys.detailedCv.tr,
              blurLevel: AuthBlurLevel.low,
            ),
            SizedBox(width: 12.f),
            _buildActionCard(
              context,
              I18nKeys.architecture.tr,
              Icons.account_tree_outlined,
              Colors.orange,
              onTapArchitecture,
              subtitle: I18nKeys.appDesign.tr,
            ),
          ],
        ),
        SizedBox(height: 12.f),
        Row(
          children: [
            _buildActionButton(
              context,
              I18nKeys.github.tr,
              Icons.code_rounded,
              Colors.grey,
              onTapGithub,
            ),
            SizedBox(width: 12.f),
            _buildActionButton(
              context,
              authManager.state.isAuthor ? I18nKeys.contactMe.tr : I18nKeys.contactAuthor.tr,
              Icons.alternate_email_rounded,
              Colors.grey,
              onTapContactMe,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    String? subtitle,
    AuthBlurLevel blurLevel = AuthBlurLevel.none,
  }) {
    return Expanded(
      child: Material(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(20.f),
        child: CommonClickable(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.f),
          semanticLabel: title,
          child: Container(
            padding: EdgeInsets.all(16.f),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.f),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10.f,
                  offset: Offset(0, 5.f),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 28.f),
                SizedBox(height: 8.f),
                CommonAuthText(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  blurLevel: blurLevel,
                  onTap: onTap,
                  maxLines: 1,
                ),
                if (subtitle != null)
                  CommonAuthText(
                    subtitle,
                    style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                    blurLevel: blurLevel,
                    onTap: onTap,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: CommonButton(
        text: title,
        icon: icon,
        backgroundColor: context.theme.cardColor,
        foregroundColor: context.textTheme.bodyLarge?.color,
        isFullWidth: true,
        height: 48.f,
        borderRadius: 16.f,
        onPressed: onTap,
      ),
    );
  }
}
