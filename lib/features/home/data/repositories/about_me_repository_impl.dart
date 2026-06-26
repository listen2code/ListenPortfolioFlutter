import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';

import '../../domain/repositories/about_me_repository.dart';
import '../datasources/about_me_local_data_source.dart';
import '../datasources/about_me_remote_data_source.dart';
import '../datasources/resume_local_data_source.dart';
import '../datasources/resume_remote_data_source.dart';
import '../models/about_me_model.dart';

class AboutMeRepositoryImpl with BaseRepository implements AboutMeRepository {
  final AboutMeRemoteDataSource remoteDataSource;
  final AboutMeLocalDataSource localDataSource;
  final ResumeRemoteDataSource? resumeRemoteDataSource;
  final ResumeLocalDataSource? resumeLocalDataSource;

  AboutMeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    this.resumeRemoteDataSource,
    this.resumeLocalDataSource,
  });

  @override
  Future<Either<Failure, AboutMeModel>> getAboutMe() async {
    return await safeCall<AboutMeModel>(
      call: () => remoteDataSource.getAboutMe(),
      saveCache: (data) => localDataSource.cacheAboutMe(data),
      getCached: () => localDataSource.getCachedAboutMe(),
    );
  }

  @override
  Future<Either<Failure, String>> getResumeMarkdown() async {
    if (resumeRemoteDataSource == null || resumeLocalDataSource == null) {
      return Left(ServerFailure('Resume data sources not provided'));
    }
    try {
      final result = await resumeRemoteDataSource!.getResumeMarkdown();
      await resumeLocalDataSource!.cacheResume(result);
      return Right(result);
    } catch (e, stackTrace) {
      appLogger.e(
        'Failed to fetch resume markdown, attempting to load from cache',
        error: e,
        stackTrace: stackTrace,
      );
      try {
        final cached = await resumeLocalDataSource!.getCachedResume();
        if (cached != null && cached.isNotEmpty) {
          return Right(cached);
        }
      } catch (cacheError) {
        appLogger.e('Failed to load cached resume', error: cacheError);
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
