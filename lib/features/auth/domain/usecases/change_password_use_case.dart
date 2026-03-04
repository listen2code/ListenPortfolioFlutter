import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Use case for updating the user password
class ChangePasswordUseCase implements UseCase<void, ChangePasswordParams> {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    // Level 2 Validation: Business logic validation
    if (params.newPassword == params.oldPassword) {
      return const Left(ValidationFailure('New password cannot be the same as the old one'));
    }

    return await repository.changePassword(oldPassword: params.oldPassword, newPassword: params.newPassword);
  }
}

/// Parameters for change password use case
class ChangePasswordParams {
  final String oldPassword;
  final String newPassword;

  ChangePasswordParams({required this.oldPassword, required this.newPassword});
}
