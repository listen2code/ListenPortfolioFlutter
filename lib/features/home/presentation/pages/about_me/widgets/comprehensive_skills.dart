import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../../../../data/models/about_me_model.dart';

class ComprehensiveSkills extends StatelessWidget {
  final List<SkillCategoryModel> skills;

  const ComprehensiveSkills({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonSectionHeader(title: I18nKeys.coreSkills.tr, showVerticalBar: true),
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
