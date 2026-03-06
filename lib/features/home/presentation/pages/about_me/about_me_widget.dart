import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_state.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/about_me/about_me_view_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

class AboutMeWidget extends StatelessWidget {
  final bool active;

  const AboutMeWidget({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return BaseRefreshPage<AboutMeViewModel, AboutMeState>(
      provider: aboutMeViewModelProvider,
      useScaffold: false,
      onRefresh: (viewModel, state) async {
        viewModel?.handleIntent(const AboutMeIntent.refresh());
      },
      active: active,
      body: (context, child, viewModel, state) {
        return Container(
          padding: EdgeInsets.all(20.f),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.f),
              _buildHeader(context, viewModel!, state!),
              SizedBox(height: 35.f),
              _buildBioSection(context),
              SizedBox(height: 25.f),
              _buildDetailedExperience(context),
              SizedBox(height: 25.f),
              _buildEducationSection(context),
              SizedBox(height: 25.f),
              _buildComprehensiveSkills(context),
              SizedBox(height: 40.f),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AboutMeViewModel viewModel, AboutMeState state) {
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
                    ? CommonImage.file(state.imageFile!, width: 120.f, height: 120.f, borderRadius: 60.f)
                    : CommonImage.url(
                        authManager.state.user?.avatarUrl ?? "",
                        width: 120.f,
                        height: 120.f,
                        borderRadius: 60.f,
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  color: accentColor,
                  shape: const CircleBorder(),
                  elevation: 4.f,
                  child: InkWell(
                    onTap: () => _showPickerMenu(context, viewModel, state),
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

  void _showPickerMenu(BuildContext context, AboutMeViewModel viewModel, AboutMeState state) {
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

  Widget _buildBioSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, I18nKeys.aboutMe.tr),
        SizedBox(height: 12.f),
        CommonText(
          'A seasoned mobile developer with over 10 years of experience in Android and 2+ years in Flutter. Specialized in high-performance application development, clean architecture, and reactive programming. Proven track record of leading cross-functional teams and delivering complex enterprise solutions.',
          style: context.textTheme.bodyMedium?.copyWith(height: 1.6),
          useFittedBox: false,
        ),
      ],
    );
  }

  Widget _buildDetailedExperience(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, I18nKeys.experience.tr),
        SizedBox(height: 15.f),
        _buildTimelineItem(
          context,
          'Senior Mobile Architect',
          'Global Tech Solutions',
          '2021 - ${I18nKeys.present.tr}',
          'Leading the migration of core native apps to Flutter, optimizing CI/CD pipelines, and establishing mobile engineering best practices.',
        ),
        _buildTimelineItem(
          context,
          'Lead Android Developer',
          'Innovation Hub',
          '2015 - 2021',
          'Designed and developed large-scale financial applications with millions of active users. Implemented robust security protocols.',
        ),
        _buildTimelineItem(
          context,
          'Junior Developer',
          'Start-up Inc.',
          '2013 - 2015',
          'Focusing on UI/UX implementation and RESTful API integration for Android platform.',
        ),
      ],
    );
  }

  Widget _buildEducationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, I18nKeys.education.tr),
        SizedBox(height: 15.f),
        _buildTimelineItem(
          context,
          'Bachelor of Computer Science',
          'Tech University',
          '2009 - 2013',
          'Specialized in Software Engineering and Mobile Systems.',
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildComprehensiveSkills(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, I18nKeys.coreSkills.tr),
        SizedBox(height: 15.f),
        _buildSkillCategory(context, 'Mobile', ['Flutter', 'Android Native', 'Dart', 'Kotlin', 'Java']),
        SizedBox(height: 10.f),
        _buildSkillCategory(context, 'Architecture', ['Clean Architecture', 'MVI', 'MVVM', 'SOLID']),
        SizedBox(height: 10.f),
        _buildSkillCategory(context, 'Backend & DevOps', ['Spring Boot', 'SQL', 'Docker', 'CI/CD']),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return CommonText(
      title,
      style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: context.accentColor),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String title,
    String company,
    String date,
    String desc, {
    bool isLast = false,
  }) {
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
                SizedBox(height: 6.f),
                CommonText(
                  desc,
                  style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.4),
                  useFittedBox: false,
                ),
                SizedBox(height: 20.f),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCategory(BuildContext context, String title, List<String> skills) {
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
