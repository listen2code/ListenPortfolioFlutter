import 'package:listen_core/core.dart';
import '../../data/models/project_model.dart';
import '../repositories/projects_repository.dart';

class GetProjectsUseCase implements UseCase<List<ProjectModel>, BaseParam> {
  final ProjectsRepository repository;

  GetProjectsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProjectModel>>> call({BaseParam? param}) async {
    return await repository.getProjects();
  }
}
