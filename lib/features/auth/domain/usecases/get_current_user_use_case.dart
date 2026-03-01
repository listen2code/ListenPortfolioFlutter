import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Use case for getting current logged in user
class GetCurrentUserUseCase implements UseCase<UserModel?, GetUserParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel?>> call(GetUserParams params) async {
    return await repository.getCurrentUser(userId: params.userId);
  }
}

/// Parameters for login use case
class GetUserParams {
  final String userId;

  GetUserParams({required this.userId});
}
