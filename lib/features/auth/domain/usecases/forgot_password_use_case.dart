import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/forgot_password_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Use case for password reset.
/// Orchestrates the forgot password flow through the repository.
class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordRequestModel> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call({ForgotPasswordRequestModel? param}) async {
    // Basic validations are handled at Level 1 (ViewModel).
    // This UseCase handles the domain logic execution.
    return await repository.forgotPassword(param: param);
  }
}
