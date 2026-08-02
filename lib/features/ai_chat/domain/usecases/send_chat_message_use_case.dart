import 'package:listen_core/core.dart';
import '../../data/models/ai_chat_request_model.dart';
import '../../data/models/ai_chat_response_model.dart';
import '../repositories/ai_chat_repository.dart';

class SendChatMessageUseCase implements UseCase<AiChatResponseModel?, AiChatRequestModel> {
  final AiChatRepository repository;

  SendChatMessageUseCase(this.repository);

  @override
  Future<Either<Failure, AiChatResponseModel?>> call({AiChatRequestModel? param}) async {
    return await repository.sendChatMessage(param: param);
  }
}
