import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import '../../data/models/about_me_model.dart';
import '../repositories/about_me_repository.dart';

class GetAboutMeUseCase implements UseCase<AboutMeModel, BaseParam> {
  final AboutMeRepository repository;

  GetAboutMeUseCase(this.repository);

  @override
  Future<Either<Failure, AboutMeModel>> call({BaseParam? param}) async {
    return await repository.getAboutMe();
  }
}
