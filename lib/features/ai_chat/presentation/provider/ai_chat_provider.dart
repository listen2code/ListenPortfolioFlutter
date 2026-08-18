import 'package:listen_core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/shared.dart';
import '../../data/datasources/ai_chat_remote_data_source.dart';
import '../../data/datasources/ai_chat_local_data_source.dart';
import '../../data/repositories/ai_chat_repository_impl.dart';
import '../../domain/repositories/ai_chat_repository.dart';
import '../../domain/usecases/get_preset_qa_use_case.dart';
import '../../domain/usecases/send_chat_message_use_case.dart';

part 'ai_chat_provider.g.dart';

// ============================================================================
// Data Source Providers
// ============================================================================

@riverpod
FirebaseAiService firebaseAiService(Ref ref) {
  return FirebaseAiService()..initialize();
}

@riverpod
AiChatRemoteDataSource aiChatRemoteDataSource(Ref ref) {
  return AiChatRemoteDataSource(ApiClient.dio, baseUrl: AppEnv.apiBaseUrl);
}

@riverpod
AiChatLocalDataSource aiChatLocalDataSource(Ref ref) {
  return AiChatLocalDataSource();
}

// ============================================================================
// Repository Providers
// ============================================================================

@riverpod
Future<AiChatRepository> aiChatRepository(Ref ref) async {
  final remoteDataSource = ref.watch(aiChatRemoteDataSourceProvider);
  final localDataSource = ref.watch(aiChatLocalDataSourceProvider);
  return AiChatRepositoryImpl(remoteDataSource: remoteDataSource, localDataSource: localDataSource);
}

// ============================================================================
// Use Case Providers
// ============================================================================

@riverpod
Future<SendChatMessageUseCase> sendChatMessageUseCase(Ref ref) async {
  final repository = await ref.watch(aiChatRepositoryProvider.future);
  return SendChatMessageUseCase(repository);
}

@riverpod
Future<GetPresetQaUseCase> getPresetQaUseCase(Ref ref) async {
  final repository = await ref.watch(aiChatRepositoryProvider.future);
  return GetPresetQaUseCase(repository);
}
