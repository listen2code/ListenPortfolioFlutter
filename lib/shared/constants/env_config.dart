import 'package:listen_core/core.dart';

/// Project-specific environment configurations.
/// Using an enum here allows us to leverage [.values] for automatic registration in [AppEnv].
enum EnvConfigs implements BaseEnvConfig {
  /// Local mock sandbox environment powered by [LocalMockServer].
  mock(
    env: AppEnvironment.mock,
    baseUrl: 'http://localhost:9999',
    apiTimeout: 30000,
    connectTimeout: 5000,
    receiveTimeout: 5000,
  ),

  /// Local network development environment for physical device / emulator debugging.
  dev(
    env: AppEnvironment.dev,
    baseUrl: 'http://192.168.0.224:8080',
    apiTimeout: 30000,
    connectTimeout: 15000,
    receiveTimeout: 15000,
  ),

  /// Cloud production environment deployed on AWS EC2 (`13.218.192.181`).
  ///
  /// ### Web Same-Origin Reverse Proxy Architecture:
  /// - Points to `http://13.218.192.181/api` (port 80) rather than port 8080 directly.
  /// - When Flutter Web is hosted at `http://13.218.192.181/`, making API calls to
  ///   `http://13.218.192.181/api/...` is completely **same-origin (same scheme, host, port)**.
  /// - This eliminates browser Cross-Origin Resource Sharing (CORS) preflight (`OPTIONS`)
  ///   roundtrips, prevents XMLHttpRequest blocking, and avoids third-party cookie restrictions.
  /// - Nginx reverse-proxies incoming `/api/` traffic transparently to the Spring Boot
  ///   container running on `127.0.0.1:8080`, stripping the `/api` prefix cleanly.
  prod(
    env: AppEnvironment.prod,
    baseUrl: 'http://13.218.192.181/api',
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
