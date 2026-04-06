import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import '../datasources/about_me_local_data_source.dart';
import '../datasources/about_me_remote_data_source.dart';
import '../models/about_me_model.dart';
import '../../domain/repositories/about_me_repository.dart';

class AboutMeRepositoryImpl with BaseRepository implements AboutMeRepository {
  final AboutMeRemoteDataSource remoteDataSource;
  final AboutMeLocalDataSource localDataSource;

  AboutMeRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, AboutMeModel>> getAboutMe() async {
    return await safeCall<AboutMeModel>(
      call: () => remoteDataSource.getAboutMe(),
      saveCache: (data) => localDataSource.cacheAboutMe(data),
      getCached: () => localDataSource.getCachedAboutMe(),
    );
  }
}
