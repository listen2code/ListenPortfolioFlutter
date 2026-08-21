import 'package:listen_core/core.dart';
import '../datasources/ai_chat_remote_data_source.dart';
import '../datasources/ai_chat_local_data_source.dart';
import '../models/ai_preset_qa_response_model.dart';
import '../../domain/repositories/ai_chat_repository.dart';

class AiChatRepositoryImpl with BaseRepository implements AiChatRepository {
  final AiChatRemoteDataSource remoteDataSource;
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
