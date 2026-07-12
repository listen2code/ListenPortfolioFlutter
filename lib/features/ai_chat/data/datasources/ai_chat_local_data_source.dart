import 'dart:convert';
import 'package:listen_core/core.dart';
import '../models/ai_preset_qa_response_model.dart';

class AiChatLocalDataSource {
  AiChatLocalDataSource();

  static const String _presetQAsKey = 'preset_qas_cache';

  Future<void> cachePresetQAs(AiPresetQaResponseModel? model) async {
    appLogger.d('AiChatLocalDataSource: Starting to cache preset QAs');
    try {
      if (model != null) {
        final jsonStr = json.encode(model.toJson());
        await SpUtil.put(_presetQAsKey, jsonStr);
        appLogger.d('AiChatLocalDataSource: Preset QAs cached successfully');
      }
    } catch (e) {
      appLogger.e('AiChatLocalDataSource: Failed to cache preset QAs: $e');
    }
  }

  Future<AiPresetQaResponseModel?> getCachedPresetQAs() async {
    appLogger.d('AiChatLocalDataSource: Fetching preset QAs from cache');
    try {
      final jsonStr = SpUtil.getString(_presetQAsKey);
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
