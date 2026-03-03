import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user registration
class SignupUseCase implements UseCase<void, SignupParams> {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SignupParams params) async {
    // Business logic validation
    if (params.name.isEmpty) {
      return const Left(ValidationFailure('Name cannot be empty'));
    }
    if (params.email.isEmpty) {
      return const Left(ValidationFailure('Email cannot be empty'));
    }
    if (!params.email.contains('@')) {
      return const Left(ValidationFailure('Invalid email format'));
    }
    if (params.password.length < 6) {
      return const Left(ValidationFailure('Password must be at least 6 characters'));
    }

    return await repository.signUp(name: params.name, email: params.email, password: params.password);
  }
}

/// Parameters for signup use case
class SignupParams {
  final String name;
  final String email;
  final String password;

  SignupParams({required this.name, required this.email, required this.password});
}
