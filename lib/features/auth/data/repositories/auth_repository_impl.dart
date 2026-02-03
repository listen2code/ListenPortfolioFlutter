import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/signup_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository
/// Coordinates between remote and local data sources
/// Handles error conversion from exceptions to failures
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({required this.remoteDataSource, required this.localDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, UserModel?>> login({required String username, required String password}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final request = LoginRequestModel(username: username, password: password);

      final response = await remoteDataSource.login(request);

      // Cache token and user
      await localDataSource.cacheAuthToken(response.token);
      await localDataSource.cacheUser(response.user);

      appLogger.i('AuthRepository: Login successful');
      return Right(response.user);
    } on ServerException catch (e) {
      appLogger.e('AuthRepository: Server error during login: ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      appLogger.e('AuthRepository: Network error during login: ${e.message}');
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      appLogger.e('AuthRepository: Cache error during login: ${e.message}');
      return Left(CacheFailure(e.message));
    } catch (e) {
      appLogger.e('AuthRepository: Unknown error during login: $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signUp({required String name, required String email, required String password}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final request = SignupRequestModel(name: name, email: email, password: password);

      final user = await remoteDataSource.signUp(request);

      appLogger.i('AuthRepository: Signup successful');
      return Right(user);
    } on ServerException catch (e) {
      appLogger.e('AuthRepository: Server error during signup: ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      appLogger.e('AuthRepository: Network error during signup: ${e.message}');
      return Left(NetworkFailure(e.message));
    } catch (e) {
      appLogger.e('AuthRepository: Unknown error during signup: $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearAuthData();

      appLogger.i('AuthRepository: Logout successful');
      return const Right(null);
    } on CacheException catch (e) {
      appLogger.e('AuthRepository: Cache error during logout: ${e.message}');
      return Left(CacheFailure(e.message));
    } catch (e) {
      appLogger.e('AuthRepository: Unknown error during logout: $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      await remoteDataSource.forgotPassword(email);

      appLogger.i('AuthRepository: Password reset email sent');
      return const Right(null);
    } on ServerException catch (e) {
      appLogger.e('AuthRepository: Server error during forgot password: ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      appLogger.e('AuthRepository: Network error during forgot password: ${e.message}');
      return Left(NetworkFailure(e.message));
    } catch (e) {
      appLogger.e('AuthRepository: Unknown error during forgot password: $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({required String oldPassword, required String newPassword}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      await remoteDataSource.changePassword(oldPassword, newPassword);

      appLogger.i('AuthRepository: Password changed successfully');
      return const Right(null);
    } on ServerException catch (e) {
      appLogger.e('AuthRepository: Server error during change password: ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      appLogger.e('AuthRepository: Network error during change password: ${e.message}');
      return Left(NetworkFailure(e.message));
    } catch (e) {
      appLogger.e('AuthRepository: Unknown error during change password: $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        appLogger.d('AuthRepository: UserModel retrieved from cache');
        return Right(cachedUser);
      }
      appLogger.d('AuthRepository: No cached user found');
      return const Right(null);
    } on CacheException catch (e) {
      appLogger.e('AuthRepository: Cache error getting current user: ${e.message}');
      return const Right(null);
    } catch (e) {
      appLogger.e('AuthRepository: Unknown error getting current user: $e');
      return const Right(null);
    }
  }
}
