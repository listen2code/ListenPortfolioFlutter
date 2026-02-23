import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_page.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/widgets/about_me_widget.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/widgets/architecture_widget.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/widgets/overview_widget.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/widgets/projects_widget.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/shared/utils/app_constants.dart';

/// Enum to manage home page tabs instead of hardcoded indices
enum HomeTab { overview, aboutMe, projects, architecture }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeTab _currentTab = HomeTab.overview;

  // Get localized title based on selected tab
  String _getPageTitle() {
    switch (_currentTab) {
      case HomeTab.aboutMe:
        return I18nKeys.aboutMe.tr;
      case HomeTab.projects:
        return I18nKeys.featuredProjects.tr;
      case HomeTab.architecture:
        return I18nKeys.architecture.tr;
      case HomeTab.overview:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Only allow app exit when on the Overview tab and no loading is showing
      canPop: _currentTab == HomeTab.overview && !CommonLoading.isShow,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // If loading is shown, let BaseStatelessPage handle it
        if (CommonLoading.isShow) return;

        // If not on overview, back button takes user back to overview
        if (_currentTab != HomeTab.overview) {
          setState(() => _currentTab = HomeTab.overview);
        }
      },
      child: BasePage(title: _getPageTitle(), drawer: _buildDrawer(), body: (context, child) => _buildBody()),
    );
  }

  // Render content based on current tab
  Widget _buildBody() {
    switch (_currentTab) {
      case HomeTab.overview:
        return OverviewWidget(
          onResumeRequested: () {
            AppNav.tryLogin(
              onSuccess: () {
                setState(() => _currentTab = HomeTab.aboutMe);
              },
            );
          },
          onProjectsRequested: () => setState(() => _currentTab = HomeTab.projects),
          onArchitectureRequested: () => setState(() => _currentTab = HomeTab.architecture),
        );
      case HomeTab.aboutMe:
        return const AboutMeWidget();
      case HomeTab.projects:
        return const ProjectsWidget();
      case HomeTab.architecture:
        return const ArchitectureWidget();
    }
  }

  // Build sidebar drawer
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: context.theme.canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(30.f), bottomRight: Radius.circular(30.f)),
      ),
      child: BaseAuthListenablePage(
        builder: (BuildContext context, Widget? child) {
          return Column(
            children: [
              _buildDrawerHeader(),
              SizedBox(height: 10.f),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 12.f),
                  children: [
                    _buildDrawerItem(
                      icon: Icons.dashboard_customize_outlined,
                      label: I18nKeys.overview.tr,
                      isSelected: _currentTab == HomeTab.overview,
                      onTap: () {
                        setState(() => _currentTab = HomeTab.overview);
                        AppNav.back();
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.person_search_outlined,
                      label: I18nKeys.aboutMe.tr,
                      blurLevel: AuthBlurLevel.low,
                      isSelected: _currentTab == HomeTab.aboutMe,
                      onTap: () {
                        AppNav.tryLogin(
                          onSuccess: () {
                            setState(() => _currentTab = HomeTab.aboutMe);
                            AppNav.back();
                          },
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.rocket_launch_outlined,
                      label: I18nKeys.featuredProjects.tr,
                      isSelected: _currentTab == HomeTab.projects,
                      onTap: () {
                        setState(() => _currentTab = HomeTab.projects);
                        AppNav.back();
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.account_tree_outlined,
                      label: I18nKeys.architecture.tr,
                      isSelected: _currentTab == HomeTab.architecture,
                      onTap: () {
                        setState(() => _currentTab = HomeTab.architecture);
                        AppNav.back();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.f, horizontal: 10.f),
                      child: Divider(color: context.theme.dividerColor.withOpacity(0.1)),
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings_suggest_outlined,
                      label: I18nKeys.settings.tr,
                      onTap: () => AppNav.to(Routes.settings),
                    ),
                  ],
                ),
              ),
              _buildLogoutButton(),
              SizedBox(height: 20.f),
            ],
          );
        },
      ),
    );
  }

  // Build drawer user profile section
  Widget _buildDrawerHeader() {
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
        gradient: LinearGradient(colors: [accentColor, accentColor.withOpacity(0.8)]),
        borderRadius: BorderRadius.only(topRight: Radius.circular(30.f)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.f),
                ),
                child: isLoggedIn
                    ? CommonImage.url(
                        authManager.state.user?.avatarUrl ?? "",
                        width: 70.f,
                        height: 70.f,
                        borderRadius: 35.f,
                      )
                    : Container(
                        width: 70.f,
                        height: 70.f,
                        decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                        child: Icon(Icons.person, size: 35.f, color: Colors.white70),
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
            ),
          ),
        ],
      ),
    );
  }

  // Build individual drawer menu items
  Widget _buildDrawerItem({
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
        color: isSelected ? accentColor.withOpacity(0.1) : Colors.transparent,
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

  // Build Login or Logout button at the bottom of drawer
  Widget _buildLogoutButton() {
    final bool isGuest = authManager.state.isGuest;
    final accentColor = context.accentColor;
    final errorColor = context.theme.colorScheme.error;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.f),
      child: Material(
        color: (isGuest ? accentColor : errorColor).withOpacity(0.15),
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
          onTap: () {
            if (isGuest) {
              AppNav.to(Routes.login);
            } else {
              CommonDialog.showConfirm(title: I18nKeys.logout.tr, message: I18nKeys.logoutTips.tr).then((
                confirmed,
              ) {
                if (confirmed == true) {
                  authManager.logout();
                  if (_currentTab == HomeTab.aboutMe) {
                    setState(() => _currentTab = HomeTab.overview);
                  }
                  AppNav.to(Routes.login);
                }
              });
            }
          },
        ),
      ),
    );
  }
}
