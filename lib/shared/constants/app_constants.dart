class AppConstants {
  AppConstants._();

  static const String appVersion = String.fromEnvironment('APP_VERSION', defaultValue: '0.0.9');

  // Setting keys
  static const String themeKey = 'theme_mode';
  static const String accentColorKey = 'accent_color';
  static const String fontSizeKey = 'font_size_factor';
  static const String languageKey = 'language';
  static const String notificationsKey = 'notifications_enabled';

  // Login credentials keys
  static const String userDataKey = 'user_data';
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = "refresh_token";
  static const String loginUsernameKey = 'login_username';
  static const String loginPasswordKey = 'login_password';
  static const String loginRememberMeKey = 'login_remember_me';

  // Common keys
  static const String appName = 'lPortfolio';
  static const String author = 'Listen';
  static const String date = '2026';
  static const String mail = 'listen2code@gmail.com';
  static const String github = 'https://github.com/listen2code';
}
