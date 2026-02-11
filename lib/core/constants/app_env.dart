import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppEnvironment {
  dev('dev'),
  test('test'),
  prod('prod');

  final String name;

  const AppEnvironment(this.name);

  static AppEnvironment fromString(String env) {
    return AppEnvironment.values.firstWhere((e) => e.name == env, orElse: () => AppEnvironment.dev);
  }
}

class AppEnv {
  AppEnv._();

  // Internal state, defaults to compile-time define
  static AppEnvironment _env = AppEnvironment.fromString(
    const String.fromEnvironment('APP_ENV', defaultValue: 'dev'),
  );

  /// Initializes the environment by checking local storage
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEnv = prefs.getString(AppConstants.envKey);
    if (savedEnv != null) {
      _env = AppEnvironment.fromString(savedEnv);
    }
    _applyDioConfig();
  }

  static bool isProd() => _env == AppEnvironment.prod;

  static const _devConfig = (
    baseUrl: 'http://192.168.0.224:9898',
    apiTimeout: 30000,
    connectTimeout: 15000,
    receiveTimeout: 15000,
  );

  static const _testConfig = (
    baseUrl: 'http://192.168.0.100:9898',
    apiTimeout: 30000,
    connectTimeout: 15000,
    receiveTimeout: 15000,
  );

  static const _prodConfig = (
    baseUrl: 'https://api.lPortfolio.com',
    apiTimeout: 60000,
    connectTimeout: 30000,
    receiveTimeout: 30000,
  );

  static AppEnvironment get currentEnv => _env;

  static String get env => _env.name;

  static dynamic get _current {
    switch (_env) {
      case AppEnvironment.prod:
        return _prodConfig;
      case AppEnvironment.test:
        return _testConfig;
      case AppEnvironment.dev:
        return _devConfig;
    }
  }

  /// Updates current environment and persists the result to local storage
  static Future<void> setEnvironment(AppEnvironment newEnv) async {
    _env = newEnv;
    _applyDioConfig();

    // Save to SharedPreferences for persistence across restarts
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.envKey, newEnv.name);
  }

  static void _applyDioConfig() {
    ApiClient.dio.options.baseUrl = apiBaseUrl;
    ApiClient.dio.options.connectTimeout = Duration(milliseconds: connectTimeout);
    ApiClient.dio.options.receiveTimeout = Duration(milliseconds: receiveTimeout);
    ApiClient.dio.options.sendTimeout = Duration(milliseconds: apiTimeout);
  }

  static String get apiBaseUrl => _current.baseUrl;

  static int get apiTimeout => _current.apiTimeout;

  static int get connectTimeout => _current.connectTimeout;

  static int get receiveTimeout => _current.receiveTimeout;
}
