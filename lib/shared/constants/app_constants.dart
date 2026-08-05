import 'dart:io';

class AppConstants {
  AppConstants._();

  static const String appVersion = String.fromEnvironment('APP_VERSION', defaultValue: '0.0.9');

  // Setting keys
  static const String themeKey = 'theme_mode';
  static const String accentColorKey = 'accent_color';
  static const String fontSizeKey = 'font_size';
  static const String languageKey = 'language';
  static const String useDynamicColorKey = 'use_dynamic_color';
  static const String developerModeKey = 'developer_mode';
  static const String notificationsKey = 'notifications';
  static const String notificationChannelId = 'portfolio_push_channel';
  static const String notificationChannelName = 'Portfolio Notifications';
  static const String notificationChannelDescription = 'Used for portfolio updates and interactive messages.';
  static const String versionUpdatesTopic = 'version_updates';
  static const String defaultNotificationIcon = '@mipmap/ic_launcher';
  static const String notificationParamLink = 'link';
  static const String appLaunchCountKey = 'app_launch_count';
  static const String lastReviewPromptTimeKey = 'last_review_prompt_time';
  static const String hasReviewKey = 'has_review';

  // Data keys
  static const String userDataKey = 'user_data';
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String loginUsernameKey = 'login_username';
  static const String loginPasswordKey = 'login_password';
  static const String loginRememberMeKey = 'login_remember_me';
  static const String projectsDataKey = 'projects_data';
  static const String aboutMeDataKey = 'about_me';
  static const String resumeKey = 'resume';
  static const String playbackTapesListKey = 'playback_tapes_list';
  static const String playbackTapeKey = 'playback_tape';
  static const String presetQAsKey = 'preset_qas';

  // Common keys
  static const String appName = 'lPortfolio';
  static const String author = 'Listen';
  static const String authorId = '1';
  static const String date = '2026';
  static const String mail = 'listen2code@gmail.com';
  static const String github = 'https://github.com/listen2code';
  static const String githubProjectName = 'ListenPortfolioFlutter';
  static const String githubShare = '$github/$githubProjectName';
  static const String githubPageRoot = 'https://listen2code.github.io/ListenPortfolioFlutter/pages/';
  static const String githubPageTermsOfService = '${githubPageRoot}terms_of_service.html';
  static const String githubPagePrivacyPolicy = '${githubPageRoot}privacy_policy.html';

  static String get storeShare {
    if (Platform.isAndroid) {
      return 'https://play.google.com/store/apps/details?id=$appStoreId';
    } else if (Platform.isIOS) {
      return 'https://apps.apple.com/app/$appStoreId';
    }
    return githubShare;
  }

  static String get appStoreId {
    if (Platform.isAndroid) {
      return 'com.listen.portfolio.listen_portfolio_flutter';
    } else if (Platform.isIOS) {
      // iOS App Store ID — 发布至 App Store 后需填入真实 ID
      return '';
    }
    return '';
  }

  // IAP Product IDs
  static const String coffeeTier1 = 'coffee1';
  static const String coffeeTier2 = 'coffee2';
  static const String coffeeTier3 = 'coffee3';

  static const Set<String> coffeeProductIds = {coffeeTier1, coffeeTier2, coffeeTier3};

  // Deep Link & EventBus Constants
  static const String deepLinkScheme = 'listen';
  static const String deepLinkHostHome = 'home';
  static const String deepLinkParamTab = 'tab';
  static const String languageChangedEventKey = 'language_changed_event';
}
