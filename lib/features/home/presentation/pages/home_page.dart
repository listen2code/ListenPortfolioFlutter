import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../shared/shared.dart';
import 'about_me/about_me_intent.dart';
import 'about_me/about_me_view_model.dart';
import 'about_me/about_me_widget.dart';
import 'architecture/architecture_widget.dart';
import 'home_intent.dart';
import 'home_state.dart';
import 'home_view_model.dart';
import 'overview/overview_widget.dart';
import 'projects/projects_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);

    return BaseRefreshPage<HomeViewModel, HomeState>(
      provider: homeViewModelProvider,
      title: state.title,
      drawer: _buildDrawer(context, viewModel, state),
      canPop: state.currentTab == HomeTab.overview,
      actions: state.currentTab == HomeTab.aboutMe
          ? [
              Consumer(
                builder: (context, ref, child) {
                  return IconButton(
                    icon: const Icon(Icons.share_outlined),
                    tooltip: I18nKeys.shareApp.tr,
                    onPressed: () {
                      ref
                          .read(aboutMeViewModelProvider.notifier)
                          .handleIntent(const AboutMeIntent.shareApp());
                    },
                  );
                },
              ),
            ]
          : null,
      onInterceptBack: () {
        if (state.currentTab != HomeTab.overview) {
          viewModel.handleIntent(const HomeIntent.tabChanged(HomeTab.overview));
        }
      },
      onLoading: _buildOverviewSkeleton(context),
      isEmptyTitle: false,
      body: (context, child, viewModel, state) {
        if (state == null) return const SizedBox.shrink();
        // Use IndexedStack to persist sub-page states while driving lifecycles via active flag
        return IndexedStack(
          index: state.currentTab.index,
          children: [
            OverviewWidget(active: state.currentTab == HomeTab.overview, homeViewModel: viewModel!),
            AboutMeWidget(active: state.currentTab == HomeTab.aboutMe),
            ProjectsWidget(active: state.currentTab == HomeTab.projects),
            ArchitectureWidget(active: state.currentTab == HomeTab.architecture),
          ],
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context, HomeViewModel viewModel, HomeState state) {
    return Drawer(
      backgroundColor: context.theme.canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(30.f), bottomRight: Radius.circular(30.f)),
      ),
      child: BaseAuthPage(
        builder: (context, child) => Column(
          children: [
            _buildDrawerHeader(context),
            SizedBox(height: 10.f),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 12.f),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.dashboard_customize_outlined,
                    label: I18nKeys.overview.tr,
                    isSelected: state.currentTab == HomeTab.overview,
                    onTap: () => viewModel.handleIntent(const HomeIntent.tabChanged(HomeTab.overview)),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person_search_outlined,
                    label: I18nKeys.aboutMe.tr,
                    blurLevel: AuthBlurLevel.low,
                    isSelected: state.currentTab == HomeTab.aboutMe,
                    onTap: () => AppNav.tryLogin(
                      onSuccess: () => viewModel.handleIntent(const HomeIntent.tabChanged(HomeTab.aboutMe)),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.rocket_launch_outlined,
                    label: I18nKeys.featuredProjects.tr,
                    isSelected: state.currentTab == HomeTab.projects,
                    onTap: () => viewModel.handleIntent(const HomeIntent.tabChanged(HomeTab.projects)),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.account_tree_outlined,
                    label: I18nKeys.architecture.tr,
                    isSelected: state.currentTab == HomeTab.architecture,
                    onTap: () => viewModel.handleIntent(const HomeIntent.tabChanged(HomeTab.architecture)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.f, horizontal: 10.f),
                    child: Divider(color: context.theme.dividerColor.withValues(alpha: 0.1)),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.settings_suggest_outlined,
                    label: I18nKeys.settings.tr,
                    onTap: () => AppNav.to(Routes.settings),
                  ),
                ],
              ),
            ),
            _buildLogoutButton(context, viewModel, state),
            SizedBox(height: 20.f),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final themeMode = settingManager.themeMode;
    final bool isLoggedIn = !authManager.state.isGuest;
    final accentColor = context.accentColor;

    IconData getModeIcon() {
      switch (themeMode) {
        case ThemeMode.system:
          return Icons.brightness_auto_outlined;
        case ThemeMode.light:
          return Icons.wb_sunny_outlined;
        case ThemeMode.dark:
          return Icons.dark_mode_outlined;
      }
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 60.f, bottom: 30.f, left: 20.f, right: 20.f),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [accentColor, accentColor.withValues(alpha: 0.8)]),
        borderRadius: BorderRadius.only(topRight: Radius.circular(30.f)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                label: I18nKeys.profilePhotoSemanticLabel.tr,
                image: true,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.f),
                  ),
                  child: isLoggedIn
                      ? CommonImage.url(
                          authManager.state.user?.avatarUrl ?? '',
                          width: 70.f,
                          height: 70.f,
                          borderRadius: 35.f,
                          excludeFromSemantics: true,
                        )
                      : Container(
                          width: 70.f,
                          height: 70.f,
                          decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                          child: Icon(Icons.person, size: 35.f, color: Colors.white70),
                        ),
                ),
              ),
              SizedBox(height: 15.f),
              CommonAuthText(
                authManager.state.user?.name ?? AppConstants.author,
                style: context.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                blurLevel: AuthBlurLevel.medium,
              ),
              CommonAuthText(
                authManager.state.user?.email ?? AppConstants.mail,
                style: context.textTheme.bodySmall?.copyWith(color: Colors.white70),
                blurLevel: AuthBlurLevel.medium,
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: Icon(getModeIcon(), color: Colors.white, size: 24.f),
              onPressed: () => AppNav.to(Routes.appearance),
              tooltip: I18nKeys.themeToggleSemanticLabel.tr,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isSelected = false,
    required VoidCallback onTap,
    AuthBlurLevel blurLevel = AuthBlurLevel.none,
  }) {
    final accentColor = context.accentColor;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.f),
      child: Material(
        color: isSelected ? accentColor.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(15.f),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          dense: true,
          leading: Icon(icon, color: isSelected ? accentColor : null, size: 24.f),
          title: CommonAuthText(
            label,
            blurLevel: blurLevel,
            onTap: onTap,
            style: context.textTheme.titleSmall?.copyWith(
              color: isSelected ? accentColor : null,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, HomeViewModel viewModel, HomeState state) {
    final bool isGuest = authManager.state.isGuest;
    final accentColor = context.accentColor;
    final errorColor = context.theme.colorScheme.error;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.f),
      child: Material(
        color: (isGuest ? accentColor : errorColor).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(15.f),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          dense: true,
          leading: Icon(
            isGuest ? Icons.login_rounded : Icons.logout_rounded,
            color: isGuest ? accentColor : errorColor,
            size: 24.f,
          ),
          title: CommonText(
            isGuest ? I18nKeys.login.tr : I18nKeys.logout.tr,
            style: context.textTheme.titleSmall?.copyWith(
              color: isGuest ? accentColor : errorColor,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
          onTap: () => viewModel.handleIntent(const HomeIntent.logout()),
        ),
      ),
    );
  }

  Widget _buildOverviewSkeleton(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.f, vertical: 20.f),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonSkeleton.line(width: 180.f, height: 28.f),
          SizedBox(height: 12.f),
          CommonSkeleton.line(width: 260.f, height: 16.f),
          SizedBox(height: 24.f),
          CommonSkeleton(width: double.infinity, height: 100.f, borderRadius: 20.f),
          SizedBox(height: 12.f),
          Row(
            children: [
              Expanded(
                child: CommonSkeleton(height: 80.f, borderRadius: 20.f),
              ),
              SizedBox(width: 12.f),
              Expanded(
                child: CommonSkeleton(height: 80.f, borderRadius: 20.f),
              ),
            ],
          ),
          SizedBox(height: 40.f),
          const CommonSkeletonListTile(),
          const CommonSkeletonListTile(),
        ],
      ),
    );
  }
}
