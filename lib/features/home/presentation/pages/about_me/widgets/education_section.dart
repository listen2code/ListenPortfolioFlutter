import 'package:flutter/material.dart';

import '../../../../../../shared/shared.dart';
import '../../../../data/models/about_me_model.dart';

class EducationSection extends StatelessWidget {
  final List<EducationItemModel> education;

  const EducationSection({super.key, required this.education});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonSectionHeader(title: I18nKeys.education.tr, showVerticalBar: true),
        SizedBox(height: 15.f),
        ...education.asMap().entries.map((entry) {
          final isLast = entry.key == education.length - 1;
          final item = entry.value;
          return CommonTimelineItem(
            title: item.degree ?? '',
            subtitle: '${item.school ?? ''} | ${item.period ?? ''}',
            description: item.description ?? '',
            isLast: isLast,
          );
        }),
      ],
    );
  }
}
