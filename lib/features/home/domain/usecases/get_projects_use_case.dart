import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';
import 'package:listen_portfolio_flutter/features/home/domain/repositories/projects_repository.dart';

class GetProjectsUseCase implements UseCase<List<ProjectModel>, BaseParam> {
  final ProjectsRepository repository;

  GetProjectsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProjectModel>>> call({BaseParam? param}) async {
    return await repository.getProjects();
  }
}
