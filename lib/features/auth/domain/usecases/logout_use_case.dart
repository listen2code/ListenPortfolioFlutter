import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/errors/failures.dart';
import 'package:listen_portfolio_flutter/core/network/base_use_case.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user logout
class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
