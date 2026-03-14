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
    final result = await safeCall<LoginResponseModel>(
      call: () => remoteDataSource.login(LoginRequestModel(username: username, password: password)),
    );

    return result.fold((failure) => Left(failure), (loginResponse) async {
      if (loginResponse.token != null) {
        await localDataSource.cacheAuthToken(loginResponse.token!);
      }
      return Right(loginResponse);
    });
  }

  @override
  Future<Either<Failure, void>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = await safeCall<void>(
      call: () => remoteDataSource.signUp(SignupRequestModel(name: name, email: email, password: password)),
    );

    return result.fold((failure) => Left(failure), (_) async {
      return const Right(null);
    });
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
    final result = await safeCall<UserModel>(call: () => remoteDataSource.getUserById(userId));

    return result.fold(
      (failure) async {
        final cachedUser = await localDataSource.getCachedUser();
        if (cachedUser != null && failure is! ServerFailure) {
          return Right(cachedUser);
        }
        return Left(failure);
      },
      (user) async {
        await localDataSource.cacheUser(user);
        return Right(user);
      },
    );
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    // 1. Retrieve the stored refresh token
    final refreshToken = await localDataSource.getRefreshToken();
    if (refreshToken == null) {
      return const Left(AuthFailure('No refresh token available'));
    }

    // 2. Request new credentials from server
    final result = await safeCall<LoginResponseModel>(
      call: () => remoteDataSource.refreshToken(refreshToken),
    );

    // 3. Update local cache and return the new access token
    return result.fold((failure) => Left(failure), (response) async {
      if (response.token != null) {
        await localDataSource.cacheAuthToken(response.token!);
      }
      if (response.refreshToken != null) {
        await localDataSource.cacheRefreshToken(response.refreshToken!);
      }
      return Right(response.token ?? '');
    });
  }
}
