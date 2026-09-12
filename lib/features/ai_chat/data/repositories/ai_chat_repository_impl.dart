import 'package:listen_core/core.dart';
import '../datasources/ai_chat_remote_data_source.dart';
import '../datasources/ai_chat_local_data_source.dart';
import '../models/ai_preset_qa_response_model.dart';
import '../../domain/repositories/ai_chat_repository.dart';

/// ============================================================================
/// AiChatRepositoryImpl
/// ============================================================================
/// Concrete implementation of [AiChatRepository] utilizing [BaseRepository.safeCall].
///
/// ### Architecture & Resiliency Pattern:
/// - Combines [AiChatRemoteDataSource] and [AiChatLocalDataSource] through
///   the `safeCall` orchestration template method.
/// - Attempts remote network retrieval first; on success, automatically writes
///   to the local cache. If network requests fail (e.g. offline, timeout, server 5xx),
///   it falls back seamlessly to the cached local data, returning an [Either] monad.
class AiChatRepositoryImpl with BaseRepository implements AiChatRepository {
  /// Remote HTTP Retrofit data source
  final AiChatRemoteDataSource remoteDataSource;

  /// Local SharedPreferences cache data source
  final AiChatLocalDataSource localDataSource;

  AiChatRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, AiPresetQaResponseModel?>> getPresetQAs({String? route}) async {
    return await safeCall<AiPresetQaResponseModel>(
      call: () => remoteDataSource.getPresetQAs(route),
      cacheDataSource: localDataSource,
    );
  }
}

