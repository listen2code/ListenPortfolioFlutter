import 'package:listen_portfolio_flutter/core/constants/constants.dart';
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

abstract class EnvConfig {
  String get baseUrl;

  int get connectTimeout;

  int get receiveTimeout;

  int get apiTimeout;
}

class AppEnv {
  AppEnv._();

  static const String envDefine = "APP_ENV";
  static const String defaultEnv = "mock";

  static late final Map<AppEnvironment, EnvConfig> _configs;
  static bool _isSetup = false;

  static AppEnvironment _env = AppEnvironment.fromString(
    const String.fromEnvironment(envDefine, defaultValue: defaultEnv),
  );

  static void setup(Map<AppEnvironment, EnvConfig> configs) {
    if (_isSetup) {
      throw Exception("AppEnv has already been set up.");
    }
    _configs = configs;
    _isSetup = true;
  }

  static Future<void> init() async {
    if (!_isSetup) {
      throw Exception("AppEnv must be set up before initialization.");
    }
    final savedEnv = SpUtil.getString(Constants.envKey);
    if (savedEnv != null) {
      _env = AppEnvironment.fromString(savedEnv);
    }

    if (_env == AppEnvironment.mock) {
      await LocalMockServer.start();
    }

    _applyDioConfig();
  }

  static bool isProd() => _env == AppEnvironment.prod;

  static AppEnvironment get currentEnv => _env;

  static String get env => _env.name;

  static EnvConfig get _current {
    final config = _configs[_env];
    if (config == null) {
      throw Exception(
        "No configuration found for environment: ${_env.name}. Ensure it was provided during setup.",
      );
    }
    return config;
  }

  static Future<void> setEnvironment(AppEnvironment newEnv) async {
    if (_env == AppEnvironment.mock && newEnv != AppEnvironment.mock) {
      await LocalMockServer.stop();
    }
    if (newEnv == AppEnvironment.mock) {
      await LocalMockServer.start();
    }

    _env = newEnv;
    _applyDioConfig();

    await SpUtil.put(Constants.envKey, newEnv.name);
  }

  static void _applyDioConfig() {
    final config = _current;
    ApiClient.dio.options.baseUrl = config.baseUrl;
    ApiClient.dio.options.connectTimeout = Duration(milliseconds: config.connectTimeout);
    ApiClient.dio.options.receiveTimeout = Duration(milliseconds: config.receiveTimeout);
    ApiClient.dio.options.sendTimeout = Duration(milliseconds: config.apiTimeout);
  }

  static String get apiBaseUrl => _current.baseUrl;

  static int get apiTimeout => _current.apiTimeout;

  static int get connectTimeout => _current.connectTimeout;

  static int get receiveTimeout => _current.receiveTimeout;
}
