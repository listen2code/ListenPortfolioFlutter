import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user login
/// Encapsulates business logic for authentication
class LoginUseCase implements UseCase<UserModel?, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel?>> call(LoginParams params) async {
    // Business logic validation
    if (params.username.isEmpty) {
      return Left(ValidationFailure('Username cannot be empty'));
    }
    if (params.password.length < 6) {
      return Left(ValidationFailure('Password must be at least 6 characters'));
    }

    return await repository.login(username: params.username, password: params.password);
  }
}

/// Parameters for login use case
class LoginParams {
  final String username;
  final String password;

  LoginParams({required this.username, required this.password});
}
