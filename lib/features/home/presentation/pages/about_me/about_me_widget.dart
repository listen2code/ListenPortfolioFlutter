import 'package:flutter/material.dart';

import '../../../../../shared/shared.dart';
import 'about_me_intent.dart';
import 'about_me_state.dart';
import 'about_me_view_model.dart';
import 'widgets/about_me_header.dart';
import 'widgets/about_me_skeleton.dart';
import 'widgets/bio_section.dart';
import 'widgets/comprehensive_skills.dart';
import 'widgets/detailed_experience.dart';
import 'widgets/education_section.dart';

class AboutMeWidget extends StatelessWidget {
  final bool active;

  const AboutMeWidget({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return BaseRefreshPage<AboutMeViewModel, AboutMeState>(
      provider: aboutMeViewModelProvider,
      useScaffold: false,
      onRefresh: (viewModel, state) async {
        viewModel.handleIntent(const AboutMeIntent.refresh());
      },
      onLoading: const AboutMeSkeleton(),
      active: active,
      body: (context, child, viewModel, state) {
        final data = state.data;
        // Returning null triggers the default empty view in BaseRefreshPage
        if (data == null) return null;

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.f),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.f),
              AboutMeHeader(
                state: state,
                onTapCamera: () => viewModel.handleIntent(const AboutMeIntent.showPickerMenu()),
              ),
              if (data.bio != null) ...[
                SizedBox(height: 35.f),
                BioSection(
                  bio: data.bio!,
                  onTapResume: () => viewModel.handleIntent(const AboutMeIntent.toResume()),
                ),
              ],
              if (data.experiences.isNotEmpty) ...[
                SizedBox(height: 25.f),
                DetailedExperience(experiences: data.experiences),
              ],
              if (data.education.isNotEmpty) ...[
                SizedBox(height: 25.f),
                EducationSection(education: data.education),
              ],
              if (data.skills.isNotEmpty) ...[
                SizedBox(height: 25.f),
                ComprehensiveSkills(skills: data.skills),
              ],
              SizedBox(height: 40.f),
            ],
          ),
        );
      },
    );
  }
}
