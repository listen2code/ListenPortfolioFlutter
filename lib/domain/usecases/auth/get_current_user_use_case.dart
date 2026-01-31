import 'package:dartz/dartz.dart';
import '../../../core/base/use_case.dart';
import '../../../core/errors/failures.dart';
import '../../entities/auth/user.dart';
import '../../repositories/auth_repository.dart';

/// Use case for getting current logged in user
class GetCurrentUserUseCase implements UseCase<User?, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
