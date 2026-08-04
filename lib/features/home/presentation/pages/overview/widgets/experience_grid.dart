import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../../../../data/models/about_me_model.dart';
import '../overview_state.dart';

enum ExperienceType {
  android,
  flutter,
  javaWeb,
  unknown;

  static ExperienceType fromString(String? val) {
    switch (val?.toLowerCase()) {
      case 'android':
        return ExperienceType.android;
      case 'flutter':
        return ExperienceType.flutter;
      case 'java_web':
        return ExperienceType.javaWeb;
      default:
        return ExperienceType.unknown;
    }
  }

  IconData get icon {
    switch (this) {
      case ExperienceType.android:
        return Icons.android_rounded;
      case ExperienceType.flutter:
        return Icons.flutter_dash_rounded;
      case ExperienceType.javaWeb:
        return Icons.code_rounded;
      case ExperienceType.unknown:
        return Icons.help_outline_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ExperienceType.android:
        return Colors.green;
      case ExperienceType.flutter:
        return Colors.blue;
      case ExperienceType.javaWeb:
        return Colors.orange;
      case ExperienceType.unknown:
        return Colors.grey;
    }
  }
}

class ExperienceGrid extends StatelessWidget {
  final OverviewState state;

  const ExperienceGrid({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    // If not logged in, we provide default experience data based on user.json logic
    final List<AboutMeStatModel> stats =
        state.aboutMe?.stats ??
        const [
          AboutMeStatModel(
            id: '1',
            businessId: 'android',
            year: '11',
            label: I18nKeys.androidExp,
            tags: [I18nKeys.archDesign, I18nKeys.perfOptimization],
          ),
          AboutMeStatModel(id: '2', businessId: 'flutter', year: '3', label: I18nKeys.flutterExp),
          AboutMeStatModel(id: '3', businessId: 'java_web', year: '1', label: I18nKeys.javaWeb),
        ];

    if (stats.isEmpty) return const SizedBox.shrink();

    final mainExp = stats.first;
    final mainExpType = ExperienceType.fromString(mainExp.businessId);
    final otherExps = stats.skip(1).toList();

    return Column(
      children: [
        _buildHighlightStatCard(
          context,
          '${mainExp.year}${I18nKeys.yearsShort.tr}+',
          mainExp.label ?? '',
          mainExpType.icon,
          mainExpType.color,
          tags: mainExp.tags,
        ),
        if (otherExps.isNotEmpty) ...[
          SizedBox(height: 12.f),
          Row(
            children: [
              for (int i = 0; i < otherExps.length; i++) ...[
                Visibility(
                  visible: i > 0,
                  child: SizedBox(width: 12.f),
                ),
                _buildStatCardFromModel(context, otherExps[i]),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStatCardFromModel(BuildContext context, AboutMeStatModel model) {
    final expType = ExperienceType.fromString(model.businessId);
    return _buildStatCard(
      context,
      '${model.year}${I18nKeys.yearsShort.tr}+',
      model.label ?? '',
      expType.icon,
      expType.color,
    );
  }

  Widget _buildHighlightStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color iconColor, {
    List<String>? tags,
  }) {
    return Container(
      padding: EdgeInsets.all(16.f),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(20.f),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10.f, offset: Offset(0, 5.f)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 32.f),
          SizedBox(width: 16.f),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonAuthText(
                  value,
                  style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  blurLevel: AuthBlurLevel.medium,
                  maxLines: 1,
                ),
                SizedBox(height: 4.f),
                CommonText(
                  label,
                  style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          if (tags != null && tags.isNotEmpty) ...[
            SizedBox(width: 10.f),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: tags
                  .take(2)
                  .map(
                    (tag) => Padding(
                      padding: EdgeInsets.only(bottom: 4.f),
                      child: _buildTag(tag, iconColor),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return CommonBadge(
      text: label,
      color: color.withValues(alpha: 0.1),
      textColor: color,
      borderRadius: 6.f,
      padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 2.f),
      fontSize: 10.f,
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color iconColor,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.f, vertical: 10.f),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(20.f),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10.f, offset: Offset(0, 5.f)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24.f),
            SizedBox(width: 10.f),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonAuthText(
                    value,
                    style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    blurLevel: AuthBlurLevel.medium,
                    maxLines: 1,
                  ),
                  CommonText(
                    label,
                    style: context.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11.f),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
