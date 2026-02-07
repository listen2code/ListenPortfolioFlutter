import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingManager,
      builder: (context, child) {
        final theme = Theme.of(context);
        final accentColor = settingManager.accentColor;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildHeader(context, theme, accentColor),
                const SizedBox(height: 30),
                _buildAboutSection(theme, accentColor),
                const SizedBox(height: 25),
                _buildSkillsSection(theme, accentColor),
                const SizedBox(height: 25),
                _buildExperienceSection(theme, accentColor),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, Color accentColor) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [accentColor, accentColor.withValues(alpha: 0.6)]),
                boxShadow: [BoxShadow(color: accentColor.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: const CircleAvatar(
                radius: 65,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=Listen'),
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: GestureDetector(
                onTap: () => _showImageSourceActionSheet(context, accentColor),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 5)],
                  ),
                  child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(AppConstants.author, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(
          'Senior Flutter Developer',
          style: TextStyle(fontSize: 16, color: accentColor, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit_note_rounded, size: 18),
          label: Text(I18nKeys.editInformation.tr),
          style: OutlinedButton.styleFrom(
            foregroundColor: accentColor,
            side: BorderSide(color: accentColor, width: 1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text('San Francisco, CA', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  void _showImageSourceActionSheet(BuildContext context, Color accentColor) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(I18nKeys.changeProfilePhoto.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: accentColor),
              title: Text(I18nKeys.chooseFromGallery.tr),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined, color: accentColor),
              title: Text(I18nKeys.takePhoto.tr),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              title: Text(I18nKeys.removePhoto.tr, style: const TextStyle(color: Colors.redAccent)),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(ThemeData theme, Color accentColor) {
    return _buildCard(
      theme: theme,
      accentColor: accentColor,
      title: I18nKeys.aboutMe.tr,
      child: Text(
        'Passionate Flutter developer with 5+ years of experience in building high-quality, cross-platform mobile applications. I love turning complex problems into simple, beautiful, and intuitive designs.',
        style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
      ),
    );
  }

  Widget _buildSkillsSection(ThemeData theme, Color accentColor) {
    final skills = ['Flutter', 'Dart', 'Clean Architecture', 'Riverpod', 'Firebase', 'REST API', 'Git', 'CI/CD'];
    return _buildCard(
      theme: theme,
      accentColor: accentColor,
      title: I18nKeys.coreSkills.tr,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: skills.map((skill) => _buildSkillChip(skill, accentColor)).toList(),
      ),
    );
  }

  Widget _buildExperienceSection(ThemeData theme, Color accentColor) {
    return _buildCard(
      theme: theme,
      accentColor: accentColor,
      title: I18nKeys.experience.tr,
      child: Column(
        children: [
          _buildExperienceItem(theme, 'Senior Developer', 'Tech Corp', '2020 - ${I18nKeys.present.tr}'),
          Divider(height: 30, color: theme.dividerColor.withValues(alpha: 0.1)),
          _buildExperienceItem(theme, 'Mobile Developer', 'App Studio', '2018 - 2020'),
        ],
      ),
    );
  }

  Widget _buildCard({required ThemeData theme, required Color accentColor, required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accentColor),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(
        label,
        style: TextStyle(color: accentColor, fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }

  Widget _buildExperienceItem(ThemeData theme, String role, String company, String period) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.work_outline, color: Colors.grey, size: 20),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(company, style: const TextStyle(color: Colors.grey)),
              Text(period, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
