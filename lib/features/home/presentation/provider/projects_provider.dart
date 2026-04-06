import 'package:listen_core/core.dart';
import '../../data/datasources/projects_local_data_source.dart';
import '../../data/datasources/projects_remote_data_source.dart';
import '../../data/repositories/projects_repository_impl.dart';
import '../../domain/repositories/projects_repository.dart';
import '../../domain/usecases/get_projects_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'projects_provider.g.dart';

@riverpod
ProjectsRemoteDataSource projectsRemoteDataSource(Ref ref) {
  return ProjectsRemoteDataSource(ApiClient.dio, baseUrl: AppEnv.apiBaseUrl);
}

@riverpod
ProjectsLocalDataSource projectsLocalDataSource(Ref ref) {
  return ProjectsLocalDataSource();
}

@riverpod
ProjectsRepository projectsRepository(Ref ref) {
  final remoteDataSource = ref.watch(projectsRemoteDataSourceProvider);
  final localDataSource = ref.watch(projectsLocalDataSourceProvider);

  return ProjectsRepositoryImpl(remoteDataSource: remoteDataSource, localDataSource: localDataSource);
}

/// Define as Future to support ref.execute extension
@riverpod
Future<GetProjectsUseCase> getProjectsUseCase(Ref ref) async {
  final repository = ref.watch(projectsRepositoryProvider);
  return GetProjectsUseCase(repository);
}
