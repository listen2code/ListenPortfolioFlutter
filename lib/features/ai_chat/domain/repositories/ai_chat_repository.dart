import 'package:listen_core/core.dart';
import '../../data/models/ai_preset_qa_response_model.dart';

// ignore: one_member_abstracts
abstract class AiChatRepository {
  Future<Either<Failure, AiPresetQaResponseModel?>> getPresetQAs({String? route});
}
