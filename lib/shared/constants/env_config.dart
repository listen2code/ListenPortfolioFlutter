import 'package:listen_core/core.dart';

/// Project-specific environment configurations.
/// Using an enum here allows us to leverage [.values] for automatic registration in [AppEnv].
enum EnvConfigs implements BaseEnvConfig {
  mock(
    env: AppEnvironment.mock,
    baseUrl: 'http://localhost:9999',
    apiTimeout: 30000,
    connectTimeout: 5000,
    receiveTimeout: 5000,
  ),
  dev(
    env: AppEnvironment.dev,
    baseUrl: 'http://192.168.0.223:9898',
    apiTimeout: 30000,
    connectTimeout: 15000,
    receiveTimeout: 15000,
  ),
  test(
    env: AppEnvironment.test,
    baseUrl: 'http://192.168.0.223:8080',
    apiTimeout: 30000,
    connectTimeout: 15000,
    receiveTimeout: 15000,
  ),
  prod(
    env: AppEnvironment.prod,
    baseUrl: 'https://api.lPortfolio.com',
    apiTimeout: 60000,
    connectTimeout: 30000,
    receiveTimeout: 30000,
  );

  @override
  final AppEnvironment env;

  @override
  final String baseUrl;

  @override
  final int apiTimeout;

  @override
  final int connectTimeout;

  @override
  final int receiveTimeout;

  const EnvConfigs({
    required this.env,
    required this.baseUrl,
    required this.apiTimeout,
    required this.connectTimeout,
    required this.receiveTimeout,
  });
}
