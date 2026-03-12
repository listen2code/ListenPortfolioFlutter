import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/projects/projects_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/projects/projects_state.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/projects/projects_view_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

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
        return _buildProjectCard(
          context,
          project.title ?? '',
          project.subtitle ?? '',
          project.desc ?? '',
          accentColor,
        );
      },
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 20.f),
      itemCount: 3,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 20.f, left: 20.f, right: 20.f),
        decoration: BoxDecoration(
          color: context.theme.cardColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24.f),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonSkeleton(width: double.infinity, height: 120.f, borderRadius: 0),
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
                  SizedBox(height: 24.f),
                  Row(
                    children: [
                      Expanded(
                        child: CommonSkeleton(height: 36.f, borderRadius: 10.f),
                      ),
                      SizedBox(width: 12.f),
                      Expanded(
                        child: CommonSkeleton(height: 36.f, borderRadius: 10.f),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(
    BuildContext context,
    String title,
    String subtitle,
    String desc,
    Color baseColor,
  ) {
    final bool isTodo = subtitle == 'TODO';

    return Container(
      margin: EdgeInsets.only(bottom: 20.f, left: 20, right: 20),
      decoration: BoxDecoration(
        color: context.theme.cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24.f),
        border: Border.all(color: baseColor.withValues(alpha: 0.2), width: 1.f),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10.f, offset: Offset(0, 5.f)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Gradient with Icon
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
                        title,
                        style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.f, vertical: 4.f),
                      decoration: BoxDecoration(
                        color: isTodo ? Colors.grey.withValues(alpha: 0.1) : baseColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.f),
                      ),
                      child: CommonText(
                        subtitle,
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
                  desc,
                  style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5),
                  useFittedBox: false,
                ),
                SizedBox(height: 20.f),
                if (!isTodo)
                  Row(
                    children: [
                      Expanded(child: _buildActionChip(context, Icons.link, 'Live Demo', baseColor)),
                      SizedBox(width: 12.f),
                      Expanded(child: _buildActionChip(context, Icons.code, 'Source Code', Colors.grey)),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(BuildContext context, IconData icon, String label, Color color) {
    return Container(
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
    );
  }
}
