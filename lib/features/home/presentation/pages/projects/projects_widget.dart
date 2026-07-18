import 'package:flutter/material.dart';

import '../../../../../shared/shared.dart';
import '../../../data/models/project_model.dart';
import 'projects_intent.dart';
import 'projects_state.dart';
import 'projects_view_model.dart';
import 'widgets/project_card.dart';
import 'widgets/projects_skeleton.dart';

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
      onLoading: const ProjectsSkeleton(),
      itemSource: (state) => state.projects,
      onRefresh: (viewModel, state) async {
        viewModel.handleIntent(const ProjectsIntent.refresh());
      },
      itemBuilder: (context, viewModel, state, item, index) {
        final project = item as ProjectModel;
        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 20.f : 0),
          child: ProjectCard(
            project: project,
            baseColor: accentColor,
            onTapGithub: (url) => viewModel.handleIntent(ProjectsIntent.launchURL(url)),
          ),
        );
      },
    );
  }
}
