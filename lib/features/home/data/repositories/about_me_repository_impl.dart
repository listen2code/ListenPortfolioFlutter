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
      cacheDataSource: localDataSource,
    );
  }

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
