import 'package:listen_portfolio_flutter/core/core.dart';

class BizEnvConfigs {
  static const mock = BizEnvConfig(
    baseUrl: 'http://localhost:9999',
    apiTimeout: 30000,
    connectTimeout: 5000,
    receiveTimeout: 5000,
  );

  static const dev = BizEnvConfig(
    baseUrl: 'http://192.168.0.224:9898',
    apiTimeout: 30000,
    connectTimeout: 15000,
    receiveTimeout: 15000,
  );

  static const test = BizEnvConfig(
    baseUrl: 'http://192.168.0.100:9898',
    apiTimeout: 30000,
    connectTimeout: 15000,
    receiveTimeout: 15000,
  );

  static const prod = BizEnvConfig(
    baseUrl: 'https://api.lPortfolio.com',
    apiTimeout: 60000,
    connectTimeout: 30000,
    receiveTimeout: 30000,
  );
}

class BizEnvConfig implements EnvConfig {
  @override
  final String baseUrl;
  @override
  final int apiTimeout;
  @override
  final int connectTimeout;
  @override
  final int receiveTimeout;

  const BizEnvConfig({
    required this.baseUrl,
    required this.apiTimeout,
    required this.connectTimeout,
    required this.receiveTimeout,
  });
}
