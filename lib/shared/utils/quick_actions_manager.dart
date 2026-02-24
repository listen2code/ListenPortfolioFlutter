import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickActionsManager {
  QuickActionsManager._();

  static const String _actionContact = 'action_contact';
  static const String _actionSettings = 'action_settings';

  static final QuickActions _quickActions = const QuickActions();

  static void init() {
    _quickActions.initialize((String shortcutType) {
      if (shortcutType == _actionContact) {
        _handleContact();
      } else if (shortcutType == _actionSettings) {
        _handleSettings();
      }
    });

    // Listen to setting changes (like language) and refresh shortcuts
    settingManager.addListener(updateShortcuts);

    // Initial load
    updateShortcuts();
  }

  /// Updates the shortcut items with the current localized titles.
  static void updateShortcuts() {
    _quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(
        type: _actionSettings,
        localizedTitle: I18nKeys.settings.tr,
        // todo ios/Runner/Assets.xcassets/
        icon: 'ic_setting',
      ),
      ShortcutItem(
        type: _actionContact,
        localizedTitle: I18nKeys.contactMe.tr,
        // todo ios/Runner/Assets.xcassets/
        icon: 'ic_contact',
      ),
    ]);
  }

  static void _handleContact() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: AppConstants.mail,
      queryParameters: {'subject': 'Portfolio Feedback'},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  static void _handleSettings() {
    AppNav.off(Routes.settings);
  }
}
