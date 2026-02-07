import 'package:listen_portfolio_flutter/shared/network/api_client.dart';

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

  static AppEnvironment _env = AppEnvironment.fromString(
    String.fromEnvironment('APP_ENV', defaultValue: AppEnvironment.dev.name),
  );

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

  static void setEnvironment(AppEnvironment newEnv) {
    _env = newEnv;
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
