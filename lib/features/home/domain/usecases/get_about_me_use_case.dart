import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/features/home/domain/repositories/about_me_repository.dart';

class GetAboutMeUseCase implements UseCase<AboutMeModel, BaseParam> {
  final AboutMeRepository repository;

  GetAboutMeUseCase(this.repository);

  @override
  Future<Either<Failure, AboutMeModel>> call({BaseParam? param}) async {
    return await repository.getAboutMe();
  }
}
