import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/base/base_repository.dart';
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
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({required this.remoteDataSource, required this.localDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, UserModel?>> login({required String username, required String password}) async {
    final result = await safeCall<LoginResponseModel>(
      networkInfo: networkInfo,
      call: () => remoteDataSource.login(LoginRequestModel(username: username, password: password)),
    );

    return result.fold((failure) => Left(failure), (loginResponse) async {
      if (loginResponse.token != null) {
        await localDataSource.cacheAuthToken(loginResponse.token!);
      }
      if (loginResponse.user != null) {
        await localDataSource.cacheUser(loginResponse.user!);
      }
      return Right(loginResponse.user);
    });
  }

  @override
  Future<Either<Failure, UserModel?>> signUp({required String name, required String email, required String password}) async {
    final result = await safeCall<UserModel>(
      networkInfo: networkInfo,
      call: () => remoteDataSource.signUp(SignupRequestModel(name: name, email: email, password: password)),
    );

    return result;
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final result = await safeCall<void>(networkInfo: networkInfo, call: () => remoteDataSource.logout());

    return result.fold((failure) => Left(failure), (_) async {
      await localDataSource.clearAuthData();
      return const Right(null);
    });
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    return await safeCall<void>(networkInfo: networkInfo, call: () => remoteDataSource.forgotPassword(email));
  }

  @override
  Future<Either<Failure, void>> changePassword({required String oldPassword, required String newPassword}) async {
    return await safeCall<void>(networkInfo: networkInfo, call: () => remoteDataSource.changePassword(oldPassword, newPassword));
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
