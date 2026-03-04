import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user registration.
/// Focuses on orchestrating the signup process through the repository.
class SignupUseCase implements UseCase<void, SignupParams> {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SignupParams params) async {
    // Basic validations are handled at Level 1 (ViewModel).
    // This UseCase handles the execution of the signup domain logic.
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
