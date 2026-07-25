import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';

// Mock environment configuration class for AppEnv initialization.
class DevEnvConfig implements BaseEnvConfig {
  @override
  AppEnvironment get env => AppEnvironment.dev;

  @override
  int get apiTimeout => 5000;

  @override
  String get baseUrl => 'http://api.dev.com';

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

  // Mock the connectivity_plus platform channel to simulate wifi connection
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('dev.fluttercommunity.plus/connectivity'),
    (MethodCall call) async => ['wifi'],
  );

  try {
    // Initialize global AppEnv to prevent exceptions when ApiClient is accessed.
    await AppEnv.init([DevEnvConfig(), MockEnvConfig()]);
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
