import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../../../../data/models/project_model.dart';

class FeaturedProjectsSection extends StatelessWidget {
  final List<ProjectModel> projects;
  final VoidCallback onViewAllPressed;
  final ValueChanged<ProjectModel>? onProjectTap;

  const FeaturedProjectsSection({
    super.key,
    required this.projects,
    required this.onViewAllPressed,
    this.onProjectTap,
  });

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) return const SizedBox.shrink();
    final accentColor = context.accentColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.f),
          child: CommonSectionHeader(
            title: authManager.state.isAuthor ? I18nKeys.myFeaturedProjects.tr : I18nKeys.authorFeaturedProjects.tr,
            trailing: CommonButton(
              text: I18nKeys.viewAll.tr,
              type: ButtonType.text,
              isFullWidth: false,
              height: 32.f,
              fontSize: 12.f,
              padding: EdgeInsets.symmetric(horizontal: 8.f),
              onPressed: onViewAllPressed,
            ),
          ),
        ),
        SizedBox(height: 12.f),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20.f),
          child: Row(
            children: projects.asMap().entries.map((entry) {
              final index = entry.key;
              final project = entry.value;
              return Padding(
                padding: EdgeInsets.only(right: index == projects.length - 1 ? 0 : 16.f),
                child: CommonClickable(
                  onTap: () => onProjectTap?.call(project),
                  borderRadius: BorderRadius.circular(24.f),
                  semanticLabel: project.title ?? '',
                  child: _buildProjectCard(
                    context,
                    project.title ?? '',
                    project.subtitle ?? '',
                    Icons.rocket_launch_rounded, // Default icon for projects
                    accentColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectCard(BuildContext context, String title, String tag, IconData icon, Color color) {
    return Container(
      width: 260.f,
      padding: EdgeInsets.all(20.f),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(24.f),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15.f, offset: Offset(0, 8.f)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10.f),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 24.f),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: CommonBadge(
                  text: tag,
                  color: Colors.blue.withValues(alpha: 0.05),
                  textColor: Colors.blue,
                  fontSize: 10.f,
                  borderRadius: 8.f,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.f),
          CommonText(
            title,
            style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
