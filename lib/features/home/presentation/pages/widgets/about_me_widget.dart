import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';

class AboutMeWidget extends StatefulWidget {
  const AboutMeWidget({super.key});

  @override
  State<AboutMeWidget> createState() => _AboutMeWidgetState();
}

class _AboutMeWidgetState extends State<AboutMeWidget> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  void _showPickerMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(I18nKeys.chooseFromGallery.tr),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(I18nKeys.takePhoto.tr),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              if (_imageFile != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: Text(I18nKeys.removePhoto.tr, style: const TextStyle(color: Colors.red)),
                  onTap: () {
                    _removeImage();
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = settingManager.accentColor;

    return BaseStatelessPage(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          _buildHeader(context, theme, accentColor),
          const SizedBox(height: 35),
          _buildBioSection(theme, accentColor),
          const SizedBox(height: 25),
          _buildDetailedExperience(theme, accentColor),
          const SizedBox(height: 25),
          _buildEducationSection(theme, accentColor),
          const SizedBox(height: 25),
          _buildComprehensiveSkills(theme, accentColor),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, Color accentColor) {
    ImageProvider avatarImage;
    if (_imageFile != null) {
      avatarImage = FileImage(_imageFile!);
    } else {
      avatarImage = const NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=Listen');
    }

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor, width: 2),
                ),
                child: CircleAvatar(radius: 60, backgroundImage: avatarImage),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  color: accentColor,
                  shape: const CircleBorder(),
                  elevation: 4,
                  child: InkWell(
                    onTap: () => _showPickerMenu(context),
                    customBorder: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(AppConstants.author, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          Text('Full Stack Mobile Architect', style: TextStyle(color: accentColor, fontSize: 16)),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
              SizedBox(width: 4),
              Text('Global / Remote', style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection(ThemeData theme, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(I18nKeys.aboutMe.tr, accentColor),
        const SizedBox(height: 12),
        Text(
          'A seasoned mobile developer with over 10 years of experience in Android and 2+ years in Flutter. Specialized in high-performance application development, clean architecture, and reactive programming. Proven track record of leading cross-functional teams and delivering complex enterprise solutions.',
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
        ),
      ],
    );
  }

  Widget _buildDetailedExperience(ThemeData theme, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(I18nKeys.experience.tr, accentColor),
        const SizedBox(height: 15),
        _buildTimelineItem(
          theme,
          accentColor,
          'Senior Mobile Architect',
          'Global Tech Solutions',
          '2021 - ${I18nKeys.present.tr}',
          'Leading the migration of core native apps to Flutter, optimizing CI/CD pipelines, and establishing mobile engineering best practices.',
        ),
        _buildTimelineItem(
          theme,
          accentColor,
          'Lead Android Developer',
          'Innovation Hub',
          '2015 - 2021',
          'Designed and developed large-scale financial applications with millions of active users. Implemented robust security protocols.',
        ),
        _buildTimelineItem(
          theme,
          accentColor,
          'Junior Developer',
          'Start-up Inc.',
          '2013 - 2015',
          'Focusing on UI/UX implementation and RESTful API integration for Android platform.',
        ),
      ],
    );
  }

  Widget _buildEducationSection(ThemeData theme, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(I18nKeys.education.tr, accentColor),
        const SizedBox(height: 15),
        _buildTimelineItem(
          theme,
          accentColor,
          'Bachelor of Computer Science',
          'Tech University',
          '2009 - 2013',
          'Specialized in Software Engineering and Mobile Systems.',
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildComprehensiveSkills(ThemeData theme, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(I18nKeys.coreSkills.tr, accentColor),
        const SizedBox(height: 15),
        _buildSkillCategory(theme, 'Mobile', ['Flutter', 'Android Native', 'Dart', 'Kotlin', 'Java']),
        const SizedBox(height: 10),
        _buildSkillCategory(theme, 'Architecture', ['Clean Architecture', 'MVI', 'MVVM', 'SOLID']),
        const SizedBox(height: 10),
        _buildSkillCategory(theme, 'Backend & DevOps', ['Spring Boot', 'SQL', 'Docker', 'CI/CD']),
      ],
    );
  }

  Widget _buildSectionTitle(String title, Color accentColor) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: accentColor),
    );
  }

  Widget _buildTimelineItem(
    ThemeData theme,
    Color accentColor,
    String title,
    String company,
    String date,
    String desc, {
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
              ),
              if (!isLast) Expanded(child: Container(width: 2, color: accentColor.withValues(alpha: 0.2))),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                  '$company | $date',
                  style: TextStyle(color: accentColor, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(desc, style: const TextStyle(color: Colors.grey, height: 1.4, fontSize: 14)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCategory(ThemeData theme, String title, List<String> skills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills
              .map(
                (s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: theme.dividerColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
                  ),
                  child: Text(s, style: const TextStyle(fontSize: 12)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
