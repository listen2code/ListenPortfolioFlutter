import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/datasources/ai_chat_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/datasources/ai_chat_remote_data_source.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_chat_request_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_chat_response_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_preset_qa_response_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/repositories/ai_chat_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockAiChatRemoteDataSource extends Mock implements AiChatRemoteDataSource {}
class MockAiChatLocalDataSource extends Mock implements AiChatLocalDataSource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(
      const AiPresetQaResponseModel(qas: {}),
    );
    registerFallbackValue(
      const AiChatRequestModel(
        message: '',
        history: [],
        resumeContext: '',
        mode: '',
      ),
    );
  });

  late MockAiChatRemoteDataSource mockRemote;
  late MockAiChatLocalDataSource mockLocal;
  late AiChatRepositoryImpl repository;

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/connectivity'),
          (MethodCall call) async => ['wifi'],
        );

    mockRemote = MockAiChatRemoteDataSource();
    mockLocal = MockAiChatLocalDataSource();
    repository = AiChatRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  const mockRequest = AiChatRequestModel(
    message: 'Tell me about Riverpod architecture',
    history: [],
    resumeContext: '',
    mode: 'architect',
  );

  final mockResponse = const AiChatResponseModel(
    reply: 'Riverpod 3 is used for uni-directional state management.',
  );

  final mockPresetQas = AiPresetQaResponseModel(
    qas: {
      'global': [
        const PresetQaItem(
          question: 'Tech Stack?',
          answer: 'Flutter & Riverpod',
        ),
      ],
    },
  );

  group('AiChatRepositoryImpl Tests', () {
    test('sendChatMessage returns Right(AiChatResponseModel) on remote success', () async {
      when(() => mockRemote.sendChatMessage(any()))
          .thenAnswer((_) async => BaseResponseModel(result: ApiResult.success, message: 'success', body: mockResponse));

      final result = await repository.sendChatMessage(param: mockRequest);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not return failure'),
        (data) {
          expect(data?.reply, mockResponse.reply);
        },
      );
      verify(() => mockRemote.sendChatMessage(mockRequest)).called(1);
    });

    test('sendChatMessage returns Left(Failure) on remote exception', () async {
      when(() => mockRemote.sendChatMessage(any()))
          .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/v1/ai/chat'),
            type: DioExceptionType.connectionTimeout,
          ));

      final result = await repository.sendChatMessage(param: mockRequest);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (_) => fail('Should not return success'),
      );
    });

    test('getPresetQAs returns Right and updates local cache on remote success', () async {
      when(() => mockRemote.getPresetQAs(any()))
          .thenAnswer((_) async => BaseResponseModel(result: ApiResult.success, message: 'success', body: mockPresetQas));
      when(() => mockLocal.cache(any())).thenAnswer((_) async {});

      final result = await repository.getPresetQAs(route: '/home');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not return failure'),
        (data) => expect(data?.qas.containsKey('global'), isTrue),
      );
      verify(() => mockRemote.getPresetQAs('/home')).called(1);
      verify(() => mockLocal.cache(mockPresetQas)).called(1);
    });

    test('getPresetQAs falls back to local cache when offline', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('dev.fluttercommunity.plus/connectivity'),
            (MethodCall call) async => ['none'],
          );

      when(() => mockLocal.getCached()).thenAnswer((_) async => mockPresetQas);

      final result = await repository.getPresetQAs(route: '/home');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not return failure'),
        (data) => expect(data?.qas.containsKey('global'), isTrue),
      );
      verify(() => mockLocal.getCached()).called(1);
    });

    test('getPresetQAs returns Left(Failure) when offline and local cache is null', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('dev.fluttercommunity.plus/connectivity'),
            (MethodCall call) async => ['none'],
          );

      when(() => mockLocal.getCached()).thenAnswer((_) async => null);

      final result = await repository.getPresetQAs(route: '/home');

      expect(result.isLeft(), isTrue);
    });
  });
}
