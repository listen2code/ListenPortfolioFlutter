import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_preset_qa_response_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/domain/repositories/ai_chat_repository.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/domain/usecases/get_preset_qa_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAiChatRepository extends Mock implements AiChatRepository {}

void main() {
  late MockAiChatRepository mockRepository;
  late GetPresetQaUseCase useCase;

  setUp(() {
    mockRepository = MockAiChatRepository();
    useCase = GetPresetQaUseCase(mockRepository);
  });

  final mockModel = AiPresetQaResponseModel(
    qas: {
      'global': [
        const PresetQaItem(
          question: 'What is this app?',
          answer: 'A developer portfolio showcasing Flutter architecture.',
        ),
      ],
    },
  );

  group('GetPresetQaUseCase Tests', () {
    test('calls repository.getPresetQAs with correct route parameter', () async {
      when(() => mockRepository.getPresetQAs(route: '/home'))
          .thenAnswer((_) async => Right(mockModel));

      final result = await useCase(param: '/home');

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should succeed'),
        (data) => expect(data?.qas.containsKey('global'), isTrue),
      );
      verify(() => mockRepository.getPresetQAs(route: '/home')).called(1);
    });

    test('propagates Failure when repository returns Left', () async {
      when(() => mockRepository.getPresetQAs(route: any(named: 'route')))
          .thenAnswer((_) async => const Left(ServerFailure('Server Error')));

      final result = await useCase(param: '/unknown');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, 'Server Error'),
        (_) => fail('Should fail'),
      );
    });
  });
}
