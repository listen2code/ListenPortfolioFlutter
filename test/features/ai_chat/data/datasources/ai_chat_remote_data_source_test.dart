import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/datasources/ai_chat_remote_data_source.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_preset_qa_response_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AiChatRemoteDataSource Tests', () {
    late Dio dio;
    late AiChatRemoteDataSource remoteDataSource;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
      remoteDataSource = AiChatRemoteDataSource(dio);
    });

    test('getPresetQAs sends GET request with optional route query parameter', () async {
      dio.httpClientAdapter = _MockHttpClientAdapter((options) {
        expect(options.path, '/v1/ai/preset-qa');
        expect(options.method, 'GET');
        expect(options.queryParameters['route'], '/home?tab=overview');
        return ResponseBody.fromString(
          json.encode({
            'result': ApiResult.success,
            'message': 'success',
            'body': {
              'qas': {
                'global': [
                  {'question': 'Tech Stack?', 'answer': 'Flutter, Dart, Riverpod'},
                ],
              },
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final response = await remoteDataSource.getPresetQAs('/home?tab=overview');
      expect(response.result, ApiResult.success);
      expect(response.body?.qas.containsKey('global'), isTrue);
      expect(response.body?.qas['global']?.first.question, 'Tech Stack?');
    });
  });
}

class _MockHttpClientAdapter implements HttpClientAdapter {
  final ResponseBody Function(RequestOptions options) _handler;

  _MockHttpClientAdapter(this._handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}
