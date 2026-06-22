import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../../shared/shared.dart';
import 'settings_intent.dart';
import 'settings_state.dart';
import 'settings_view_model.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRefreshPage<SettingsViewModel, SettingsState>(
      title: I18nKeys.settings.tr,
      provider: settingsViewModelProvider,
      body: (context, child, viewModel, state) {
        if (state == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. PREFERENCES: UI and localization
              _buildSectionTitle(context, I18nKeys.general.tr),
              _buildSettingsCard(context, [
                _buildListTile(
                  context,
                  icon: Icons.palette_outlined,
                  title: I18nKeys.appearance.tr,
                  subtitle: I18nKeys.appearanceSubtitle.tr,
                  onTap: () => AppNav.to(Routes.appearance),
                ),
                _buildListTile(
                  context,
                  icon: Icons.language_outlined,
                  title: I18nKeys.language.tr,
                  trailing: CommonText(
                    state.currentLanguage.label,
                    style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  onTap: () => viewModel?.handleIntent(const SettingsIntent.showLanguageDialog()),
                ),
              ]),

              SizedBox(height: 25.f),

              // 2. ACCOUNT & SECURITY
              _buildSectionTitle(context, I18nKeys.account.tr),
              _buildSettingsCard(context, [
                _buildListTile(
                  context,
                  icon: Icons.lock_outline_rounded,
                  title: I18nKeys.changePassword.tr,
                  blurLevel: AuthBlurLevel.low,
                  onTap: () => AppNav.to(Routes.changePassword, needLogin: true),
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.notifications_none_rounded,
                  title: I18nKeys.notifications.tr,
                  value: state.notificationsEnabled,
                  onChanged: (val) => viewModel?.handleIntent(SettingsIntent.toggleNotifications(val)),
                ),
                _buildListTile(
                  context,
                  icon: Icons.no_accounts_outlined,
                  title: I18nKeys.deleteAccount.tr,
                  blurLevel: AuthBlurLevel.low,
                  onTap: () => AppNav.to(Routes.deleteAccount, needLogin: true),
                ),
              ]),

              SizedBox(height: 25.f),

              // 3. STORAGE & MAINTENANCE
              _buildSectionTitle(context, I18nKeys.systemStorage.tr),
              _buildSettingsCard(context, [
                _buildListTile(
                  context,
                  icon: Icons.cleaning_services_outlined,
                  title: I18nKeys.clearCache.tr,
                  trailing: CommonText(
                    state.cacheSize,
                    style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  onTap: () => viewModel?.handleIntent(const SettingsIntent.clearCache()),
                ),
                _buildListTile(
                  context,
                  icon: Icons.restart_alt_rounded,
                  title: I18nKeys.resetSettings.tr,
                  onTap: () => viewModel?.handleIntent(const SettingsIntent.resetSettings()),
                ),
              ]),

              SizedBox(height: 25.f),

              // 4. DEVELOPER TOOLS
              _buildSectionTitle(context, I18nKeys.developer.tr),
              _buildSettingsCard(context, [
                _buildSwitchTile(
                  context,
                  icon: Icons.terminal_rounded,
                  title: I18nKeys.viewLogs.tr,
                  value: state.isLogOverlayShowing,
                  onChanged: (val) {
                    viewModel?.handleIntent(SettingsIntent.toggleLogOverlay(val));
                  },
                ),
                _buildListTile(
                  context,
                  icon: Icons.bug_report_outlined,
                  title: I18nKeys.crashReports.tr,
                  subtitle: I18nKeys.crashReportsSubtitle.tr,
                  onTap: () => AppNav.to(Routes.crashLogs),
                ),
                _buildListTile(
                  context,
                  icon: Icons.settings_input_antenna_rounded,
                  title: I18nKeys.switchEnv.tr,
                  subtitle: '${I18nKeys.currentlyActive.tr}: ${state.currentEnv.name}',
                  onTap: () => viewModel?.handleIntent(const SettingsIntent.showEnvDialog()),
                ),
                if (kDebugMode || state.isDeveloperMode)
                  _buildListTile(
                    context,
                    icon: Icons.notification_important_outlined,
                    title: 'Push Test',
                    subtitle: '触发前台推送通知横幅模拟',
                    onTap: () async {
                      await notificationService.requestPermission();
                      final service = notificationService;
                      if (service is FirebaseNotificationServiceImpl) {
                        service.simulateMessageReceived(
                          const NotificationPayload(
                            title: '前台测试通知',
                            body: '这是一个在前台接收的推送通知横幅模拟。',
                            data: {'type': 'test'},
                          ),
                        );
                      }
                    },
                  ),
                if (kDebugMode || state.isDeveloperMode)
                  _buildListTile(
                    context,
                    icon: Icons.html,
                    title: 'WebView Test',
                    subtitle: 'WebView Dialog',
                    onTap: () async {
                      AppNav.to(
                        FutureBuilder<String>(
                          future: DefaultAssetBundle.of(context).loadString('assets/html/test.html'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return CommonWebView(
                              showAppBar: true,
                              shrinkWrap: false,
                              initialHtml: snapshot.data,
                              javascriptHandlers: {
                                'showToast': (args) {
                                  if (args.isNotEmpty) {
                                    final msg = args[0] as String;
                                    CommonToast.show(msg);
                                  }
                                },
                                'closePage': (args) {
                                  Navigator.of(context).pop();
                                },
                                'getDeviceInfo': (args) async {
                                  return {
                                    'platform': Theme.of(context).platform.name,
                                    'device': 'Flutter Emulator (SettingsPage Debug)',
                                    'timestamp': DateTime.now().toLocal().toString(),
                                  };
                                },
                              },
                              shouldOverrideUrlLoadingWithAction: (controller, action) async {
                                final url = action.request.url?.toString() ?? '';
                                if (url.startsWith('myapp://')) {
                                  CommonToast.show('拦截到 Scheme 动作: $url');
                                  return NavigationActionPolicy.CANCEL;
                                }
                                return NavigationActionPolicy.ALLOW;
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
              ]),

              SizedBox(height: 25.f),

              // 4.5 SUPPORT & SHARE
              _buildSectionTitle(context, I18nKeys.supportAndShare.tr),
              _buildSettingsCard(context, [
                _buildListTile(
                  context,
                  icon: Icons.coffee_outlined,
                  title: I18nKeys.buyMeCoffee.tr,
                  subtitle: I18nKeys.supportProject.tr,
                  onTap: () => viewModel?.handleIntent(const SettingsIntent.buyMeCoffee()),
                ),
                _buildListTile(
                  context,
                  icon: Icons.share_outlined,
                  title: I18nKeys.shareApp.tr,
                  onTap: () => viewModel?.handleIntent(const SettingsIntent.shareApp()),
                ),
                _buildListTile(
                  context,
                  icon: Icons.star_outline_rounded,
                  title: I18nKeys.rateApp.tr,
                  onTap: () => viewModel?.handleIntent(const SettingsIntent.rateApp()),
                ),
              ]),

              SizedBox(height: 25.f),

              // 5. LEGAL & ABOUT
              _buildSectionTitle(context, I18nKeys.about.tr),
              _buildSettingsCard(context, [
                _buildListTile(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: I18nKeys.privacyPolicy.tr,
                  onTap: () => AppNav.to(Routes.privacyPolicy),
                ),
                _buildListTile(
                  context,
                  icon: Icons.gavel_outlined,
                  title: I18nKeys.termsOfService.tr,
                  onTap: () => AppNav.to(Routes.termsOfService),
                ),
                _buildListTile(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: I18nKeys.licenses.tr,
                  onTap: () => viewModel?.handleIntent(const SettingsIntent.showLicenses()),
                ),
                _buildListTile(
                  context,
                  icon: Icons.system_update_outlined,
                  title: I18nKeys.checkUpdates.tr,
                  onTap: () => viewModel?.handleIntent(const SettingsIntent.checkUpdates()),
                ),
                _VersionTile(
                  onTrigger: () => viewModel?.handleIntent(const SettingsIntent.enableDeveloperMode()),
                ),
              ]),
              SizedBox(height: 40.f),
            ],
          ),
        );
      },
    );
  }

  // --- Logic Handlers ---

  // --- UI Builders ---

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 10.f, bottom: 8.f, top: 5.f),
      child: CommonText(
        title.toUpperCase(),
        style: context.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8.f, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(20.f),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              children[i],
              if (i < children.length - 1)
                Divider(
                  height: 1,
                  thickness: 0.5,
                  indent: 60.f,
                  endIndent: 20.f,
                  color: context.theme.dividerColor.withValues(alpha: 0.05),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
    AuthBlurLevel blurLevel = AuthBlurLevel.none,
  }) {
    final accentColor = context.accentColor;
    final iconSize = 20.f * 0.8;

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.f, vertical: 4.f),
      leading: Container(
        padding: EdgeInsets.all(8.f),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10.f),
        ),
        child: Icon(icon, color: accentColor, size: iconSize),
      ),
      title: CommonAuthText(
        title,
        style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        maxLines: 1,
        blurLevel: blurLevel,
        onTap: onTap,
      ),
      subtitle: subtitle != null
          ? CommonText(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall?.copyWith(color: Colors.grey),
            )
          : null,
      trailing: trailing ?? Icon(Icons.chevron_right_rounded, size: 20.f, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final accentColor = context.accentColor;
    final iconSize = 20.f * 0.8;

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.f, vertical: 4.f),
      leading: Container(
        padding: EdgeInsets.all(8.f),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10.f),
        ),
        child: Icon(icon, color: accentColor, size: iconSize),
      ),
      title: CommonText(
        title,
        style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        maxLines: 1,
      ),
      trailing: CommonSwitch(value: value, onChanged: onChanged),
      onTap: () => onChanged(!value),
    );
  }
}

class _VersionTile extends StatefulWidget {
  final VoidCallback onTrigger;

  const _VersionTile({required this.onTrigger});

  @override
  State<_VersionTile> createState() => _VersionTileState();
}

class _VersionTileState extends State<_VersionTile> {
  int _clickCount = 0;
  DateTime? _lastClickTime;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Center(
        child: CommonText(
          '${I18nKeys.appVersion.tr} ${AppConstants.appVersion}',
          style: context.textTheme.labelSmall?.copyWith(color: Colors.grey),
        ),
      ),
      onTap: () {
        final now = DateTime.now();
        if (_lastClickTime == null || now.difference(_lastClickTime!) > const Duration(seconds: 2)) {
          _clickCount = 1;
        } else {
          _clickCount++;
        }
        _lastClickTime = now;

        if (_clickCount >= 7) {
          _clickCount = 0;
          widget.onTrigger();
        }
      },
    );
  }
}
