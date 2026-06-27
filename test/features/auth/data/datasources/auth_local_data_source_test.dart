import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthLocalDataSource dataSource;
  final Map<String, String> secureStorageValues = {};
  bool shouldSecureStorageThrow = false;

  final Map<String, dynamic> sharedPrefsValues = {};
  bool shouldSpUtilThrow = false;

  setUp(() async {
    shouldSecureStorageThrow = false;
    secureStorageValues.clear();

    shouldSpUtilThrow = false;
    sharedPrefsValues.clear();

    // Mock the plugins.it_nomads.com/flutter_secure_storage channel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
          (MethodCall call) async {
            if (shouldSecureStorageThrow) {
              throw PlatformException(code: 'STORAGE_ERROR', message: 'Failed operation');
            }

            final args = call.arguments as Map?;
            if (call.method == 'write') {
              if (args != null) {
                secureStorageValues[args['key'] as String] = args['value'] as String;
              }
              return null;
            } else if (call.method == 'read') {
              return args != null ? secureStorageValues[args['key'] as String] : null;
            } else if (call.method == 'delete') {
              if (args != null) {
                secureStorageValues.remove(args['key'] as String);
              }
              return null;
            } else if (call.method == 'deleteAll') {
              secureStorageValues.clear();
              return null;
            }
            return null;
          },
        );

    // Mock the plugins.flutter.io/shared_preferences channel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/shared_preferences'),
          (MethodCall call) async {
            if (shouldSpUtilThrow) {
              throw PlatformException(code: 'SP_ERROR', message: 'Failed operation');
            }

            if (call.method == 'getAll') {
              // SharedPreferences expects keys to be prefixed with flutter. under the hood
              // But SpUtil prepends its own prefix as well.
              return sharedPrefsValues;
            } else if (call.method == 'remove') {
              final key = call.arguments['key'] as String;
              sharedPrefsValues.remove(key);
              return true;
            } else if (call.method == 'clear') {
              sharedPrefsValues.clear();
              return true;
            } else if (call.method.startsWith('set')) {
              final key = call.arguments['key'] as String;
              final value = call.arguments['value'];
              sharedPrefsValues[key] = value;
              return true;
            }
            return null;
          },
        );

    // Initialize SpUtil and SecureStorageUtil
    await SpUtil.init(prefix: 'test_');
    await SecureStorageUtil.init(prefix: 'test_');

    // Clear actual SharedPreferences cache
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    dataSource = AuthLocalDataSource();
  });

  group('AuthLocalDataSource - Auth Token', () {
    test('should cache and retrieve auth token successfully', () async {
      const testToken = 'mock_auth_token';

      // Act
      await dataSource.cacheAuthToken(testToken);
      final retrievedToken = await dataSource.getAuthToken();

      // Assert
      expect(retrievedToken, equals(testToken));
    });

    test('should return null when getting auth token if not cached', () async {
      // Act
      final retrievedToken = await dataSource.getAuthToken();

      // Assert
      expect(retrievedToken, isNull);
    });

    test('should throw CacheException when secure storage fails on write', () async {
      // Arrange
      shouldSecureStorageThrow = true;

      // Act & Assert
      expect(() => dataSource.cacheAuthToken('token'), throwsA(isA<CacheException>()));
    });
  });

  group('AuthLocalDataSource - Refresh Token', () {
    test('should cache and retrieve refresh token successfully', () async {
      const testToken = 'mock_refresh_token';

      // Act
      await dataSource.cacheRefreshToken(testToken);
      final retrievedToken = await dataSource.getRefreshToken();

      // Assert
      expect(retrievedToken, equals(testToken));
    });

    test('should return null when getting refresh token if not cached', () async {
      // Act
      final retrievedToken = await dataSource.getRefreshToken();

      // Assert
      expect(retrievedToken, isNull);
    });

    test('should return null when getting refresh token fails', () async {
      // Arrange
      shouldSecureStorageThrow = true;

      // Act
      final retrievedToken = await dataSource.getRefreshToken();

      // Assert
      expect(retrievedToken, isNull);
    });
  });

  group('AuthLocalDataSource - UserModel', () {
    final testUser = UserModel(
      id: 'user_123',
      name: 'John Doe',
      email: 'john.doe@example.com',
    );

    test('should cache and retrieve user model successfully', () async {
      // Act
      await dataSource.cacheUser(testUser);
      final retrievedUser = await dataSource.getCachedUser();

      // Assert
      expect(retrievedUser, isNotNull);
      expect(retrievedUser!.id, equals(testUser.id));
      expect(retrievedUser.name, equals(testUser.name));
      expect(retrievedUser.email, equals(testUser.email));
    });

    test('should return null when getting cached user if not cached', () async {
      // Act
      final retrievedUser = await dataSource.getCachedUser();

      // Assert
      expect(retrievedUser, isNull);
    });

    test('should throw CacheException when SpUtil fails on write', () async {
      // Arrange
      shouldSpUtilThrow = true;

      // Act & Assert
      expect(() => dataSource.cacheUser(testUser), throwsA(isA<CacheException>()));
    });
  });

  group('AuthLocalDataSource - Clear Data', () {
    test('should clear all cached data successfully', () async {
      // Arrange
      const testToken = 'token_to_clear';
      final testUser = UserModel(id: '1', name: 'User', email: 'email@test.com');
      
      await dataSource.cacheAuthToken(testToken);
      await dataSource.cacheRefreshToken(testToken);
      await dataSource.cacheUser(testUser);

      // Act
      await dataSource.clearAuthData();

      // Assert
      expect(await dataSource.getAuthToken(), isNull);
      expect(await dataSource.getRefreshToken(), isNull);
      expect(await dataSource.getCachedUser(), isNull);
    });

    test('should throw CacheException when clearing secure storage fails', () async {
      // Arrange
      shouldSecureStorageThrow = true;

      // Act & Assert
      expect(() => dataSource.clearAuthData(), throwsA(isA<CacheException>()));
    });
  });
}
