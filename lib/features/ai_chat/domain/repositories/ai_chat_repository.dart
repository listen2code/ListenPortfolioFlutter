import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import '../../data/models/ai_chat_request_model.dart';
import '../../data/models/ai_chat_response_model.dart';
import '../../data/models/ai_preset_qa_response_model.dart';

abstract class AiChatRepository {
  Future<Either<Failure, AiChatResponseModel?>> sendChatMessage({
    required AiChatRequestModel? param,
  });

  Future<Either<Failure, AiPresetQaResponseModel?>> getPresetQAs({String? route});
}
