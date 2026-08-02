import 'package:listen_core/core.dart';
import '../../data/models/ai_preset_qa_response_model.dart';
import '../repositories/ai_chat_repository.dart';

class GetPresetQaUseCase implements UseCase<AiPresetQaResponseModel?, String> {
  final AiChatRepository repository;

  GetPresetQaUseCase(this.repository);

  @override
  Future<Either<Failure, AiPresetQaResponseModel?>> call({String? param}) async {
    return await repository.getPresetQAs(route: param);
  }
}
