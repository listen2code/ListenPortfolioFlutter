import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:mocktail/mocktail.dart';

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

// Mock interceptor delegate to control token injection and refresh in tests.
class MockApiInterceptorDelegate extends Mock implements IApiInterceptorDelegate {}

// Custom HttpClientAdapter that returns queued responses per path.
// Needed because DioAdapter's FullHttpRequestMatcher can't match
// headers that are dynamically injected by interceptors.
class _SequentialMockAdapter implements HttpClientAdapter {
  final Map<String, List<(int, dynamic)>> _queue = {};

  void enqueue(String path, int statusCode, dynamic data) {
    _queue.putIfAbsent(path, () => []).add((statusCode, data));
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final queue = _queue[options.path];
    if (queue == null || queue.isEmpty) {
      throw DioException(
        requestOptions: options,
        message: 'No queued mock response for ${options.path}',
        type: DioExceptionType.unknown,
      );
    }
    final (statusCode, data) = queue.removeAt(0);
    return ResponseBody.fromString(
      jsonEncode(data),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Dio dio;
  late MockApiInterceptorDelegate mockDelegate;

  // Mock success response following business specifications.
  final Map<String, dynamic> mockSuccessResponse = {
    "result": "0",
    "messageId": "msg_ok",
    "message": "success",
    "body": {"data": "some_data"},
  };

  // Mock 401 Unauthorized response (Token expired).
  final Map<String, dynamic> mock401Response = {
    "result": "1",
    "messageId": "msg_err",
    "message": "unauthorized",
    "body": null,
  };

  setUpAll(() async {
    // Ensure Flutter binding is initialized for testing.
    TestWidgetsFlutterBinding.ensureInitialized();
    try {
      // Initialize global AppEnv to prevent exceptions when ApiClient is accessed.
      await AppEnv.init([TestEnvConfig()]);
    } catch (_) {}
  });

  setUp(() {
    mockDelegate = MockApiInterceptorDelegate();
    // Initialize ApiClient with mock delegate.
    ApiClient.init(mockDelegate);
    dio = ApiClient.dio;

    // Register fallback RequestOptions for mocktail matching.
    registerFallbackValue(RequestOptions(path: ''));

    // Default behavior: mock trace header injection.
    when(() => mockDelegate.onInjectTraceHeader(any(), any())).thenReturn(null);
  });

  group('_AuthInterceptor Logic Tests', () {
    test('should trigger refresh on 401 and resolve original request on success', () async {
      const path = '/test-auth-flow';
      String currentToken = 'old_token'; // Initial mock token

      // Mock token injection: dynamically set header based on currentToken variable.
      when(() => mockDelegate.onInjectAuthHeader(any())).thenAnswer((invocation) async {
        final options = invocation.positionalArguments[0] as RequestOptions;
        options.headers['Authorization'] = 'Bearer $currentToken';
      });

      // Mock token refresh: update token and return success.
      when(() => mockDelegate.onRefreshToken()).thenAnswer((_) async {
        currentToken = 'new_token';
        return true;
      });

      // Use a sequential mock adapter instead of DioAdapter header matching,
      // because FullHttpRequestMatcher can't see dynamically injected headers.
      final mockAdapter = _SequentialMockAdapter()
        ..enqueue(path, 401, mock401Response)
        ..enqueue(path, 200, mockSuccessResponse);
      dio.httpClientAdapter = mockAdapter;

      final response = await dio.get(path);

      // Verify final results: statusCode 200 and success data.
      expect(response.statusCode, 200);
      expect(response.data['result'], '0');
      // Verify core logic: onRefreshToken called exactly once.
      verify(() => mockDelegate.onRefreshToken()).called(1);
    });

    test('should break infinite loop if retry still returns 401', () async {
      const path = '/perpetual-401';

      when(() => mockDelegate.onInjectAuthHeader(any())).thenAnswer((_) async {});
      when(() => mockDelegate.onRefreshToken()).thenAnswer((_) async => true);

      // Mock server failure: always return 401 regardless of retry.
      final mockAdapter = _SequentialMockAdapter()
        ..enqueue(path, 401, mock401Response)
        ..enqueue(path, 401, mock401Response);
      dio.httpClientAdapter = mockAdapter;

      try {
        await dio.get(path);
        fail('Should have thrown DioException');
      } catch (e) {
        // Verify exception is DioException with 401 statusCode.
        expect(e, isA<DioException>());
        final dioErr = e as DioException;
        expect(dioErr.response?.statusCode, 401);
      }

      // Verify safety logic: should refresh only once despite multiple 401s due to is_refreshed flag.
      verify(() => mockDelegate.onRefreshToken()).called(1);
    });

    test('should queue concurrent 401 requests and retry all after success', () async {
      const p1 = '/concurrent-1';
      const p2 = '/concurrent-2';
      String token = 'old';

      // Dynamic header injection logic.
      when(() => mockDelegate.onInjectAuthHeader(any())).thenAnswer((inv) async {
        final options = inv.positionalArguments[0] as RequestOptions;
        options.headers['Authorization'] = 'Bearer $token';
      });

      // Mock refresh logic: add delay to simulate network latency and test queuing.
      when(() => mockDelegate.onRefreshToken()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50));
        token = 'new';
        return true;
      });

      // Use a sequential mock adapter instead of DioAdapter header matching,
      // because FullHttpRequestMatcher can't see dynamically injected headers.
      final mockAdapter = _SequentialMockAdapter()
        ..enqueue(p1, 401, mock401Response)
        ..enqueue(p1, 200, mockSuccessResponse)
        ..enqueue(p2, 401, mock401Response)
        ..enqueue(p2, 200, mockSuccessResponse);
      dio.httpClientAdapter = mockAdapter;

      // Fire concurrent requests simultaneously.
      final results = await Future.wait([dio.get(p1), dio.get(p2)]);

      // Verify both concurrent requests succeed after retry.
      expect(results[0].statusCode, 200);
      expect(results[1].statusCode, 200);
      // Core verification: onRefreshToken called only once due to queuing.
      verify(() => mockDelegate.onRefreshToken()).called(1);
    });
  });
}
