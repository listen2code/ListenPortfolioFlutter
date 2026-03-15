import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/about_me_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/home/data/datasources/about_me_remote_data_source.dart';
import 'package:listen_portfolio_flutter/features/home/data/repositories/about_me_repository_impl.dart';
import 'package:listen_portfolio_flutter/features/home/domain/repositories/about_me_repository.dart';
import 'package:listen_portfolio_flutter/features/home/domain/usecases/get_about_me_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'about_me_provider.g.dart';

@riverpod
AboutMeRemoteDataSource aboutMeRemoteDataSource(Ref ref) {
  return AboutMeRemoteDataSource(ApiClient.dio, baseUrl: AppEnv.apiBaseUrl);
}

@riverpod
AboutMeLocalDataSource aboutMeLocalDataSource(Ref ref) {
  return AboutMeLocalDataSource();
}

@riverpod
AboutMeRepository aboutMeRepository(Ref ref) {
  final remoteDataSource = ref.watch(aboutMeRemoteDataSourceProvider);
  final localDataSource = ref.watch(aboutMeLocalDataSourceProvider);
  return AboutMeRepositoryImpl(remoteDataSource: remoteDataSource, localDataSource: localDataSource);
}

@riverpod
Future<GetAboutMeUseCase> getAboutMeUseCase(Ref ref) async {
  final repository = ref.watch(aboutMeRepositoryProvider);
  return GetAboutMeUseCase(repository);
}
