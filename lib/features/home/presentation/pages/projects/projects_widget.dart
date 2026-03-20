import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/projects/projects_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/projects/projects_state.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/projects/projects_view_model.dart';
import 'package:listen_portfolio_flutter/shared/extensions/string_extension.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsWidget extends StatelessWidget {
  final bool active;
  const ProjectsWidget({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    final accentColor = context.accentColor;

    return BaseRefreshPage<ProjectsViewModel, ProjectsState>(
      provider: projectsViewModelProvider,
      useScaffold: false,
      active: active,
      onLoading: _buildSkeleton(context),
      itemSource: (state) => state.projects,
      onRefresh: (viewModel, state) async {
        viewModel?.handleIntent(const ProjectsIntent.refresh());
      },
      itemBuilder: (context, item, index) {
        final project = item as ProjectModel;
        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 20.f : 0),
          child: _buildProjectCard(context, project, accentColor),
        );
      },
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 20.f, bottom: 20.f),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            margin: EdgeInsets.only(bottom: 20.f, left: 20.f, right: 20.f),
            decoration: BoxDecoration(
              color: context.theme.cardColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(24.f),
              border: Border.all(color: context.theme.dividerColor.withValues(alpha: 0.05), width: 1.f),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10.f,
                  offset: Offset(0, 5.f),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image/Header Area
                CommonSkeleton(width: double.infinity, height: 140.f, borderRadius: 0),
                Padding(
                  padding: EdgeInsets.all(20.f),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonSkeleton.line(width: 140.f, height: 20.f),
                          CommonSkeleton(width: 60.f, height: 20.f, borderRadius: 8.f),
                        ],
                      ),
                      SizedBox(height: 16.f),
                      CommonSkeleton.line(width: double.infinity, height: 14.f),
                      SizedBox(height: 8.f),
                      CommonSkeleton.line(width: 200.f, height: 14.f),
                      SizedBox(height: 20.f),
                      // Tech stack tags
                      Row(
                        children: List.generate(
                          3,
                          (i) => Padding(
                            padding: EdgeInsets.only(right: 8.f),
                            child: CommonSkeleton(width: 50.f, height: 18.f, borderRadius: 6.f),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.f),
                      // Action button (Full width skeleton)
                      CommonSkeleton(width: double.infinity, height: 36.f, borderRadius: 10.f),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, ProjectModel project, Color baseColor) {
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
          // Header: Image or Gradient
          if (hasImage)
            CommonImage.url(
              project.imageUrl!.toApiUrl(),
              width: double.infinity,
              height: 140.f,
              fit: BoxFit.cover,
            )
          else
            Container(
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
          // Content Section
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
                    if (project.subtitle != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.f, vertical: 4.f),
                        decoration: BoxDecoration(
                          color: isTodo
                              ? Colors.grey.withValues(alpha: 0.1)
                              : baseColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.f),
                        ),
                        child: CommonText(
                          project.subtitle!,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: isTodo ? Colors.grey : baseColor,
                            fontWeight: FontWeight.w600,
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
                if (project.techStack.isNotEmpty) ...[
                  SizedBox(height: 16.f),
                  Wrap(
                    spacing: 8.f,
                    runSpacing: 8.f,
                    children: project.techStack
                        .map((tech) => _buildTechTag(context, tech, baseColor))
                        .toList(),
                  ),
                ],
                SizedBox(height: 20.f),
                // Only show Source Code button if githubUrl exists
                if (!isTodo && project.githubUrl != null)
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionChip(
                          context,
                          Icons.code,
                          'Source Code',
                          baseColor,
                          onPressed: () => _launchURL(context, project.githubUrl!),
                        ),
                      ),
                    ],
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
      child: Text(
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
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10.f),
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

  Future<void> _launchURL(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      if (context.mounted) {
        CommonToast.show('Could not launch $urlString');
      }
    }
  }
}
