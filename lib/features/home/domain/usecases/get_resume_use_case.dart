import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import '../repositories/about_me_repository.dart';

class GetResumeUseCase implements UseCase<String, BaseParam> {
  final AboutMeRepository repository;

  GetResumeUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call({BaseParam? param}) async {
    return await repository.getResumeMarkdown();
  }
}
