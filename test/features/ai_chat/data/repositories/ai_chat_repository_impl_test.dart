import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/datasources/ai_chat_local_data_source.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/datasources/ai_chat_remote_data_source.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_preset_qa_response_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/repositories/ai_chat_repository_impl.dart';
import 'package:listen_core/core.dart';
import 'package:mocktail/mocktail.dart';

class MockAiChatRemoteDataSource extends Mock implements AiChatRemoteDataSource {}
class MockAiChatLocalDataSource extends Mock implements AiChatLocalDataSource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(
      const AiPresetQaResponseModel(qas: {}),
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
