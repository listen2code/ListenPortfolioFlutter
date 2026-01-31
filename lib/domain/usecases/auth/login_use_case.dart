import 'package:dartz/dartz.dart';
import '../../../core/base/use_case.dart';
import '../../../core/errors/failures.dart';
import '../../entities/auth/user.dart';
import '../../repositories/auth_repository.dart';

/// Use case for user login
/// Encapsulates business logic for authentication
class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    // Business logic validation
    if (params.username.isEmpty) {
      return const Left(ValidationFailure('Username cannot be empty'));
    }
    if (params.password.length < 6) {
      return const Left(ValidationFailure('Password must be at least 6 characters'));
    }

    return await repository.login(
      username: params.username,
      password: params.password,
    );
  }
}

/// Parameters for login use case
class LoginParams {
  final String username;
  final String password;

  LoginParams({
    required this.username,
    required this.password,
  });
}
