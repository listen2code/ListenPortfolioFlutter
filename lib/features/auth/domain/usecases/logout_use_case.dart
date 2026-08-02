import 'package:listen_core/core.dart';
import '../repositories/auth_repository.dart';

/// Use case for user logout
class LogoutUseCase implements UseCase<void, BaseParam> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call({BaseParam? param}) async {
    return await repository.logout();
  }
}
