import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/network/api_client.dart';
import 'package:listen_portfolio_flutter/core/network/local_mock_server.dart';
import 'package:listen_portfolio_flutter/core/utils/sp_util.dart';

enum AppEnvironment {
  mock(AppEnv.defaultEnv),
  dev('dev'),
  test('test'),
  prod('prod');

  final String name;

  const AppEnvironment(this.name);

  static AppEnvironment fromString(String env) {
    return AppEnvironment.values.firstWhere(
      (e) => e.name == env,
      orElse: () => AppEnvironment.fromString(AppEnv.defaultEnv),
    );
  }
}

class AppEnv {
  AppEnv._();

  static const String envDefine = "APP_ENV";
  static const String defaultEnv = "mock";

  // Internal state, defaults to compile-time define
  static AppEnvironment _env = AppEnvironment.fromString(
    const String.fromEnvironment(envDefine, defaultValue: defaultEnv),
  );

  /// Initializes the environment by checking local storage and starting mock server if needed
  static Future<void> init() async {
    final savedEnv = SpUtil.getString(AppConstants.envKey);
    if (savedEnv != null) {
      _env = AppEnvironment.fromString(savedEnv);
    }

    // Start local server if in mock mode
    if (_env == AppEnvironment.mock) {
      await LocalMockServer.start();
    }

    _applyDioConfig();
  }

  static bool isProd() => _env == AppEnvironment.prod;

  // Configuration for local in-app mock server
  static const _mockConfig = (
    baseUrl: 'http://localhost:9999', // Points to internal LocalMockServer
    apiTimeout: 30000,
    connectTimeout: 5000,
    receiveTimeout: 5000,
  );

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
      case AppEnvironment.mock:
        return _mockConfig;
      case AppEnvironment.dev:
        return _devConfig;
      case AppEnvironment.test:
        return _testConfig;
      case AppEnvironment.prod:
        return _prodConfig;
    }
  }

  /// Updates current environment, persists state, and toggles mock server
  static Future<void> setEnvironment(AppEnvironment newEnv) async {
    // Stop server if moving away from mock
    if (_env == AppEnvironment.mock && newEnv != AppEnvironment.mock) {
      await LocalMockServer.stop();
    }
    // Start server if moving to mock
    if (newEnv == AppEnvironment.mock) {
      await LocalMockServer.start();
    }

    _env = newEnv;
    _applyDioConfig();

    await SpUtil.put(AppConstants.envKey, newEnv.name);
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
