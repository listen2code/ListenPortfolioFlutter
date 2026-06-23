import 'package:dio/dio.dart';
import 'package:listen_core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/about_me_local_data_source.dart';
import '../../data/datasources/about_me_remote_data_source.dart';
import '../../data/datasources/resume_local_data_source.dart';
import '../../data/datasources/resume_remote_data_source.dart';
import '../../data/repositories/about_me_repository_impl.dart';
import '../../domain/repositories/about_me_repository.dart';
import '../../domain/usecases/get_about_me_use_case.dart';
import '../../domain/usecases/get_resume_use_case.dart';

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
ResumeRemoteDataSource resumeRemoteDataSource(Ref ref) {
  return ResumeRemoteDataSource(Dio());
}

@riverpod
ResumeLocalDataSource resumeLocalDataSource(Ref ref) {
  return ResumeLocalDataSource();
}

@riverpod
AboutMeRepository aboutMeRepository(Ref ref) {
  final remoteDataSource = ref.watch(aboutMeRemoteDataSourceProvider);
  final localDataSource = ref.watch(aboutMeLocalDataSourceProvider);
  final resumeDataSource = ref.watch(resumeRemoteDataSourceProvider);
  final resumeLocalDataSource = ref.watch(resumeLocalDataSourceProvider);
  return AboutMeRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    resumeRemoteDataSource: resumeDataSource,
    resumeLocalDataSource: resumeLocalDataSource,
  );
}

@riverpod
Future<GetAboutMeUseCase> getAboutMeUseCase(Ref ref) async {
  final repository = ref.watch(aboutMeRepositoryProvider);
  return GetAboutMeUseCase(repository);
}

@riverpod
Future<GetResumeUseCase> getResumeUseCase(Ref ref) async {
  final repository = ref.watch(aboutMeRepositoryProvider);
  return GetResumeUseCase(repository);
}
