import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';

import '../../../../../shared/shared.dart';
import '../../../../auth/data/models/user_model.dart';
import '../home_intent.dart';
import '../home_state.dart';
import '../home_view_model.dart';
import 'overview_intent.dart';
import 'overview_state.dart';
import 'overview_view_model.dart';
import 'widgets/experience_grid.dart';
import 'widgets/featured_projects_section.dart';
import 'widgets/overview_skeleton.dart';
import 'widgets/quick_actions.dart';
import 'widgets/status_tag.dart';
import 'widgets/welcome_header.dart';

class OverviewWidget extends StatelessWidget {
  final bool active;
  final HomeViewModel homeViewModel;

  const OverviewWidget({super.key, required this.active, required this.homeViewModel});

  @override
  Widget build(BuildContext context) {
    // Get user data from AuthManager
    final UserModel? userModel = authManager.state.user;

    return BaseRefreshPage<OverviewViewModel, OverviewState>(
      provider: overviewViewModelProvider,
      onRefresh: (viewModel, state) async {
        viewModel.handleIntent(const OverviewIntent.refresh());
      },
      onLoading: const OverviewSkeleton(),
      useScaffold: false,
      active: active,
      body: (context, child, viewModel, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.f),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WelcomeHeader(userModel: userModel, state: state),
                  SizedBox(height: 16.f),
                  StatusTag(state: state),
                  SizedBox(height: 24.f),
                  ExperienceGrid(state: state),
                  SizedBox(height: 28.f),
                  CommonSectionHeader(title: I18nKeys.quickActions.tr),
                  SizedBox(height: 12.f),
                  QuickActions(
                    userModel: userModel,
                    viewModel: viewModel,
                    state: state,
                    homeViewModel: homeViewModel,
                  ),
                  SizedBox(height: 28.f),
                ],
              ),
            ),
            FeaturedProjectsSection(
              projects: state.featuredProjects,
              onViewAllPressed: () =>
                  homeViewModel.handleIntent(const HomeIntent.tabChanged(HomeTab.projects)),
            ),
            SizedBox(height: 30.f),
          ],
        );
      },
    );
  }
}
