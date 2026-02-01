import 'package:fpdart/fpdart.dart';

import '../../../../core/base/use_case.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Use case for changing user password
class ChangePasswordUseCase implements UseCase<void, ChangePasswordParams> {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    // Business logic validation
    if (params.oldPassword.isEmpty) {
      return const Left(ValidationFailure('Current password cannot be empty'));
    }
    if (params.newPassword.isEmpty) {
      return const Left(ValidationFailure('New password cannot be empty'));
    }
    if (params.newPassword.length < 6) {
      return const Left(ValidationFailure('New password must be at least 6 characters'));
    }
    if (params.oldPassword == params.newPassword) {
      return const Left(ValidationFailure('New password must be different from current password'));
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
