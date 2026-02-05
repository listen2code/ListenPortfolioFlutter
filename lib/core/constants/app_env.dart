import 'package:listen_portfolio_flutter/core/network/api_client.dart';

class AppEnv {
  AppEnv._();

  static const String _dev = 'dev';
  static const String _test = 'test';
  static const String _prod = 'prod';

  static bool isProd() => _env == _prod;

  static String _env = const String.fromEnvironment('APP_ENV', defaultValue: _dev);

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

  static String get env => _env;

  static dynamic get _current {
    switch (_env) {
      case _prod:
        return _prodConfig;
      case _test:
        return _testConfig;
      default:
        return _devConfig;
    }
  }

  static void setEnvironment(String newEnv) {
    if (newEnv == _prod || newEnv == _test || newEnv == _dev) {
      _env = newEnv;
      ApiClient.dio.options.baseUrl = apiBaseUrl;
      ApiClient.dio.options.connectTimeout = Duration(milliseconds: connectTimeout);
      ApiClient.dio.options.receiveTimeout = Duration(milliseconds: receiveTimeout);
      ApiClient.dio.options.sendTimeout = Duration(milliseconds: apiTimeout);
    }
  }

  static String get apiBaseUrl => _current.baseUrl;

  static int get apiTimeout => _current.apiTimeout;

  static int get connectTimeout => _current.connectTimeout;

  static int get receiveTimeout => _current.receiveTimeout;
}
