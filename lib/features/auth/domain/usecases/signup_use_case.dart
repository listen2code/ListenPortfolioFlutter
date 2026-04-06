import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import '../../data/models/signup_request_model.dart';
import '../repositories/auth_repository.dart';

/// Use case for user registration.
/// Focuses on orchestrating the signup process through the repository.
class SignupUseCase implements UseCase<void, SignupRequestModel> {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call({SignupRequestModel? param}) async {
    // Basic validations are handled at Level 1 (ViewModel).
    // This UseCase handles the execution of the signup domain logic.
    return await repository.signUp(param: param);
  }
}
