import 'package:listen_core/core.dart';
import '../../data/models/get_current_user_request_model.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting current logged in user
class GetCurrentUserUseCase implements UseCase<UserModel?, GetCurrentUserRequestModel> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel?>> call({GetCurrentUserRequestModel? param}) async {
    return await repository.getCurrentUser(param: param);
  }
}
