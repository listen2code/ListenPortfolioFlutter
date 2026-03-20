import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/get_current_user_request_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_response_model.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Use case for getting current logged in user
class GetCurrentUserUseCase implements UseCase<UserResponseModel?, GetCurrentUserRequestModel> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserResponseModel?>> call({GetCurrentUserRequestModel? param}) async {
    return await repository.getCurrentUser(param: param);
  }
}
