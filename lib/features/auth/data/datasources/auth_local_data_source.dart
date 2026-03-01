import 'dart:convert';

import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

/// Local data source for authentication.
/// Handles caching of auth token, refresh token, and user data.
class AuthLocalDataSource {
  AuthLocalDataSource();

  /// Cache authentication token securely.
  Future<void> cacheAuthToken(String? token) async {
    try {
      await SecureStorageUtil.put(AppConstants.authTokenKey, token);
      appLogger.d('AuthLocalDataSource: Token cached successfully');
    } catch (e) {
      appLogger.e('AuthLocalDataSource: Failed to cache token: $e');
      throw CacheException('Failed to cache authentication token');
    }
  }

  /// Cache refresh token securely.
  Future<void> cacheRefreshToken(String? token) async {
    try {
      await SecureStorageUtil.put(AppConstants.refreshTokenKey, token);
    } catch (e) {
      appLogger.e('AuthLocalDataSource: Failed to cache refresh token: $e');
    }
  }

  /// Get cached authentication token.
  Future<String?> getAuthToken() async {
    try {
      return await SecureStorageUtil.get(AppConstants.authTokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Get cached refresh token.
  Future<String?> getRefreshToken() async {
    try {
      return await SecureStorageUtil.get(AppConstants.refreshTokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Cache user data using SpUtil.
  Future<void> cacheUser(UserModel? user) async {
    try {
      final userJson = json.encode(user?.toJson());
      await SpUtil.put(AppConstants.userDataKey, userJson);
      appLogger.d('AuthLocalDataSource: UserModel cached successfully');
    } catch (e) {
      appLogger.e('AuthLocalDataSource: Failed to cache user: $e');
      throw CacheException('Failed to cache user data');
    }
  }

  /// Get cached user data
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = SpUtil.getString(AppConstants.userDataKey);
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

  /// Clear all cached authentication data.
  Future<void> clearAuthData() async {
    try {
      await SecureStorageUtil.remove(AppConstants.authTokenKey);
      await SecureStorageUtil.remove(AppConstants.refreshTokenKey);
      await SpUtil.remove(AppConstants.userDataKey);
      appLogger.d('AuthLocalDataSource: Auth data cleared');
    } catch (e) {
      appLogger.e('AuthLocalDataSource: Failed to clear auth data: $e');
      throw CacheException('Failed to clear authentication data');
    }
  }
}
