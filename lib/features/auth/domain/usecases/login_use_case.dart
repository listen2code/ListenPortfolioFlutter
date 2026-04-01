import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/get_current_user_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user login flow.
/// It orchestrates the authentication and fetching the current user profile.
class LoginUseCase implements UseCase<UserModel?, LoginRequestModel> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel?>> call({LoginRequestModel? param}) async {
    // 1. Perform Login (Authentication)
    final loginResult = await repository.login(param: param);

    // 2. Orchestration: If login successful, fetch the complete user profile immediately.
    return loginResult.fold((failure) => Left(failure), (response) async {
      final userId = response?.userId ?? "";
      if (userId.isEmpty) {
        return const Left(ServerFailure('User ID is missing in response'));
      }
      // Chain the next operation to get full user data
      return await repository.getCurrentUser(param: GetCurrentUserRequestModel(userId: userId));
    });
  }
}
