import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';

/// Creates and configures a Dio instance for API calls
class ApiClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
        sendTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(_LoggingInterceptor());
    dio.interceptors.add(_AuthInterceptor());

    return dio;
  }
}

/// Interceptor for logging API requests and responses
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    appLogger.d('REQUEST[${options.method}] => PATH: ${options.path}');
    appLogger.d('Headers: ${options.headers}');
    appLogger.d('Data: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    appLogger.i(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    appLogger.d('Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    appLogger.e(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    appLogger.e('Message: ${err.message}');
    appLogger.e('Data: ${err.response?.data}');
    super.onError(err, handler);
  }
}

/// Interceptor for adding authentication token to requests
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // TODO: Get token from secure storage and add to headers
    // final token = await secureStorage.read(key: AppConstants.authTokenKey);
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    super.onRequest(options, handler);
  }
}
