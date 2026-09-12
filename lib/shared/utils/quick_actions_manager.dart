import 'package:quick_actions/quick_actions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared.dart';

/// Global manager orchestrating mobile home screen App Shortcuts (Launcher Quick Actions).
///
/// Operating System Architecture:
/// - **Android**: Bridges to `android.content.pm.ShortcutManager`, dynamically registering
///   [ShortcutInfo] instances visible when users long-press the application icon on the home screen.
/// - **iOS**: Bridges to `UIApplicationShortcutItem`, registering 3D Touch / Haptic Touch quick action items.
///
/// Key Design Highlights:
/// - **Reactive Dynamic Localization**: Listens to [settingManager] change events so that whenever the user
///   switches application language (English / Chinese / Japanese), home screen shortcuts update their
///   labels immediately without requiring an application restart.
/// - **Seamless Intent Routing**: Dispatches shortcut clicks to either internal high-level routes
///   via [AppNav] or external system protocols (e.g. `mailto:`) via [launchUrl].
class QuickActionsManager {
  QuickActionsManager._();

  /// Action identifier for launching the external email feedback intent.
  static const String _actionContact = 'action_contact';

  /// Action identifier for navigating directly to the in-app Settings screen.
  static const String _actionSettings = 'action_settings';

  /// Platform Channel bridge instance provided by the official `quick_actions` plugin.
  static final QuickActions _quickActions = const QuickActions();

  /// Initializes the quick actions platform channel and registers shortcut listeners.
  ///
  /// Lifecycle:
  /// 1. Registers the callback handler invoked when a user launches the app via a shortcut item.
  /// 2. Subscribes to [settingManager] to dynamically re-push localized shortcut labels upon language change.
  /// 3. Triggers an initial synchronization of shortcut items with current locale settings.
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

  /// Synchronizes localized shortcut titles with the operating system's launcher surface.
  ///
  /// Re-invoked whenever [settingManager.language] changes, ensuring zero hardcoded text
  /// and full compliance with i18n specifications across all supported platforms.
  static void updateShortcuts() {
    _quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(
        type: _actionSettings,
        localizedTitle: I18nKeys.settings.tr,
        icon: 'ic_setting',
      ),
      ShortcutItem(
        type: _actionContact,
        localizedTitle: I18nKeys.contactMe.tr,
        icon: 'ic_contact',
      ),
    ]);
  }

  /// Handles the contact action by composing and launching a pre-populated email intent.
  ///
  /// Uses the RFC 2368 `mailto:` URI scheme targeted at [AppConstants.mail].
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

  /// Handles the settings action by navigating directly to the Settings route.
  ///
  /// Uses [AppNav.off] to transition cleanly into the settings page.
  static void _handleSettings() {
    AppNav.off(Routes.settings);
  }
}

