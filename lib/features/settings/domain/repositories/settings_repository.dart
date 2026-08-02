import 'package:listen_core/core.dart';
import '../../data/models/version_model.dart';

// ignore: one_member_abstracts
abstract class SettingsRepository {
  Future<Either<Failure, VersionModel>> getLatestVersion();
}
