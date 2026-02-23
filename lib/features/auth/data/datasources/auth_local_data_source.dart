import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:listen_portfolio_flutter/core/errors/exceptions.dart';
import 'package:listen_portfolio_flutter/core/utils/logger.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/shared/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for authentication
/// Handles caching of auth token and user data
class AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  AuthLocalDataSource({required this.secureStorage, required this.sharedPreferences});

  /// Cache authentication token securely
  Future<void> cacheAuthToken(String? token) async {
    try {
      await secureStorage.write(key: AppConstants.authTokenKey, value: token);
      appLogger.d('AuthLocalDataSource: Token cached successfully');
    } catch (e) {
      appLogger.e('AuthLocalDataSource: Failed to cache token: $e');
      throw CacheException('Failed to cache authentication token');
    }
  }

  /// Get cached authentication token
  Future<String?> getAuthToken() async {
    try {
      final token = await secureStorage.read(key: AppConstants.authTokenKey);
      appLogger.d('AuthLocalDataSource: Token retrieved: ${token != null}');
      return token;
    } catch (e) {
      appLogger.e('AuthLocalDataSource: Failed to get token: $e');
      return null;
    }
  }

  /// Cache user data
  Future<void> cacheUser(UserModel? user) async {
    try {
      final userJson = json.encode(user?.toJson());
      await sharedPreferences.setString(AppConstants.userDataKey, userJson);
      appLogger.d('AuthLocalDataSource: UserModel cached successfully');
    } catch (e) {
      appLogger.e('AuthLocalDataSource: Failed to cache user: $e');
      throw CacheException('Failed to cache user data');
    }
  }

  /// Get cached user data
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = sharedPreferences.getString(AppConstants.userDataKey);
      if (userJson != null) {
        final user = UserModel.fromJson(json.decode(userJson));
        appLogger.d('AuthLocalDataSource: UserModel retrieved from cache');
        return user;
      }
      appLogger.d('AuthLocalDataSource: No cached user found');
      return null;
    } catch (e) {
      appLogger.e('AuthLocalDataSource: Failed to get cached user: $e');
      return null;
    }
  }

  /// Clear all cached authentication data
  Future<void> clearAuthData() async {
    try {
      await secureStorage.delete(key: AppConstants.authTokenKey);
      await sharedPreferences.remove(AppConstants.userDataKey);
      appLogger.d('AuthLocalDataSource: Auth data cleared');
    } catch (e) {
      appLogger.e('AuthLocalDataSource: Failed to clear auth data: $e');
      throw CacheException('Failed to clear authentication data');
    }
  }
}
