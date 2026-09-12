import 'dart:convert';

import '../../../../shared/shared.dart';
import '../models/ai_preset_qa_response_model.dart';

/// ============================================================================
/// AiChatLocalDataSource
/// ============================================================================
/// Local cache data source for AI Preset Q&A items conforming to [CacheDataSource].
///
/// ### Architecture & UX Rationale:
/// - **Offline-First & Instant Startup**:
///   Persists the serialized JSON representation of [AiPresetQaResponseModel]
///   into persistent storage via [SpUtil] (backed by SharedPreferences).
/// - **Network Fallback & Resilience**:
///   When the device is offline or the remote API is temporarily unavailable,
///   cached Q&A data is immediately returned to ensure zero-latency question
///   chips and uninterrupted Tier-1 fuzzy question matching.
class AiChatLocalDataSource implements CacheDataSource<AiPresetQaResponseModel> {
  AiChatLocalDataSource();

  /// Persists the given [model] into shared preferences as a JSON string.
  @override
  Future<void> cache(AiPresetQaResponseModel model) async {
    appLogger.d('AiChatLocalDataSource: Starting to cache preset QAs');
    try {
      final jsonStr = json.encode(model.toJson());
      await SpUtil.put(AppConstants.presetQAsKey, jsonStr);
      appLogger.d('AiChatLocalDataSource: Preset QAs cached successfully');
    } catch (e) {
      appLogger.e('AiChatLocalDataSource: Failed to cache preset QAs: $e');
    }
  }

  /// Retrieves and deserializes the cached [AiPresetQaResponseModel] from shared preferences.
  ///
  /// Returns `null` if no cache entry exists or if deserialization fails.
  @override
  Future<AiPresetQaResponseModel?> getCached() async {
    appLogger.d('AiChatLocalDataSource: Fetching preset QAs from cache');
    try {
      final jsonStr = SpUtil.getString(AppConstants.presetQAsKey);
      if (jsonStr != null) {
        final Map<String, dynamic> decoded = json.decode(jsonStr) as Map<String, dynamic>;
        final model = AiPresetQaResponseModel.fromJson(decoded);
        appLogger.d('AiChatLocalDataSource: Preset QAs retrieved from cache successfully');
        return model;
      }
      appLogger.d('AiChatLocalDataSource: No cached preset QAs found');
    } catch (e) {
      appLogger.e('AiChatLocalDataSource: Failed to get cached preset QAs: $e');
    }
    return null;
  }
}

