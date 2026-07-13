import 'dart:convert';

import 'package:listen_core/core.dart';

import '../../../../shared/shared.dart';
import '../models/user_model.dart';

/// Local data source for authentication.
/// Handles caching of auth token, refresh token, and user data.
class AuthLocalDataSource implements CacheDataSource<UserModel> {
  AuthLocalDataSource();

  /// Cache authentication token securely.
  Future<void> cacheAuthToken(String? token) async {
    appLogger.d('AuthLocalDataSource: Starting to cache auth token');
    try {
      await SecureStorageUtil.put(AppConstants.authTokenKey, token);
      appLogger.d('AuthLocalDataSource: Auth token cached successfully');
    } catch (e) {
      appLogger.e('AuthLocalDataSource: Failed to cache auth token: $e');
      throw CacheException('Failed to cache authentication token');
    }
  }

  /// Cache refresh token securely.
  Future<void> cacheRefreshToken(String? token) async {
    appLogger.d('AuthLocalDataSource: Starting to cache refresh token');
    try {
      await SecureStorageUtil.put(AppConstants.refreshTokenKey, token);
      appLogger.d('AuthLocalDataSource: Refresh token cached successfully');
    } catch (e) {
      appLogger.e('AuthLocalDataSource: Failed to cache refresh token: $e');
    }
  }

  /// Get cached authentication token.
  Future<String?> getAuthToken() async {
    appLogger.d('AuthLocalDataSource: Fetching auth token from secure storage');
    try {
      final token = await SecureStorageUtil.get(AppConstants.authTokenKey);
      if (token != null) {
        appLogger.d('AuthLocalDataSource: Auth token retrieved successfully');
      } else {
        appLogger.d('AuthLocalDataSource: No auth token found in secure storage');
      }
      return token;
    } catch (e) {
      appLogger.e('AuthLocalDataSource: Failed to get auth token: $e');
      return null;
    }
  }

  /// Get cached refresh token.
  Future<String?> getRefreshToken() async {
    appLogger.d('AuthLocalDataSource: Fetching refresh token from secure storage');
    try {
      final token = await SecureStorageUtil.get(AppConstants.refreshTokenKey);
      if (token != null) {
        appLogger.d('AuthLocalDataSource: Refresh token retrieved successfully');
      } else {
        appLogger.d('AuthLocalDataSource: No refresh token found in secure storage');
      }
      return token;
    } catch (e) {
      appLogger.e('AuthLocalDataSource: Failed to get refresh token: $e');
      return null;
    }
  }

  /// Cache user data using SpUtil.
  @override
  Future<void> cache(UserModel? user) async {
    appLogger.d('AuthLocalDataSource: Starting to cache user data');
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
  @override
  Future<UserModel?> getCached() async {
    appLogger.d('AuthLocalDataSource: Fetching user data from cache');
    try {
      final userJson = SpUtil.getString(AppConstants.userDataKey);
      if (userJson != null) {
        final user = UserModel.fromJson(json.decode(userJson) as Map<String, dynamic>);
        appLogger.d('AuthLocalDataSource: UserModel retrieved from cache: ${user.id}');
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
    appLogger.d('AuthLocalDataSource: Starting to clear all auth data');
    try {
      await SecureStorageUtil.remove(AppConstants.authTokenKey);
      await SecureStorageUtil.remove(AppConstants.refreshTokenKey);
      await SpUtil.remove(AppConstants.userDataKey);
      await SpUtil.remove(AppConstants.projectsDataKey);
      await SpUtil.remove(AppConstants.aboutMeDataKey);
      await SpUtil.remove(AppConstants.resumeKey);
      appLogger.d('AuthLocalDataSource: All auth data cleared successfully');
    } catch (e) {
      appLogger.e('AuthLocalDataSource: Failed to clear auth data: $e');
      throw CacheException('Failed to clear authentication data');
    }
  }
}
