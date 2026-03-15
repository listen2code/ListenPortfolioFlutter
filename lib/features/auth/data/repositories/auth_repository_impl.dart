import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_response_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/signup_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl with BaseRepository implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, LoginResponseModel?>> login({
    required String username,
    required String password,
  }) async {
    return await safeCall<LoginResponseModel>(
      call: () => remoteDataSource.login(LoginRequestModel(username: username, password: password)),
      saveCache: (response) async {
        if (response.token != null) {
          await localDataSource.cacheAuthToken(response.token!);
        }
      },
    );
  }

  @override
  Future<Either<Failure, void>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return await safeCall<void>(
      call: () => remoteDataSource.signUp(SignupRequestModel(name: name, email: email, password: password)),
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final result = await safeCall<void>(call: () => remoteDataSource.logout());

    return result.fold((failure) => Left(failure), (_) async {
      await localDataSource.clearAuthData();
      return const Right(null);
    });
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    return await safeCall<void>(call: () => remoteDataSource.forgotPassword(email));
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    return await safeCall<void>(call: () => remoteDataSource.changePassword(oldPassword, newPassword));
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser({required String userId}) async {
    return await safeCall<UserModel>(
      call: () => remoteDataSource.getUserById(userId),
      saveCache: (user) => localDataSource.cacheUser(user),
      getCached: () => localDataSource.getCachedUser(),
    );
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    // 1. Retrieve the stored refresh token
    final storedRefreshToken = await localDataSource.getRefreshToken();
    if (storedRefreshToken == null) {
      return const Left(AuthFailure('No refresh token available'));
    }

    // 2. Request new credentials and persist them using the unified safeCall pipeline
    final result = await safeCall<LoginResponseModel>(
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
}
