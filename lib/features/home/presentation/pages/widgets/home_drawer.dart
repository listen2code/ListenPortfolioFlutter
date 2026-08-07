import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';
import '../home_intent.dart';
import '../home_state.dart';
import '../home_view_model.dart';

class HomeDrawer extends StatelessWidget {
  final HomeViewModel viewModel;
  final HomeState state;

  const HomeDrawer({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
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
                    onTap: () => viewModel.handleIntent(
                      const HomeIntent.tabChanged(HomeTab.overview, closeDrawer: true),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person_search_outlined,
                    label: authManager.state.isAuthor ? I18nKeys.aboutMe.tr : I18nKeys.aboutAuthor.tr,
                    blurLevel: AuthBlurLevel.low,
                    isSelected: state.currentTab == HomeTab.aboutMe,
                    onTap: () => viewModel.handleIntent(
                      const HomeIntent.tabChanged(HomeTab.aboutMe, closeDrawer: true),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.rocket_launch_outlined,
                    label: authManager.state.isAuthor ? I18nKeys.projects.tr : I18nKeys.authorProjects.tr,
                    isSelected: state.currentTab == HomeTab.projects,
                    onTap: () => viewModel.handleIntent(
                      const HomeIntent.tabChanged(HomeTab.projects, closeDrawer: true),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.account_tree_outlined,
                    label: I18nKeys.architecture.tr,
                    isSelected: state.currentTab == HomeTab.architecture,
                    onTap: () => viewModel.handleIntent(
                      const HomeIntent.tabChanged(HomeTab.architecture, closeDrawer: true),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.f, horizontal: 10.f),
                    child: Divider(color: context.theme.dividerColor.withValues(alpha: 0.1)),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.settings_suggest_outlined,
                    label: I18nKeys.settings.tr,
                    onTap: () => viewModel.handleIntent(const HomeIntent.toSettings()),
                  ),
                ],
              ),
            ),
            _buildLogoutButton(context),
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

    Widget buildDefaultAvatar() {
      return CommonAvatar(
        size: 70.f,
        iconSize: 35.f,
        backgroundColor: Colors.white24,
        iconColor: Colors.white70,
      );
    }

    Widget buildRoleBadge() {
      final bool isAuthor = authManager.state.isAuthor;
      final bool isGuest = authManager.state.isGuest;

      final String label = isAuthor
          ? I18nKeys.roleAuthor.tr
          : (isGuest ? I18nKeys.roleGuest.tr : I18nKeys.roleMember.tr);
      final IconData iconData = isAuthor
          ? Icons.verified_rounded
          : (isGuest ? Icons.visibility_outlined : Icons.person_outline_rounded);
      final Color bgColor = isAuthor
          ? Colors.amber.withValues(alpha: 0.25)
          : (isGuest ? Colors.white12 : Colors.white24);
      final Color textColor = isAuthor ? Colors.amberAccent : Colors.white;
      final Color borderColor = isAuthor ? Colors.amberAccent.withValues(alpha: 0.5) : Colors.white30;

      return CommonBadge(
        text: label,
        icon: iconData,
        iconSize: 12.f,
        color: bgColor,
        textColor: textColor,
        borderColor: borderColor,
        borderWidth: 1.f,
        borderRadius: 12.f,
        fontSize: 10.f,
        padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 3.f),
      );
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
                child: CommonClickable(
                  ripple: false,
                  onTap: () {
                    if (isLoggedIn) {
                      viewModel.handleIntent(const HomeIntent.previewAvatar());
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.f),
                    ),
                    child: Visibility(
                      visible: isLoggedIn && authManager.state.user?.avatarUrl?.isNotEmpty == true,
                      replacement: buildDefaultAvatar(),
                      child: Hero(
                        tag: 'drawer_avatar_preview',
                        child: CommonImage.url(
                          authManager.state.user?.avatarUrl ?? '',
                          width: 70.f,
                          height: 70.f,
                          borderRadius: 35.f,
                          excludeFromSemantics: true,
                          errorWidget: buildDefaultAvatar(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.f),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: CommonAuthText(
                      authManager.state.user?.name ?? AppConstants.author,
                      style: context.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      blurLevel: AuthBlurLevel.medium,
                    ),
                  ),
                  SizedBox(width: 8.f),
                  Padding(
                    padding: EdgeInsets.only(top: 2.f),
                    child: buildRoleBadge(),
                  ),
                ],
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
            child: CommonIconButton(
              icon: Icon(getModeIcon(), color: Colors.white, size: 24.f),
              onPressed: () => viewModel.handleIntent(const HomeIntent.toAppearance()),
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

  Widget _buildLogoutButton(BuildContext context) {
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
}
