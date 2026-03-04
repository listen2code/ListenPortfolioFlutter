import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user login flow.
/// It orchestrates the authentication and fetching the current user profile.
class LoginUseCase implements UseCase<UserModel?, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel?>> call(LoginParams params) async {
    // 1. Perform Login (Authentication)
    final loginResult = await repository.login(username: params.username, password: params.password);

    // 2. Orchestration: If login successful, fetch the complete user profile immediately.
    return loginResult.fold((failure) => Left(failure), (response) async {
      final userId = response?.userId ?? "";
      if (userId.isEmpty) {
        return const Left(ServerFailure('User ID is missing in response'));
      }
      // Chain the next operation to get full user data
      return await repository.getCurrentUser(userId: userId);
    });
  }
}

/// Parameters for login use case
class LoginParams {
  final String username;
  final String password;

  LoginParams({required this.username, required this.password});
}
