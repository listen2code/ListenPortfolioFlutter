import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import '../../data/models/change_password_request_model.dart';
import '../repositories/auth_repository.dart';

/// Use case for updating the user password
class ChangePasswordUseCase implements UseCase<void, ChangePasswordRequestModel> {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call({ChangePasswordRequestModel? param}) async {
    // Level 2 Validation: Business logic validation
    if (param?.newPassword == param?.oldPassword) {
      return const Left(ValidationFailure('New password cannot be the same as the old one'));
    }

    return await repository.changePassword(param: param);
  }
}
