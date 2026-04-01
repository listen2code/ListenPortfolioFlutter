import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';

// Mock environment configuration class for AppEnv initialization.
class TestEnvConfig implements BaseEnvConfig {
  @override
  int get apiTimeout => 5000;
  
  @override
  String get baseUrl => 'http://api.test.com';
  
  @override
  int get connectTimeout => 5000;
  
  @override
  AppEnvironment get env => AppEnvironment.mock;
  
  @override
  int get receiveTimeout => 5000;
}

/// Initialize test environment for all tests that require network access
Future<void> setupTestEnvironment() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  try {
    // Initialize global AppEnv to prevent exceptions when ApiClient is accessed.
    await AppEnv.init([TestEnvConfig()]);
  } catch (e) {
    // AppEnv might already be initialized, which is fine for tests
    // This prevents duplicate initialization errors
  }
}
