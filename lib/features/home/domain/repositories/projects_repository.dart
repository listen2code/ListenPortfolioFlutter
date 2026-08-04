// ignore_for_file: one_member_abstracts
import 'package:listen_core/core.dart';
import '../../data/models/project_model.dart';

abstract class ProjectsRepository {
  Future<Either<Failure, List<ProjectModel>>> getProjects();
}
