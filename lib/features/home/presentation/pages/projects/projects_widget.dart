import 'package:flutter/material.dart';

import '../../../../../shared/shared.dart';
import '../../../data/models/project_model.dart';
import 'projects_intent.dart';
import 'projects_state.dart';
import 'projects_view_model.dart';
import 'widgets/project_card.dart';
import 'widgets/projects_skeleton.dart';

class ProjectsWidget extends StatefulWidget {
  final bool active;
  const ProjectsWidget({super.key, required this.active});

  @override
  State<ProjectsWidget> createState() => _ProjectsWidgetState();
}

class _ProjectsWidgetState extends State<ProjectsWidget> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _itemKeys = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = context.accentColor;

    return BaseRefreshPage<ProjectsViewModel, ProjectsState>(
      provider: projectsViewModelProvider,
      useScaffold: false,
      active: widget.active,
      scrollController: _scrollController,
      onLoading: const ProjectsSkeleton(),
      itemSource: (state) => state.projects,
      onEffect: (effect) {
        if (effect is ScrollToProjectEffect) {
          // Step 1: Introduce a short delay (100ms) to allow TabBar page transition 
          // animations and initial layout measurements to stabilize before scrolling.
          Future.delayed(const Duration(milliseconds: 100), () {
            if (!mounted) return;

            final key = _itemKeys[effect.index];
            // Step 2: If the target item is far off-screen, its Widget/RenderObject has not 
            // been mounted yet due to ListView's lazy-loading. We perform a silent `jumpTo` 
            // to instantly bring the estimated position into view and force Element mounting, 
            // avoiding choppy secondary adjustment animations.
            if (key?.currentContext == null && _scrollController.hasClients) {
              final estimatedOffset = (effect.index * 360.0).clamp(0.0, _scrollController.position.maxScrollExtent);
              _scrollController.jumpTo(estimatedOffset);
            }

            // Step 3: Once the target item Element is mounted, execute a single, uninterrupted, 
            // smooth `ensureVisible` animation in the next frame for pixel-exact alignment.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final targetKey = _itemKeys[effect.index];
              if (targetKey?.currentContext != null) {
                Scrollable.ensureVisible(
                  targetKey!.currentContext!,
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeInOutCubic,
                  alignment: 0.05,
                );
              }
            });
          });
        }
      },
      onRefresh: (viewModel, state) async {
        viewModel.handleIntent(const ProjectsIntent.refresh());
      },
      itemBuilder: (context, viewModel, state, item, index) {
        final project = item as ProjectModel;
        _itemKeys[index] ??= GlobalKey();

        return Container(
          key: _itemKeys[index],
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
