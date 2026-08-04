import 'dart:convert';
import 'package:listen_core/core.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/change_password_request_model.dart';
import '../models/delete_account_request_model.dart';
import '../models/forgot_password_request_model.dart';
import '../models/get_current_user_request_model.dart';
import '../models/login_model.dart';
import '../models/login_request_model.dart';
import '../models/signup_request_model.dart';
import '../models/user_model.dart';
import '../models/upload_avatar_request_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl with BaseRepository implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, LoginModel?>> login({required LoginRequestModel? param}) async {
    return await safeCall<LoginModel>(
      call: () => remoteDataSource.login(param),
      saveCache: (response) async {
        if (response.token != null) {
          await localDataSource.cacheAuthToken(response.token!);
        }
        if (response.refreshToken != null) {
          await localDataSource.cacheRefreshToken(response.refreshToken!);
        }
      },
    );
  }

  @override
  Future<Either<Failure, void>> signUp({required SignupRequestModel? param}) async {
    return await safeCall<void>(call: () => remoteDataSource.signUp(param));
  }

  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final normalizedSource = base64Url.normalize(parts[1]);
      final payloadString = utf8.decode(base64Url.decode(normalizedSource));
      final Map<String, dynamic> payload = json.decode(payloadString) as Map<String, dynamic>;
      final exp = payload['exp'];
      if (exp == null) return false;
      final int expSeconds = exp as int;
      final int nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      // 10 seconds leeway buffer for network latency
      return nowSeconds >= (expSeconds - 10);
    } catch (_) {
      return true;
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final token = await localDataSource.getAuthToken();
    if (token != null && _isTokenExpired(token)) {
      appLogger.i('AuthRepository: Access token is expired. Performing silent refresh before logout API call.');
      final refreshResult = await refreshToken();
      if (refreshResult.isLeft()) {
        appLogger.w('AuthRepository: Silent refresh failed. Force clearing local auth data to ensure client logs out.');
        await localDataSource.clearAuthData();
        return const Right(null);
      }
    }

    final result = await safeCall<void>(call: () => remoteDataSource.logout());

    return result.fold((failure) async {
      // Even if the logout API fails (e.g. backend error or network timeout), we still clear
      // local authentication data to prevent the client from being stuck in a logged-in state.
      await localDataSource.clearAuthData();
      return Left(failure);
    }, (_) async {
      await localDataSource.clearAuthData();
      return const Right(null);
    });
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required ForgotPasswordRequestModel? param}) async {
    return await safeCall<void>(call: () => remoteDataSource.forgotPassword(param));
  }

  @override
  Future<Either<Failure, void>> changePassword({required ChangePasswordRequestModel? param}) async {
    return await safeCall<void>(call: () => remoteDataSource.changePassword(param));
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser({required GetCurrentUserRequestModel? param}) async {
    return await safeCall<UserModel>(
      call: () => remoteDataSource.getUserById(param?.userId ?? ''),
      cacheDataSource: localDataSource,
    );
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    // 1. Retrieve the stored refresh token
    final storedRefreshToken = await localDataSource.getRefreshToken();
    if (storedRefreshToken == null) {
      return const Left(AuthFailure('No refresh token available'));
    }

    // 2. Request new credentials and persist them
    final result = await safeCall<LoginModel>(
      call: () => remoteDataSource.refreshToken(storedRefreshToken),
      saveCache: (response) async {
        if (response.token != null) {
          await localDataSource.cacheAuthToken(response.token!);
        }
        if (response.refreshToken != null) {
          await localDataSource.cacheRefreshToken(response.refreshToken!);
        }
      },
    );

    // 3. Return the new access token if successful
    return result.map((response) => response.token ?? '');
  }

  @override
  Future<Either<Failure, void>> deleteAccount({required DeleteAccountRequestModel? param}) async {
    return await safeCall<void>(call: () => remoteDataSource.deleteAccount(param));
  }

  @override
  Future<Either<Failure, UserModel?>> uploadAvatar({required String base64Data}) async {
    return await safeCall<UserModel>(
      call: () => remoteDataSource.uploadAvatar(UploadAvatarRequestModel(avatar: base64Data)),
    );
  }
}
