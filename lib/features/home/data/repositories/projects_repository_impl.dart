import 'package:listen_core/core.dart';
import '../datasources/projects_local_data_source.dart';
import '../datasources/projects_remote_data_source.dart';
import '../models/project_model.dart';
import '../../domain/repositories/projects_repository.dart';

class ProjectsRepositoryImpl with BaseRepository implements ProjectsRepository {
  final ProjectsRemoteDataSource remoteDataSource;
  final ProjectsLocalDataSource localDataSource;

  ProjectsRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, List<ProjectModel>>> getProjects() async {
    return await safeCall<List<ProjectModel>>(
      call: () => remoteDataSource.getProjects(),
      cacheDataSource: localDataSource,
    );
  }
}
