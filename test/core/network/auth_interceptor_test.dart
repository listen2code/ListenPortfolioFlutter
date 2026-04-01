import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
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

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
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
    // Use DioAdapter to mock network responses for Dio instance.
    dioAdapter = DioAdapter(dio: dio);

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

      // Configure Mock response sequence:
      // 1. Server returns 401 for old_token.
      dioAdapter.onGet(
        path,
        (server) => server.reply(401, mock401Response),
        headers: {'Authorization': 'Bearer old_token'},
      );

      // 2. Server returns 200 for new_token after retry.
      dioAdapter.onGet(
        path,
        (server) => server.reply(200, mockSuccessResponse),
        headers: {'Authorization': 'Bearer new_token'},
      );

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
      dioAdapter.onGet(path, (server) => server.reply(401, mock401Response));

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

      // Mock responses for concurrent requests: 401 then 200.
      dioAdapter.onGet(p1, (s) => s.reply(401, mock401Response), headers: {'Authorization': 'Bearer old'});
      dioAdapter.onGet(
        p1,
        (s) => s.reply(200, mockSuccessResponse),
        headers: {'Authorization': 'Bearer new'},
      );

      dioAdapter.onGet(p2, (s) => s.reply(401, mock401Response), headers: {'Authorization': 'Bearer old'});
      dioAdapter.onGet(
        p2,
        (s) => s.reply(200, mockSuccessResponse),
        headers: {'Authorization': 'Bearer new'},
      );

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
