import 'dart:async';

import 'package:dio/dio.dart';
import 'package:listen_portfolio_flutter/core/base/base_view_model.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

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
      _LoggingInterceptor(),
      _LifecycleCancelInterceptor(),
      _AuthInterceptor(),
      _ErrorInterceptor(),
    ]);

    return dio;
  }
}

/// Interceptor for logging API requests and responses
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    appLogger.i('REQUEST[${options.method}] => PATH: ${options.path}');
    appLogger.i('Full URL: ${options.baseUrl}${options.path}');
    appLogger.i('Headers: ${options.headers}');
    appLogger.i('Data: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    appLogger.i('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    appLogger.i('Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    appLogger.e('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    appLogger.e('Message: ${err.message}');
    appLogger.e('Data: ${err.response?.data}');
    super.onError(err, handler);
  }
}

/// Interceptor that automatically attaches a CancelToken from the current Dart Zone.
class _LifecycleCancelInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Try to retrieve the CancelToken injected by ConsumeViewModel.dispatch
    final CancelToken? zoneToken = Zone.current[kCancelTokenKey];

    // If a token is found and the request hasn't manually set one, associate them
    if (zoneToken != null && options.cancelToken == null) {
      options.cancelToken = zoneToken;
    }

    handler.next(options);
  }
}

class _AuthInterceptor extends Interceptor {
}

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
