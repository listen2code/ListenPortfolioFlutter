import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/projects_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/projects_remote_data_source.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';
import 'package:listen_portfolio_flutter/features/home/domain/repositories/projects_repository.dart';

class ProjectsRepositoryImpl with BaseRepository implements ProjectsRepository {
  final ProjectsRemoteDataSource remoteDataSource;
  final ProjectsLocalDataSource localDataSource;

  ProjectsRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, List<ProjectModel>>> getProjects() async {
    final result = await safeCall<List<ProjectModel>>(call: () => remoteDataSource.getProjects());

    return result.fold(
      (failure) async {
        // If network fails, try to get from local cache
        final cached = await localDataSource.getCachedProjects();
        if (cached != null && failure is! ServerFailure) {
          return Right(cached);
        }
        return Left(failure);
      },
      (projects) async {
        // Cache data on success
        await localDataSource.cacheProjects(projects);
        return Right(projects);
      },
    );
  }
}
