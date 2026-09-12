import 'package:listen_core/core.dart';
import '../datasources/projects_local_data_source.dart';
import '../datasources/projects_remote_data_source.dart';
import '../models/project_model.dart';
import '../../domain/repositories/projects_repository.dart';

/// ============================================================================
/// ProjectsRepositoryImpl
/// ============================================================================
/// Concrete data repository implementation for the Projects domain feature,
/// implementing [ProjectsRepository] and mixing in [BaseRepository] from `ListenCore`.
///
/// ### Clean Architecture & Resiliency Pattern:
/// - **Orchestration Template via [safeCall]**:
///   Coordinates the remote HTTP client ([ProjectsRemoteDataSource]) and local
///   persistence ([ProjectsLocalDataSource]) within a single declared pipeline.
/// - **Offline-First Lifecycle**:
///   1. If the device has no internet connection, [safeCall] immediately queries
///      [localDataSource.getCached] to return the cached project list with zero network delay.
///   2. If connected, it invokes [remoteDataSource.getProjects].
///   3. On remote success, it automatically calls [localDataSource.cache] in a write-behind fashion.
///   4. On remote network/timeout failure, it falls back to cached data if present.
///   5. On critical HTTP 500 server crashes or schema mismatch (`TypeError`), fallback is intentionally
///      inhibited to prevent masking server-side defects.
class ProjectsRepositoryImpl with BaseRepository implements ProjectsRepository {
  /// Remote data source responsible for HTTP REST requests to the backend.
  final ProjectsRemoteDataSource remoteDataSource;

  /// Local data source conforming to [CacheDataSource<List<ProjectModel>>] for offline resilience.
  final ProjectsLocalDataSource localDataSource;

  ProjectsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// Fetches the list of showcase projects with automated offline fallback and caching.
  ///
  /// Returns a [Right] containing `List<ProjectModel>` on remote success or offline cache hit.
  /// Returns a [Left] containing a domain [Failure] (e.g., [NetworkFailure], [ServerFailure])
  /// when both remote and local paths fail or when a critical server error occurs.
  @override
  Future<Either<Failure, List<ProjectModel>>> getProjects() async {
    return await safeCall<List<ProjectModel>>(
      call: () => remoteDataSource.getProjects(),
      cacheDataSource: localDataSource,
    );
  }
}
