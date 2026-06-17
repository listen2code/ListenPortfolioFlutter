class AppConstants {
  AppConstants._();

  static const String appVersion = String.fromEnvironment('APP_VERSION', defaultValue: '0.0.9');

  // EventBus keys
  static const String resetOverview = 'reset_to_overview';
  static const String tabChangedEvent = 'tab_changed';
  static const String routeChangedEvent = 'route_changed';

  // Setting keys
  static const String themeKey = 'theme_mode';
  static const String accentColorKey = 'accent_color';
  static const String fontSizeKey = 'font_size';
  static const String languageKey = 'language';
  static const String useDynamicColorKey = 'use_dynamic_color';
  static const String notificationsKey = 'notifications';
  static const String notificationChannelId = 'portfolio_push_channel';
  static const String notificationChannelName = 'Portfolio Notifications';
  static const String notificationChannelDescription = 'Used for portfolio updates and interactive messages.';
  static const String versionUpdatesTopic = 'version_updates';
  static const String defaultNotificationIcon = '@mipmap/ic_launcher';
  static const String notificationParamTab = 'tab';
  static const String notificationTabSettings = 'settings';
  static const String notificationTabOverview = 'overview';
  static const String notificationTabAboutMe = 'aboutMe';
  static const String notificationTabProjects = 'projects';
  static const String notificationTabArchitecture = 'architecture';

  // Data keys
  static const String userDataKey = 'user_data';
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String loginUsernameKey = 'login_username';
  static const String loginPasswordKey = 'login_password';
  static const String loginRememberMeKey = 'login_remember_me';
  static const String projectsDataKey = 'projects_data';
  static const String aboutMeDataKey = 'about_me';

  // Common keys
  static const String appName = 'lPortfolio';
  static const String author = 'Listen';
  static const String date = '2026';
  static const String mail = 'listen2code@gmail.com';
  static const String github = 'https://github.com/listen2code';
}
