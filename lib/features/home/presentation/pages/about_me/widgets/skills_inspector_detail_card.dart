import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../../../../data/models/about_me_model.dart';

class SkillsInspectorDetailCard extends StatelessWidget {
  final SkillCategoryModel category;
  final int index;
  final int totalCount;

  const SkillsInspectorDetailCard({
    super.key,
    required this.category,
    required this.index,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.f),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.f),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Category Title, Pagination Indicator and Score Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: CommonText(
                        category.category ?? '',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 6.f),
                    CommonText(
                      '(${index + 1}/$totalCount)',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                        fontSize: 10.f,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.f),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 3.f),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.f),
                ),
                child: CommonText(
                  I18nKeys.skillScore.trArgs(['${category.score}']),
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.f),

          // Animated Score Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4.f),
            child: LinearProgressIndicator(
              value: (category.score / 100.0).clamp(0.0, 1.0),
              minHeight: 5.f,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          SizedBox(height: 10.f),

          // Compact Skill Tag Chips (Multi-tag layout optimization)
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Wrap(
                spacing: 6.f,
                runSpacing: 6.f,
                children: category.items.map((skillItem) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 4.f),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6.f),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                      ),
                    ),
                    child: CommonText(
                      skillItem,
                      style: textTheme.labelSmall?.copyWith(
                        fontSize: 10.5.f,
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
