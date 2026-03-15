import 'package:fpdart/fpdart.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/about_me_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/about_me_remote_data_source.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/features/home/domain/repositories/about_me_repository.dart';

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
