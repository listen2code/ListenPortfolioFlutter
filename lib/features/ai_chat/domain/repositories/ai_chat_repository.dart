import 'package:listen_core/core.dart';
import '../../data/models/ai_preset_qa_response_model.dart';

/// ============================================================================
/// AiChatRepository
/// ============================================================================
/// Domain contract defining data fetching operations for AI Preset Q&A items.
///
/// Follows Clean Architecture by exposing abstract domain operations independent
/// of concrete data source implementations (remote HTTP vs local disk cache).
// ignore: one_member_abstracts
abstract class AiChatRepository {
  /// Retrieves the preset Q&A catalog, optionally filtered by the active [route].
  ///
  /// Returns [Either] containing [Failure] on error, or the resolved [AiPresetQaResponseModel].
  Future<Either<Failure, AiPresetQaResponseModel?>> getPresetQAs({String? route});
}

