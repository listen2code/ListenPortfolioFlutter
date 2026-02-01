import 'package:dio/dio.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/network/api_client.dart';
import 'package:listen_portfolio_flutter/core/utils/logger.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_response_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/signup_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';

/// Remote data source for authentication
class AuthRemoteDataSource {
  AuthRemoteDataSource();

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    appLogger.d('AuthRemoteDataSource: login called for ${request.username}');

    try {
      final response = await ApiClient.dio.post('${AppConstants.apiBaseUrl}/v1/auth/login', data: request.toJson());

      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      appLogger.e('AuthRemoteDataSource: login failed', error: e);
      rethrow;
    }
  }

  Future<UserModel> signUp(SignupRequestModel request) async {
    appLogger.d('AuthRemoteDataSource: Sign Up called');

    try {
      final response = await ApiClient.dio.post('${AppConstants.apiBaseUrl}/v1/auth/signUp', data: request.toJson());

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      appLogger.e('AuthRemoteDataSource: Sign Up failed', error: e);
      rethrow;
    }
  }

  Future<void> logout() async {
    appLogger.d('AuthRemoteDataSource: logout called');
    try {
      await ApiClient.dio.post('${AppConstants.apiBaseUrl}/v1/auth/logout');
    } on DioException catch (e) {
      appLogger.e('AuthRemoteDataSource: logout failed', error: e);
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    appLogger.d('AuthRemoteDataSource: forgotPassword called');
    try {
      await ApiClient.dio.post('${AppConstants.apiBaseUrl}/v1/auth/forgot-password', data: {'email': email});
    } on DioException catch (e) {
      appLogger.e('AuthRemoteDataSource: forgotPassword failed', error: e);
      rethrow;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    appLogger.d('AuthRemoteDataSource: changePassword called');
    try {
      // In a real app, you'd have the user ID. Using a placeholder for mock.
      await ApiClient.dio.post(
        '${AppConstants.apiBaseUrl}/v1/auth/change-password',
        data: {'oldPassword': oldPassword, 'newPassword': newPassword},
      );
    } on DioException catch (e) {
      appLogger.e('AuthRemoteDataSource: changePassword failed', error: e);
      rethrow;
    }
  }

  Future<UserModel> getUserById(String id) async {
    appLogger.d('AuthRemoteDataSource: getUserById called');
    try {
      final response = await ApiClient.dio.get('${AppConstants.apiBaseUrl}/v1/users/$id');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      appLogger.e('AuthRemoteDataSource: getUserById failed', error: e);
      rethrow;
    }
  }
}
