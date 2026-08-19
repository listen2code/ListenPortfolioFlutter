import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_chat_request_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_chat_response_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/domain/repositories/ai_chat_repository.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/domain/usecases/send_chat_message_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAiChatRepository extends Mock implements AiChatRepository {}

void main() {
  late MockAiChatRepository mockRepository;
  late SendChatMessageUseCase useCase;

  setUp(() {
    mockRepository = MockAiChatRepository();
    useCase = SendChatMessageUseCase(mockRepository);
  });

  const mockRequest = AiChatRequestModel(
    message: 'How is Clean Architecture applied here?',
    history: [],
    resumeContext: '',
    mode: 'architect',
  );

  const mockResponse = AiChatResponseModel(
    reply: 'Clean architecture separates domain, data, and presentation.',
  );

  group('SendChatMessageUseCase Tests', () {
    test('calls repository.sendChatMessage with given request model', () async {
      when(() => mockRepository.sendChatMessage(param: mockRequest))
          .thenAnswer((_) async => const Right(mockResponse));

      final result = await useCase(param: mockRequest);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should succeed'),
        (data) => expect(data?.reply, mockResponse.reply),
      );
      verify(() => mockRepository.sendChatMessage(param: mockRequest)).called(1);
    });

    test('propagates failure from repository when request fails', () async {
      when(() => mockRepository.sendChatMessage(param: any(named: 'param')))
          .thenAnswer((_) async => const Left(NetworkFailure('No internet connection')));

      final result = await useCase(param: mockRequest);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, 'No internet connection'),
        (_) => fail('Should fail'),
      );
    });
  });
}
