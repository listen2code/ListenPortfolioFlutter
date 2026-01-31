/// Application-wide constants
class AppConstants {
  AppConstants._();

  // API Configuration
  static const String apiBaseUrl = 'https://api.example.com/v1';
  static const int apiTimeout = 30000; // 30 seconds
  static const int connectTimeout = 15000; // 15 seconds
  static const int receiveTimeout = 15000; // 15 seconds

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String notificationsKey = 'notifications_enabled';

  // App Info
  static const String appName = 'lPortfolio';
  static const String appVersion = '1.0.0';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
