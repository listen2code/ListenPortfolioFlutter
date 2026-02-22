import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/core/utils/zone_manager.dart';

/// Creates and configures a single Dio instance for the entire application
class ApiClient {
  ApiClient._();

  static final Dio _dio = _initDio();

  static Dio get dio => _dio;

  static Dio _initDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: Duration(milliseconds: AppEnv.connectTimeout),
        receiveTimeout: Duration(milliseconds: AppEnv.receiveTimeout),
        sendTimeout: Duration(milliseconds: AppEnv.apiTimeout),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      _ZoneContextInterceptor(),
      _LoggingInterceptor(),
      _AuthInterceptor(),
      _ErrorInterceptor(),
    ]);

    return dio;
  }
}

/// Interceptor for logging API requests and responses.
/// Note: Log prefix [traceId] is automatically added by _TracePrinter in appLogger.
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.write('🌐 REQUEST [${options.method.toUpperCase()}] => ${options.uri}');

    if (options.headers.isNotEmpty) {
      buffer.write('\nHeaders: {');
      options.headers.forEach((key, value) => buffer.write('\n  $key: $value'));
      buffer.write('\n}');
    }

    if (options.data != null) {
      buffer.write('\nBody: ${_prettyJson(options.data)}');
    }

    appLogger.i(buffer.toString());
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.write('✅ RESPONSE [${response.statusCode}] <= ${response.requestOptions.path}');
    buffer.write('\nData: ${_prettyJson(response.data)}');

    appLogger.i(buffer.toString());
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.write('❌ ERROR [${err.response?.statusCode ?? 'N/A'}] !! ${err.requestOptions.path}');
    buffer.write('\nMessage: ${err.message}');
    if (err.response?.data != null) {
      buffer.write('\nError Body: ${_prettyJson(err.response?.data)}');
    }

    appLogger.e(buffer.toString());
    super.onError(err, handler);
  }

  String _prettyJson(dynamic json) {
    if (json == null) return 'null';
    try {
      const encoder = JsonEncoder.withIndent('  ');
      if (json is String) {
        return encoder.convert(jsonDecode(json));
      }
      return encoder.convert(json);
    } catch (_) {
      return json.toString();
    }
  }
}

/// Interceptor that syncs context from the current Dart Zone (Trace ID and CancelToken).
class _ZoneContextInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Performance Mark: API Request sent
    ZoneManager.mark('API Request: ${options.path} Sent');

    // 1. Inject Trace ID into headers for server-side correlation
    options.headers['X-Trace-Id'] = ZoneManager.currentTraceId;

    // 2. Try to retrieve the CancelToken injected by ConsumeViewModel.dispatch
    final CancelToken? zoneToken = ZoneManager.currentCancelToken;

    // If a token is found and the request hasn't manually set one, associate them
    if (zoneToken != null && options.cancelToken == null) {
      options.cancelToken = zoneToken;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Performance Mark: API Response received
    ZoneManager.mark('API Response: ${response.requestOptions.path} Received');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Performance Mark: API Error occurred
    ZoneManager.mark('API Error: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}

class _AuthInterceptor extends Interceptor {}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppException exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        exception = NetworkException('Network connection timeout');
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final message = err.response?.data?['message'] ?? err.message;

        if (statusCode == 401 || statusCode == 403) {
          exception = AuthException(message, statusCode);
        } else if (statusCode != null && statusCode >= 500) {
          exception = ServerException('Internal Server Error: $message', statusCode);
        } else {
          exception = ServerException(message, statusCode);
        }
        break;
      case DioExceptionType.cancel:
        exception = AppException('Request cancelled');
        break;
      default:
        exception = ServerException(err.message ?? 'Unknown network error');
    }

    return handler.next(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        type: err.type,
        response: err.response,
      ),
    );
  }
}

class ApiResult {
  ApiResult._();

  static const String success = "0";
  static const String serverError = "1";
  static const String sessionTimeout = "3";
}
