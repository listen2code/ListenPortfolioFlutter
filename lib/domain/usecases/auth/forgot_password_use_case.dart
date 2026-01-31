import 'package:fpdart/fpdart.dart';

import '../../../core/base/use_case.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';

/// Use case for password reset
class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    // Business logic validation
    if (params.email.isEmpty) {
      return const Left(ValidationFailure('Email cannot be empty'));
    }
    if (!params.email.contains('@')) {
      return const Left(ValidationFailure('Invalid email format'));
    }

    return await repository.forgotPassword(email: params.email);
  }
}

/// Parameters for forgot password use case
class ForgotPasswordParams {
  final String email;

  ForgotPasswordParams({required this.email});
}
