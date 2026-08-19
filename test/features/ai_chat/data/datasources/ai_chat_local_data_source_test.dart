import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/datasources/ai_chat_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_preset_qa_response_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AiChatLocalDataSource Tests', () {
    late AiChatLocalDataSource dataSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SpUtil.init(prefix: 'test_');
      dataSource = AiChatLocalDataSource();
    });

    final mockModel = AiPresetQaResponseModel(
      qas: {
        'global': [
          const PresetQaItem(
            question: 'What tech stack is used?',
            answer: 'Flutter & Riverpod',
          ),
        ],
      },
    );

    test('getCached returns null when cache is empty', () async {
      final result = await dataSource.getCached();
      expect(result, isNull);
    });

    test('cache stores data in SpUtil and getCached retrieves it correctly', () async {
      await dataSource.cache(mockModel);

      final result = await dataSource.getCached();
      expect(result, isNotNull);
      expect(result!.qas.containsKey('global'), isTrue);
      expect(result.qas['global']!.first.question, 'What tech stack is used?');
      expect(result.qas['global']!.first.answer, 'Flutter & Riverpod');
    });

    test('getCached handles corrupted cache data gracefully by returning null', () async {
      await SpUtil.put(AppConstants.presetQAsKey, 'invalid-json{{{');
      final result = await dataSource.getCached();
      expect(result, isNull);
    });
  });
}
