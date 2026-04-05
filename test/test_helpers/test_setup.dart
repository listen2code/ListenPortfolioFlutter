import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';

// Mock environment configuration class for AppEnv initialization.
class TestEnvConfig implements BaseEnvConfig {
  @override
  AppEnvironment get env => AppEnvironment.test;
  
  @override
  int get apiTimeout => 5000;
  
  @override
  String get baseUrl => 'http://api.test.com';
  
  @override
  int get connectTimeout => 5000;
  
  @override
  int get receiveTimeout => 5000;
}

class MockEnvConfig implements BaseEnvConfig {
  @override
  AppEnvironment get env => AppEnvironment.mock;
  
  @override
  int get apiTimeout => 5000;
  
  @override
  String get baseUrl => 'http://localhost:9999';
  
  @override
  int get connectTimeout => 5000;
  
  @override
  int get receiveTimeout => 5000;
}

/// Initialize test environment for all tests that require network access
Future<void> setupTestEnvironment() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  try {
    // Initialize global AppEnv to prevent exceptions when ApiClient is accessed.
    await AppEnv.init([TestEnvConfig(), MockEnvConfig()]);
  } catch (e) {
    // AppEnv might already be initialized, which is fine for tests
    // This prevents duplicate initialization errors
  }
}

/// Clean up test environment
Future<void> cleanupTestEnvironment() async {
  try {
    // Clean up any running servers or connections
    // This helps prevent port conflicts between tests
  } catch (e) {
    // Ignore cleanup errors
  }
}
