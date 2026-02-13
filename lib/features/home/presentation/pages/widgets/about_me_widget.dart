import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listen_portfolio_flutter/core/base/base_listenable_page.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

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

  void _showPickerMenu() {
    showModalBottomSheet(
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
                  _pickImage(ImageSource.gallery);
                  AppNav.back();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt_outlined, size: 24.f),
                title: CommonText(I18nKeys.takePhoto.tr),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  AppNav.back();
                },
              ),
              if (_imageFile != null)
                ListTile(
                  leading: Icon(Icons.delete_outline, color: Colors.red, size: 24.f),
                  title: CommonText(I18nKeys.removePhoto.tr, style: const TextStyle(color: Colors.red)),
                  onTap: () {
                    _removeImage();
                    AppNav.back();
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
    return BaseListenablePage(
      builder: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              _buildHeader(),
              SizedBox(height: 35),
              _buildBioSection(),
              SizedBox(height: 25),
              _buildDetailedExperience(),
              SizedBox(height: 25),
              _buildEducationSection(),
              SizedBox(height: 25),
              _buildComprehensiveSkills(),
              SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    ImageProvider avatarImage;
    if (_imageFile != null) {
      avatarImage = FileImage(_imageFile!);
    } else {
      avatarImage = const NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=Listen');
    }

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
                child: CircleAvatar(radius: 60.f, backgroundImage: avatarImage),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  color: accentColor,
                  shape: const CircleBorder(),
                  elevation: 4,
                  child: InkWell(
                    onTap: _showPickerMenu,
                    customBorder: const CircleBorder(),
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
            AppConstants.author,
            style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          CommonText(
            'Full Stack Mobile Architect',
            style: TextStyle(color: accentColor, fontSize: 16.f),
          ),
          SizedBox(height: 8.f),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on_outlined, size: 14.f, color: Colors.grey),
              SizedBox(width: 4.f),
              CommonText('Global / Remote', style: context.textTheme.bodySmall?.copyWith(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(I18nKeys.aboutMe.tr),
        SizedBox(height: 12.f),
        Text(
          'A seasoned mobile developer with over 10 years of experience in Android and 2+ years in Flutter. Specialized in high-performance application development, clean architecture, and reactive programming. Proven track record of leading cross-functional teams and delivering complex enterprise solutions.',
          style: context.textTheme.bodyMedium?.copyWith(height: 1.6),
        ),
      ],
    );
  }

  Widget _buildDetailedExperience() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(I18nKeys.experience.tr),
        SizedBox(height: 15.f),
        _buildTimelineItem(
          'Senior Mobile Architect',
          'Global Tech Solutions',
          '2021 - ${I18nKeys.present.tr}',
          'Leading the migration of core native apps to Flutter, optimizing CI/CD pipelines, and establishing mobile engineering best practices.',
        ),
        _buildTimelineItem(
          'Lead Android Developer',
          'Innovation Hub',
          '2015 - 2021',
          'Designed and developed large-scale financial applications with millions of active users. Implemented robust security protocols.',
        ),
        _buildTimelineItem(
          'Junior Developer',
          'Start-up Inc.',
          '2013 - 2015',
          'Focusing on UI/UX implementation and RESTful API integration for Android platform.',
        ),
      ],
    );
  }

  Widget _buildEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(I18nKeys.education.tr),
        SizedBox(height: 15.f),
        _buildTimelineItem(
          'Bachelor of Computer Science',
          'Tech University',
          '2009 - 2013',
          'Specialized in Software Engineering and Mobile Systems.',
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildComprehensiveSkills() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(I18nKeys.coreSkills.tr),
        SizedBox(height: 15.f),
        _buildSkillCategory('Mobile', ['Flutter', 'Android Native', 'Dart', 'Kotlin', 'Java']),
        SizedBox(height: 10.f),
        _buildSkillCategory('Architecture', ['Clean Architecture', 'MVI', 'MVVM', 'SOLID']),
        SizedBox(height: 10.f),
        _buildSkillCategory('Backend & DevOps', ['Spring Boot', 'SQL', 'Docker', 'CI/CD']),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return CommonText(
      title,
      style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: context.accentColor),
    );
  }

  Widget _buildTimelineItem(String title, String company, String date, String desc, {bool isLast = false}) {
    final accentColor = context.accentColor;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12.f,
                height: 12.f,
                decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2.f, color: accentColor.withValues(alpha: 0.2)),
                ),
            ],
          ),
          SizedBox(width: 15.f),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                CommonText(
                  '$company | $date',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6),
                Text(desc, style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.4)),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCategory(String title, List<String> skills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(title, style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 8.f),
        Wrap(
          spacing: 8.f,
          runSpacing: 8.f,
          children: skills
              .map(
                (s) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.f, vertical: 5.f),
                  decoration: BoxDecoration(
                    color: context.theme.dividerColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8.f),
                    border: Border.all(color: context.theme.dividerColor.withValues(alpha: 0.1)),
                  ),
                  child: CommonText(s, style: context.textTheme.labelSmall),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
