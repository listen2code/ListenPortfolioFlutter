import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/base/base_listenable_page.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/constants/app_env.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/core/utils/cache_manager.dart';
import 'package:listen_portfolio_flutter/core/utils/log_overlay_manager.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/change_password_page.dart';
import 'package:listen_portfolio_flutter/generated/r.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/shared/utils/snack_bar_util.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_auth_text.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_dialog.dart';

import 'appearance_page.dart';
import 'delete_account_page.dart';
import 'privacy_policy_page.dart';
import 'terms_of_service_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _cacheSize = '...';

  @override
  void initState() {
    super.initState();
    _updateCacheSize();
  }

  // Fetch and update cache size display
  Future<void> _updateCacheSize() async {
    final size = await CacheManager.getCacheSize();
    if (mounted) {
      setState(() => _cacheSize = size);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseListenablePage(
      builder: (context, child) {
        final accentColor = settingManager.accentColor;

        return BaseStatelessPage(
          title: I18nKeys.settings.tr,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          body: (BuildContext context, Widget? child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. PREFERENCES: UI and localization
                  _buildSectionTitle(I18nKeys.general.tr),
                  _buildSettingsCard(context, [
                    _buildListTile(
                      icon: Icons.palette_outlined,
                      title: I18nKeys.appearance.tr,
                      subtitle: I18nKeys.appearanceSubtitle.tr,
                      accentColor: accentColor,
                      onTap: () => AppNav.to(const AppearancePage()),
                    ),
                    _buildListTile(
                      icon: Icons.language_outlined,
                      title: I18nKeys.language.tr,
                      accentColor: accentColor,
                      trailing: Text(
                        settingManager.language.label,
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      onTap: () => _showLanguageDialog(),
                    ),
                  ]),

                  const SizedBox(height: 25),

                  // 2. ACCOUNT & SECURITY
                  _buildSectionTitle(I18nKeys.account.tr),
                  _buildSettingsCard(context, [
                    _buildListTile(
                      icon: Icons.lock_outline_rounded,
                      title: I18nKeys.changePassword.tr,
                      accentColor: accentColor,
                      blurLevel: AuthBlurLevel.low,
                      onTap: () => AppNav.to(const ChangePasswordPage(), needLogin: true),
                    ),
                    _buildSwitchTile(
                      icon: Icons.notifications_none_rounded,
                      title: I18nKeys.notifications.tr,
                      value: _notificationsEnabled,
                      accentColor: accentColor,
                      onChanged: (val) => setState(() => _notificationsEnabled = val),
                    ),
                    _buildListTile(
                      icon: Icons.no_accounts_outlined,
                      title: I18nKeys.deleteAccount.tr,
                      accentColor: accentColor,
                      blurLevel: AuthBlurLevel.low,
                      onTap: () => AppNav.to(const DeleteAccountPage(), needLogin: true),
                    ),
                  ]),

                  const SizedBox(height: 25),

                  // 3. STORAGE & MAINTENANCE
                  _buildSectionTitle(I18nKeys.systemStorage.tr),
                  _buildSettingsCard(context, [
                    _buildListTile(
                      icon: Icons.cleaning_services_outlined,
                      title: I18nKeys.clearCache.tr,
                      accentColor: accentColor,
                      trailing: Text(_cacheSize, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      onTap: () => _handleClearCache(accentColor),
                    ),
                    _buildListTile(
                      icon: Icons.restart_alt_rounded,
                      title: I18nKeys.resetSettings.tr,
                      accentColor: accentColor,
                      onTap: () => _showResetConfirmation(accentColor),
                    ),
                  ]),

                  const SizedBox(height: 25),

                  // 4. DEVELOPER TOOLS: Always visible
                  _buildSectionTitle(I18nKeys.developer.tr),
                  _buildSettingsCard(context, [
                    _buildSwitchTile(
                      icon: Icons.terminal_rounded,
                      title: I18nKeys.viewLogs.tr,
                      value: LogOverlayManager.isShowing,
                      accentColor: accentColor,
                      onChanged: (val) {
                        setState(() {
                          if (val) {
                            LogOverlayManager.show(context);
                          } else {
                            LogOverlayManager.hide();
                          }
                        });
                      },
                    ),
                    _buildListTile(
                      icon: Icons.settings_input_antenna_rounded,
                      title: I18nKeys.switchEnv.tr,
                      subtitle: '${I18nKeys.currentlyActive.tr}: ${AppEnv.env}',
                      accentColor: accentColor,
                      onTap: () => _showEnvSwitchDialog(),
                    ),
                  ]),

                  const SizedBox(height: 25),

                  // 5. LEGAL & ABOUT
                  _buildSectionTitle(I18nKeys.about.tr),
                  _buildSettingsCard(context, [
                    _buildListTile(
                      icon: Icons.privacy_tip_outlined,
                      title: I18nKeys.privacyPolicy.tr,
                      accentColor: accentColor,
                      onTap: () => AppNav.to(const PrivacyPolicyPage()),
                    ),
                    _buildListTile(
                      icon: Icons.gavel_outlined,
                      title: I18nKeys.termsOfService.tr,
                      accentColor: accentColor,
                      onTap: () => AppNav.to(const TermsOfServicePage()),
                    ),
                    _buildListTile(
                      icon: Icons.info_outline_rounded,
                      title: I18nKeys.licenses.tr,
                      accentColor: accentColor,
                      onTap: () => showLicensePage(
                        context: context,
                        applicationName: AppConstants.appName,
                        applicationVersion: AppConstants.appVersion,
                        applicationIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(R.imagesIcLauncherAdaptiveFore, width: 48, height: 48, color: accentColor, colorBlendMode: BlendMode.srcIn),
                        ),
                        applicationLegalese: '© ${AppConstants.date} ${AppConstants.author}',
                      ),
                    ),
                    ListTile(
                      title: Center(
                        child: Text(
                          '${I18nKeys.appVersion.tr} ${AppConstants.appVersion}',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- Logic Handlers ---

  void _handleClearCache(Color accentColor) async {
    await CacheManager.clearAllCache();
    await _updateCacheSize();
    if (mounted) {
      SnackBarUtil.show(I18nKeys.cacheCleared.tr);
    }
  }

  void _showResetConfirmation(Color accentColor) {
    CommonDialog.showConfirm(
      title: I18nKeys.resetConfirmTitle.tr,
      message: I18nKeys.resetConfirmContent.tr,
      okText: I18nKeys.reset.tr,
      okColor: Colors.red,
    ).then((confirmed) async {
      if (confirmed == true) {
        await settingManager.resetSettings();
        SnackBarUtil.show(I18nKeys.settingsResetSuccess.tr);
      }
    });
  }

  void _showEnvSwitchDialog() {
    // Selection dialog using switch items for environments
    CommonDialog.showSwitchDialog(
      title: I18nKeys.switchEnv.tr,
      items: [
        DialogSwitchItem(
          label: I18nKeys.envDev.tr,
          value: AppEnv.env == AppEnvironment.dev.name,
          onChanged: (val) {
            if (val) {
              setState(() => AppEnv.setEnvironment(AppEnvironment.dev));
              AppNav.back();
            }
          },
        ),
        DialogSwitchItem(
          label: I18nKeys.envTest.tr,
          value: AppEnv.env == AppEnvironment.test.name,
          onChanged: (val) {
            if (val) {
              setState(() => AppEnv.setEnvironment(AppEnvironment.test));
              AppNav.back();
            }
          },
        ),
        DialogSwitchItem(
          label: I18nKeys.envProd.tr,
          value: AppEnv.env == AppEnvironment.prod.name,
          onChanged: (val) {
            if (val) {
              setState(() => AppEnv.setEnvironment(AppEnvironment.prod));
              AppNav.back();
            }
          },
        ),
      ],
    );
  }

  void _showLanguageDialog() {
    // Selection dialog using switch items for languages
    CommonDialog.showSwitchDialog(
      title: I18nKeys.selectLanguage.tr,
      items: AppLanguage.values.map((lang) {
        return DialogSwitchItem(
          label: lang.label,
          value: settingManager.language == lang,
          onChanged: (val) {
            if (val) {
              settingManager.setLanguage(lang);
              AppNav.back();
            }
          },
        );
      }).toList(),
    );
  }

  // --- UI Builders ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 8, top: 5),
      child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1)),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 4))]),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              children[i],
              if (i < children.length - 1) Divider(height: 1, thickness: 0.5, indent: 60, endIndent: 20, color: theme.dividerColor.withValues(alpha: 0.05)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({required IconData icon, required String title, required Color accentColor, String? subtitle, Widget? trailing, required VoidCallback onTap, AuthBlurLevel blurLevel = AuthBlurLevel.none}) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: accentColor, size: 20),
      ),
      title: CommonAuthText(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, blurLevel: blurLevel, onTap: onTap),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({required IconData icon, required String title, required bool value, required Color accentColor, required ValueChanged<bool> onChanged}) {
    return SwitchListTile.adaptive(
      dense: true,
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: accentColor, size: 20),
      ),
      title: CommonText(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1),
      value: value,
      activeColor: accentColor,
      onChanged: onChanged,
    );
  }
}
