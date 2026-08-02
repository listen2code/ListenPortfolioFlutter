import 'package:listen_core/core.dart';
import '../../data/models/project_model.dart';

abstract class ProjectsRepository {
  Future<Either<Failure, List<ProjectModel>>> getProjects();
}
