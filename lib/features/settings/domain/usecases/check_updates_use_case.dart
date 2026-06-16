import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import '../../data/models/version_model.dart';
import '../repositories/settings_repository.dart';

class CheckUpdatesUseCase implements UseCase<VersionModel, BaseParam> {
  final SettingsRepository repository;

  CheckUpdatesUseCase(this.repository);

  @override
  Future<Either<Failure, VersionModel>> call({BaseParam? param}) async {
    return await repository.getLatestVersion();
  }
}
