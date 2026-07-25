import 'dart:convert';


import '../../../../shared/shared.dart';
import '../models/ai_preset_qa_response_model.dart';

class AiChatLocalDataSource implements CacheDataSource<AiPresetQaResponseModel> {
  AiChatLocalDataSource();

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
