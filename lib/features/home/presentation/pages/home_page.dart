import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_page.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/widgets/about_me_widget.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/widgets/architecture_widget.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/widgets/overview_widget.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/widgets/projects_widget.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/appearance_page.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/settings_page.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_auth_text.dart';

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
    final theme = Theme.of(context);
    final accentColor = settingManager.accentColor;

    return PopScope(
      // Only allow app exit when on the Overview tab
      canPop: _currentTab == HomeTab.overview,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // If not on overview, back button takes user back to overview
        if (_currentTab != HomeTab.overview) {
          setState(() => _currentTab = HomeTab.overview);
        }
      },
      child: BaseStatelessPage(
        title: _getPageTitle(),
        drawer: _buildDrawer(context, theme, accentColor),
        body: (context, child) => _buildBody(),
      ),
    );
  }

  // Render content based on current tab
  Widget _buildBody() {
    switch (_currentTab) {
      case HomeTab.overview:
        return OverviewWidget(
          onResumeRequested: () => setState(() => _currentTab = HomeTab.aboutMe),
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
  Widget _buildDrawer(BuildContext context, ThemeData theme, Color accentColor) {
    return Drawer(
      backgroundColor: theme.canvasColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          _buildDrawerHeader(context, theme, accentColor),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildDrawerItem(
                  icon: Icons.dashboard_customize_outlined,
                  label: I18nKeys.overview.tr,
                  isSelected: _currentTab == HomeTab.overview,
                  accentColor: accentColor,
                  onTap: () {
                    setState(() => _currentTab = HomeTab.overview);
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person_search_outlined,
                  label: I18nKeys.aboutMe.tr,
                  blurSigma: 2.0,
                  isSelected: _currentTab == HomeTab.aboutMe,
                  accentColor: accentColor,
                  onTap: () {
                    setState(() => _currentTab = HomeTab.aboutMe);
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.rocket_launch_outlined,
                  label: I18nKeys.featuredProjects.tr,
                  isSelected: _currentTab == HomeTab.projects,
                  accentColor: accentColor,
                  onTap: () {
                    setState(() => _currentTab = HomeTab.projects);
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.account_tree_outlined,
                  label: I18nKeys.architecture.tr,
                  isSelected: _currentTab == HomeTab.architecture,
                  accentColor: accentColor,
                  onTap: () {
                    setState(() => _currentTab = HomeTab.architecture);
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Divider(color: theme.dividerColor.withValues(alpha: 0.1)),
                ),
                _buildDrawerItem(
                  icon: Icons.settings_suggest_outlined,
                  label: I18nKeys.settings.tr,
                  accentColor: accentColor,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsPage()));
                  },
                ),
              ],
            ),
          ),
          _buildLogoutButton(context, theme, accentColor, authManager.state.isGuest),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Build drawer user profile section
  Widget _buildDrawerHeader(BuildContext context, ThemeData theme, Color accentColor) {
    final themeMode = settingManager.themeMode;
    final bool isLoggedIn = !authManager.state.isGuest;

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
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [accentColor, accentColor.withValues(alpha: 0.8)]),
        borderRadius: const BorderRadius.only(topRight: Radius.circular(30)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: isLoggedIn
                      ? const NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=Listen')
                      : null,
                  child: isLoggedIn ? null : const Icon(Icons.person, size: 35, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 15),
              CommonAuthText(
                authManager.state.user?.name ?? AppConstants.author,
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              CommonAuthText(
                authManager.state.user?.email ?? AppConstants.mail,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: Icon(getModeIcon(), color: Colors.white),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AppearancePage())),
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
    required Color accentColor,
    bool isSelected = false,
    required VoidCallback onTap,
    double blurSigma = 0,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: isSelected ? accentColor.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(icon, color: isSelected ? accentColor : null),
          title: CommonAuthText(
            label,
            blurSigma: blurSigma,
            style: TextStyle(
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
  Widget _buildLogoutButton(BuildContext context, ThemeData theme, Color accentColor, bool isGuest) {
    final errorColor = theme.colorScheme.error;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: (isGuest ? accentColor : errorColor).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(isGuest ? Icons.login_rounded : Icons.logout_rounded, color: isGuest ? accentColor : errorColor),
          title: CommonText(
            isGuest ? I18nKeys.login.tr : I18nKeys.logout.tr,
            style: TextStyle(color: isGuest ? accentColor : errorColor, fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
          onTap: () {
            if (!isGuest) {
              authManager.logout();
            }

            Navigator.of(
              context,
            ).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
          },
        ),
      ),
    );
  }
}
