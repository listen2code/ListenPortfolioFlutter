import 'package:listen_core/core.dart';

import '../../domain/repositories/about_me_repository.dart';
import '../datasources/about_me_local_data_source.dart';
import '../datasources/about_me_remote_data_source.dart';
import '../datasources/resume_local_data_source.dart';
import '../datasources/resume_remote_data_source.dart';
import '../models/about_me_model.dart';

/// ============================================================================
/// AboutMeRepositoryImpl
/// ============================================================================
/// Concrete data repository implementation for the AboutMe and Resume domain features,
/// implementing [AboutMeRepository] and mixing in [BaseRepository] from `ListenCore`.
///
/// ### Clean Architecture & Resiliency Pattern:
/// - **Multi-Resource Orchestration**: Manages both profile metadata ([AboutMeModel])
///   and raw Markdown resume documents ([String]), each backed by dedicated remote
///   and local cache data sources.
/// - **Zero-Latency Offline-First via [safeCall]**:
///   Both [getAboutMe] and [getResumeMarkdown] utilize the `safeCall` pipeline,
///   enabling zero-latency offline loading when disconnected, automatic write-behind
///   caching on network success, and defensive error demarcation.
/// - **Non-JSON String Adapter Pattern**:
///   In [getResumeMarkdown], raw string responses from GitHub/CDN are wrapped into a synthetic
///   `BaseResponseModel<String>` so they seamlessly integrate with the standardized `safeCall`
///   caching lifecycle without modifying the underlying network contract.
class AboutMeRepositoryImpl with BaseRepository implements AboutMeRepository {
  /// Remote data source for fetching structured biography/profile JSON.
  final AboutMeRemoteDataSource remoteDataSource;

  /// Local persistence data source for profile metadata conforming to [CacheDataSource<AboutMeModel>].
  final AboutMeLocalDataSource localDataSource;

  /// Optional remote data source for fetching raw Markdown resume files.
  final ResumeRemoteDataSource? resumeRemoteDataSource;

  /// Optional local persistence data source for raw Markdown resume text.
  final ResumeLocalDataSource? resumeLocalDataSource;

  AboutMeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    this.resumeRemoteDataSource,
    this.resumeLocalDataSource,
  });

  /// Fetches author profile details with automated offline caching and fallback.
  @override
  Future<Either<Failure, AboutMeModel>> getAboutMe() async {
    return await safeCall<AboutMeModel>(
      call: () => remoteDataSource.getAboutMe(),
      cacheDataSource: localDataSource,
    );
  }

  /// Fetches the raw Markdown resume content with automated offline caching and fallback.
  ///
  /// Wraps the plain-text HTTP response into a [BaseResponseModel<String>] to reuse
  /// the unified [safeCall] error handling and caching pipeline.
  @override
  Future<Either<Failure, String>> getResumeMarkdown() async {
    if (resumeRemoteDataSource == null || resumeLocalDataSource == null) {
      return const Left(ServerFailure('Resume data sources not provided'));
    }
    return await safeCall<String>(
      call: () async {
        final result = await resumeRemoteDataSource!.getResumeMarkdown();
        return BaseResponseModel<String>(
          result: ApiResult.success,
          body: result,
        );
      },
      cacheDataSource: resumeLocalDataSource,
    );
  }
}
