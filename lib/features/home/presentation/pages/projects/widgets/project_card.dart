import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../../../../data/models/project_model.dart';
import '../projects_intent.dart';
import '../projects_view_model.dart';

class ProjectCard extends StatelessWidget {
  final ProjectsViewModel viewModel;
  final ProjectModel project;
  final Color baseColor;

  const ProjectCard({
    super.key,
    required this.viewModel,
    required this.project,
    required this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTodo = project.subtitle == 'TODO';
    final hasImage = project.imageUrl != null && project.imageUrl!.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: 20.f, left: 20.f, right: 20.f),
      decoration: BoxDecoration(
        color: context.theme.cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24.f),
        border: Border.all(color: baseColor.withValues(alpha: 0.15), width: 1.f),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10.f, offset: Offset(0, 5.f)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: hasImage,
            replacement: Container(
              height: 120.f,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [baseColor, baseColor.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  isTodo ? Icons.hourglass_empty_rounded : Icons.rocket_launch_rounded,
                  size: 48.f,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ),
            child: hasImage
                ? CommonImage.url(
                    project.imageUrl!.toApiUrl(),
                    width: double.infinity,
                    height: 140.f,
                    fit: BoxFit.cover,
                    semanticLabel: I18nKeys.projectCoverSemanticLabel.tr,
                  )
                : const SizedBox.shrink(),
          ),
          Padding(
            padding: EdgeInsets.all(20.f),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CommonText(
                        project.title ?? '',
                        style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Visibility(
                      visible: project.subtitle != null,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.f, vertical: 4.f),
                        decoration: BoxDecoration(
                          color: isTodo
                              ? Colors.grey.withValues(alpha: 0.1)
                              : baseColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.f),
                        ),
                        child: CommonText(
                          project.subtitle ?? '',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: isTodo ? Colors.grey : baseColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.f),
                CommonText(
                  project.desc ?? '',
                  style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5),
                  useFittedBox: false,
                ),
                Visibility(
                  visible: project.techStack.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.f),
                      Wrap(
                        spacing: 8.f,
                        runSpacing: 8.f,
                        children: project.techStack
                            .map((tech) => _buildTechTag(context, tech, baseColor))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !isTodo && project.githubUrl != null,
                  child: Column(
                    children: [
                      SizedBox(height: 20.f),
                      SizedBox(
                        width: double.infinity,
                        child: _buildActionChip(
                          context,
                          Icons.code,
                          I18nKeys.sourceCode.tr,
                          baseColor,
                          onPressed: () => viewModel.handleIntent(ProjectsIntent.launchURL(project.githubUrl!)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechTag(BuildContext context, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 4.f),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6.f),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: CommonText(
        label,
        style: TextStyle(color: color, fontSize: 10.f, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildActionChip(
    BuildContext context,
    IconData icon,
    String label,
    Color color, {
    required VoidCallback onPressed,
  }) {
    return CommonClickable(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10.f),
      semanticLabel: label,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.f, vertical: 8.f),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.f),
          borderRadius: BorderRadius.circular(10.f),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14.f, color: color),
            SizedBox(width: 6.f),
            Flexible(
              child: CommonText(
                label,
                style: context.textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
