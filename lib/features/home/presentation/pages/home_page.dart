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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 1:
        return I18nKeys.aboutMe.tr;
      case 2:
        return I18nKeys.featuredProjects.tr;
      case 3:
        return I18nKeys.architecture.tr;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = settingManager.accentColor;

    return BaseStatelessPage(
      title: _getPageTitle(),
      drawer: _buildDrawer(context, theme, accentColor),
      isScrollable: false,
      body: (context, child) => _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return OverviewWidget(
          onResumeRequested: () => setState(() => _selectedIndex = 1),
          onProjectsRequested: () => setState(() => _selectedIndex = 2),
          onArchitectureRequested: () => setState(() => _selectedIndex = 3),
        );
      case 1:
        return const AboutMeWidget();
      case 2:
        return const ProjectsWidget();
      case 3:
        return const ArchitectureWidget();
      default:
        return _buildBody(); // Fallback
    }
  }

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
                  isSelected: _selectedIndex == 0,
                  accentColor: accentColor,
                  onTap: () {
                    setState(() => _selectedIndex = 0);
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person_search_outlined,
                  label: I18nKeys.aboutMe.tr,
                  isSelected: _selectedIndex == 1,
                  accentColor: accentColor,
                  onTap: () {
                    setState(() => _selectedIndex = 1);
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.rocket_launch_outlined,
                  label: I18nKeys.featuredProjects.tr,
                  isSelected: _selectedIndex == 2,
                  accentColor: accentColor,
                  onTap: () {
                    setState(() => _selectedIndex = 2);
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.account_tree_outlined,
                  label: I18nKeys.architecture.tr,
                  isSelected: _selectedIndex == 3,
                  accentColor: accentColor,
                  onTap: () {
                    setState(() => _selectedIndex = 3);
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Divider(color: theme.dividerColor.withOpacity(0.1)),
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
          _buildLogoutButton(context, theme),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, ThemeData theme, Color accentColor) {
    final themeMode = settingManager.themeMode;

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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=${AppConstants.author}'),
                ),
              ),
              SizedBox(height: 15),
              Text(
                AppConstants.author,
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(AppConstants.mail, style: TextStyle(color: Colors.white70, fontSize: 14)),
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

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required Color accentColor,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: isSelected ? accentColor.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(icon, color: isSelected ? accentColor : null),
          title: CommonText(
            label,
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

  Widget _buildLogoutButton(BuildContext context, ThemeData theme) {
    final errorColor = theme.colorScheme.error;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(Icons.logout_rounded, color: errorColor),
          title: Text(
            I18nKeys.logout.tr,
            style: TextStyle(color: errorColor, fontWeight: FontWeight.bold),
          ),
          onTap: () => Navigator.of(
            context,
          ).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false),
        ),
      ),
    );
  }
}
