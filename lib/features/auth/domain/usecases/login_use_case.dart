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
    // 1. Business logic validation
    if (params.username.isEmpty) {
      return const Left(ValidationFailure('Username cannot be empty'));
    }
    if (params.password.length < 6) {
      return const Left(ValidationFailure('Password must be at least 6 characters'));
    }

    // 2. Perform Login (Authentication)
    final loginResult = await repository.login(username: params.username, password: params.password);

    // 3. If login successful, fetch the complete user profile immediately.
    // We use fold or flatMap to chain the next operation.
    return loginResult.fold(
      (failure) => Left(failure), // If authentication fails, return failure
      (response) async {
        // If authentication succeeds, get the full user data
        return await repository.getCurrentUser(userId: response?.userId ?? "");
      },
    );
  }
}

/// Parameters for login use case
class LoginParams {
  final String username;
  final String password;

  LoginParams({required this.username, required this.password});
}
