import 'package:flutter/material.dart';

import '../../../../../../shared/shared.dart';
import '../../../../data/models/about_me_model.dart';

class DetailedExperience extends StatelessWidget {
  final List<ExperienceItemModel> experiences;

  const DetailedExperience({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonSectionHeader(title: I18nKeys.experience.tr, showVerticalBar: true),
        SizedBox(height: 15.f),
        ...experiences.asMap().entries.map((entry) {
          final isLast = entry.key == experiences.length - 1;
          final item = entry.value;
          return CommonTimelineItem(
            title: item.title ?? '',
            subtitle: '${item.company ?? ''} | ${item.period ?? ''}',
            description: item.description ?? '',
            isLast: isLast,
          );
        }),
      ],
    );
  }
}
