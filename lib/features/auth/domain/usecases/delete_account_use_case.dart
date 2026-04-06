import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import '../../data/models/delete_account_request_model.dart';
import '../repositories/auth_repository.dart';

class DeleteAccountUseCase implements UseCase<void, DeleteAccountRequestModel> {
  final AuthRepository repository;

  DeleteAccountUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call({DeleteAccountRequestModel? param}) async {
    return await repository.deleteAccount(param: param);
  }
}
