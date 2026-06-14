import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';
import '../../../data/models/about_me_model.dart';
import 'about_me_intent.dart';
import 'about_me_state.dart';
import 'about_me_view_model.dart';

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
      onLoading: _buildSkeleton(context),
      active: active,
      body: (context, child, viewModel, state) {
        final data = state?.data;
        // Returning null triggers the default empty view in BaseRefreshPage
        if (data == null) return null;

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.f),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.f),
              _buildHeader(context, viewModel!, state!),
              if (data.bio != null) ...[SizedBox(height: 35.f), _buildBioSection(context, data.bio!)],
              if (data.experiences.isNotEmpty) ...[
                SizedBox(height: 25.f),
                _buildDetailedExperience(context, data.experiences),
              ],
              if (data.education.isNotEmpty) ...[
                SizedBox(height: 25.f),
                _buildEducationSection(context, data.education),
              ],
              if (data.skills.isNotEmpty) ...[
                SizedBox(height: 25.f),
                _buildComprehensiveSkills(context, data.skills),
              ],
              SizedBox(height: 40.f),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.f),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.f),
          // Header Skeleton
          Center(
            child: Column(
              children: [
                CommonSkeleton.circle(size: 120.f),
                SizedBox(height: 16.f),
                CommonSkeleton.line(width: 150.f, height: 24.f),
                SizedBox(height: 8.f),
                CommonSkeleton.line(width: 200.f, height: 16.f),
                SizedBox(height: 8.f),
                CommonSkeleton.line(width: 100.f, height: 14.f),
              ],
            ),
          ),
          SizedBox(height: 35.f),
          // Bio Skeleton
          CommonSkeleton.line(width: 100.f, height: 20.f),
          SizedBox(height: 12.f),
          CommonSkeleton.line(width: double.infinity, height: 14.f),
          SizedBox(height: 8.f),
          CommonSkeleton.line(width: double.infinity, height: 14.f),
          SizedBox(height: 8.f),
          CommonSkeleton.line(width: 200.f, height: 14.f),
          SizedBox(height: 25.f),
          // Timeline Section Skeleton (Experience/Education)
          CommonSkeleton.line(width: 120.f, height: 20.f),
          SizedBox(height: 15.f),
          ...List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 20.f),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        CommonSkeleton.circle(size: 12.f),
                        Expanded(
                          child: Container(
                            width: 2.f,
                            margin: EdgeInsets.symmetric(vertical: 4.f),
                            color: context.theme.dividerColor.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 15.f),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonSkeleton.line(width: 180.f, height: 16.f),
                          SizedBox(height: 4.f),
                          CommonSkeleton.line(width: 120.f, height: 12.f),
                          SizedBox(height: 8.f),
                          CommonSkeleton.line(width: double.infinity, height: 14.f),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
                        authManager.state.user?.avatarUrl ?? '',
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
              CommonText(I18nKeys.locationJapanTokyo.tr, style: context.textTheme.bodySmall?.copyWith(color: Colors.grey)),
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

  Widget _buildBioSection(BuildContext context, String bio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, I18nKeys.aboutMe.tr),
        SizedBox(height: 12.f),
        CommonText(bio, style: context.textTheme.bodyMedium?.copyWith(height: 1.6), useFittedBox: false),
      ],
    );
  }

  Widget _buildDetailedExperience(BuildContext context, List<ExperienceItemModel> experiences) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, I18nKeys.experience.tr),
        SizedBox(height: 15.f),
        ...experiences.asMap().entries.map((entry) {
          final isLast = entry.key == experiences.length - 1;
          final item = entry.value;
          return _buildTimelineItem(
            context,
            item.title ?? '',
            item.company ?? '',
            item.period ?? '',
            item.description ?? '',
            isLast: isLast,
          );
        }),
      ],
    );
  }

  Widget _buildEducationSection(BuildContext context, List<EducationItemModel> education) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, I18nKeys.education.tr),
        SizedBox(height: 15.f),
        ...education.asMap().entries.map((entry) {
          final isLast = entry.key == education.length - 1;
          final item = entry.value;
          return _buildTimelineItem(
            context,
            item.degree ?? '',
            item.school ?? '',
            item.period ?? '',
            item.description ?? '',
            isLast: isLast,
          );
        }),
      ],
    );
  }

  Widget _buildComprehensiveSkills(BuildContext context, List<SkillCategoryModel> skills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, I18nKeys.coreSkills.tr),
        SizedBox(height: 15.f),
        ...skills.map(
          (s) => Padding(
            padding: EdgeInsets.only(bottom: 10.f),
            child: _buildSkillCategory(context, s.category ?? '', s.items),
          ),
        ),
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
