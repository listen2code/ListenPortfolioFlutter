import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Creates and configures a single Dio instance for the entire application
class ApiClient {
  ApiClient._();

  static final Dio _dio = _initDio();

  static Dio get dio => _dio;

  static Dio _initDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppEnv.apiBaseUrl,
        connectTimeout: Duration(milliseconds: AppEnv.connectTimeout),
        receiveTimeout: Duration(milliseconds: AppEnv.receiveTimeout),
        sendTimeout: Duration(milliseconds: AppEnv.apiTimeout),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(_LoggingInterceptor());
    dio.interceptors.add(_AuthInterceptor(dio)); // Pass dio instance for retries
    dio.interceptors.add(_ErrorInterceptor());

    return dio;
  }
}

/// Interceptor for logging API requests and responses
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    appLogger.d('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    appLogger.i('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    appLogger.e('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}

class _AuthInterceptor extends Interceptor {
  final Dio dio;
  late AuthLocalDataSource _localDataSource;

  _AuthInterceptor(this.dio) {
    _initDataSource();
  }

  Future<void> _initDataSource() async {
    final prefs = await SharedPreferences.getInstance();
    _localDataSource = AuthLocalDataSource(secureStorage: const FlutterSecureStorage(), sharedPreferences: prefs);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add token to headers if it exists
    final token = await _localDataSource.getAuthToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if error is 401 Unauthorized
    if (err.response?.statusCode == 401) {
      final requestOptions = err.requestOptions;

      // Avoid infinite loop if refresh token request itself fails
      if (requestOptions.path == '/auth/refresh') {
        return handler.next(err);
      }

      try {
        final success = await _refreshToken();
        if (success) {
          // Retry original request with new token
          final token = await _localDataSource.getAuthToken();
          requestOptions.headers['Authorization'] = 'Bearer $token';

          final response = await dio.fetch(requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        appLogger.e('Token refresh failed: $e');
      }
    }
    return handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      // Get refresh token from secure storage
      final refreshToken = await const FlutterSecureStorage().read(key: 'refresh_token');
      if (refreshToken == null) return false;

      // Call your backend refresh endpoint
      final response = await dio.post('/auth/refresh', data: {'refreshToken': refreshToken});

      if (response.statusCode == 200) {
        final newToken = response.data['token'];
        final newRefreshToken = response.data['refreshToken'];

        // Update local cache
        await _localDataSource.cacheAuthToken(newToken);
        await const FlutterSecureStorage().write(key: 'refresh_token', value: newRefreshToken);

        return true;
      }
    } catch (e) {
      // Clear data on failure so user has to re-login
      await _localDataSource.clearAuthData();
      await const FlutterSecureStorage().delete(key: 'refresh_token');
    }
    return false;
  }
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

    return handler.next(DioException(requestOptions: err.requestOptions, error: exception, type: err.type, response: err.response));
  }
}

class ApiResult {
  ApiResult._();

  static const String success = "0";
  static const String serverError = "1";
  static const String sessionTimeout = "3";
}
