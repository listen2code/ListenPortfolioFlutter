import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import '../../data/models/version_model.dart';

abstract class SettingsRepository {
  Future<Either<Failure, VersionModel>> getLatestVersion();
}
