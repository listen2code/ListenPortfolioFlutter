import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import '../datasources/settings_remote_data_source.dart';
import '../models/version_model.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl with BaseRepository implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;

  SettingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, VersionModel>> getLatestVersion() async {
    return await safeCall<VersionModel>(
      call: () async {
        final versionModel = await remoteDataSource.getLatestVersion();
        return BaseResponseModel<VersionModel>(
          result: ApiResult.success,
          body: versionModel,
        );
      },
    );
  }
}
