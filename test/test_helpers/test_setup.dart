import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/shared/services/shorebird/shorebird_service.dart';

/// Mock environment configuration class for AppEnv initialization during unit tests.
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

/// Mock environment configuration for local mock server tests.
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

/// Initializes the global headless testing harness across all unit and widget test suites.
///
/// ### Testing Architecture & Mocking Strategy:
/// 1. **Binary Messenger Mocking**:
///    Intercepts native platform channels (`connectivity_plus`, `package_info_plus`) via
///    `setMockMethodCallHandler`. This enables tests to run completely headless on CI/CD
///    runners without requiring a real Android/iOS emulator or Gradle device.
///
/// 2. **Global HttpOverrides Protection**:
///    Replaces `dart:io` HttpClient with [_MockHttpClient]. When widgets attempt to load
///    remote SVG badges or network images, it yields an immediate 200 OK with mock vector
///    bytes, eliminating socket timeouts and offline test failures.
///
/// 3. **Defensive Environment Bootstrap**:
///    Pre-initializes [AppEnv] and [shorebirdService] to prevent `LateInitializationError`
///    when services and repositories are invoked.
Future<void> setupTestEnvironment() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock the connectivity_plus platform channel to simulate wifi connection
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('dev.fluttercommunity.plus/connectivity'),
    (MethodCall call) async => ['wifi'],
  );

  // Mock the package_info_plus platform channel
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('dev.fluttercommunity.plus/package_info'),
    (MethodCall call) async {
      if (call.method == 'getAll') {
        return {
          'appName': 'lPortfolio',
          'packageName': 'com.listen.portfolio.listen_portfolio_flutter',
          'version': '1.0.0',
          'buildNumber': '1',
          'buildSignature': '',
          'installerStore': null,
        };
      }
      return null;
    },
  );

  HttpOverrides.global = TestHttpOverrides();

  try {
    // Initialize global AppEnv to prevent exceptions when ApiClient is accessed.
    await AppEnv.init([DevEnvConfig(), MockEnvConfig()]);
  } catch (e) {
    // AppEnv might already be initialized, which is fine for tests
    // This prevents duplicate initialization errors
  }

  shorebirdService = ShorebirdServiceImpl();
}

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async => _MockHttpClientRequest();

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();

  @override
  Future<void> addStream(Stream<List<int>> stream) async {
    await stream.drain();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _MockHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => _svgBytes.length;

  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;

  @override
  HttpHeaders get headers => _MockHttpHeaders();

  @override
  String get reasonPhrase => 'OK';

  @override
  bool get isRedirect => false;

  @override
  bool get persistentConnection => false;

  @override
  List<RedirectInfo> get redirects => const [];

  static final List<int> _svgBytes = utf8.encode('<svg xmlns="http://www.w3.org/2000/svg" width="1" height="1"></svg>');

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_svgBytes]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  List<String>? operator [](String name) => null;

  @override
  void forEach(void Function(String name, List<String> values) action) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
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
