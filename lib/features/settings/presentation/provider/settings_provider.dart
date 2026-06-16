import 'package:listen_core/core.dart';
import '../../data/datasources/settings_remote_data_source.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/check_updates_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
SettingsRemoteDataSource settingsRemoteDataSource(Ref ref) {
  return SettingsRemoteDataSource(ApiClient.dio);
}

@riverpod
SettingsRepository settingsRepository(Ref ref) {
  final remoteDataSource = ref.watch(settingsRemoteDataSourceProvider);
  return SettingsRepositoryImpl(remoteDataSource: remoteDataSource);
}

@riverpod
Future<CheckUpdatesUseCase> checkUpdatesUseCase(Ref ref) async {
  final repository = ref.watch(settingsRepositoryProvider);
  return CheckUpdatesUseCase(repository);
}
