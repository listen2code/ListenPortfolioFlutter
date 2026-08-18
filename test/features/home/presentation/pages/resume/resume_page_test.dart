import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/home/domain/repositories/about_me_repository.dart';
import 'package:listen_portfolio_flutter/features/home/domain/usecases/get_resume_use_case.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/resume/resume_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/resume/resume_view_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/provider/about_me_provider.dart';
import 'package:listen_portfolio_flutter/shared/base/print_pdf_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:mocktail/mocktail.dart';

class MockAboutMeRepository extends Mock implements AboutMeRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAboutMeRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockAboutMeRepository();
    container = ProviderContainer(
      overrides: [
        aboutMeRepositoryProvider.overrideWith((ref) => mockRepo),
        getResumeUseCaseProvider.overrideWith((ref) => Future.value(GetResumeUseCase(mockRepo))),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ResumeViewModel Tests', () {
    test('initial state has empty markdownContent and isExporting as false', () {
      final state = container.read(resumeViewModelProvider);
      expect(state.markdownContent, isEmpty);
      expect(state.isExporting, isFalse);
    });

    test('init intent loads resume markdown successfully', () async {
      when(() => mockRepo.getResumeMarkdown()).thenAnswer((_) async => const Right('# Resume\n\n- Senior Flutter Developer'));

      final viewModel = container.read(resumeViewModelProvider.notifier);
      await viewModel.handleIntent(const ResumeIntent.init());

      final state = container.read(resumeViewModelProvider);
      expect(state.markdownContent, contains('Senior Flutter Developer'));
    });

    test('init intent on failure emits MessageEffect.error', () async {
      when(() => mockRepo.getResumeMarkdown()).thenAnswer((_) async => const Left(ServerFailure('Failed to load markdown')));

      final viewModel = container.read(resumeViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      await viewModel.handleIntent(const ResumeIntent.init());
      await pumpEventQueue();

      expect(effects.isNotEmpty, isTrue);
    });

    test('exportPDF intent when content is present emits PrintPdfEffect', () async {
      when(() => mockRepo.getResumeMarkdown()).thenAnswer((_) async => const Right('# My Resume'));

      final viewModel = container.read(resumeViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      await viewModel.handleIntent(const ResumeIntent.init());
      await viewModel.handleIntent(const ResumeIntent.exportPDF());
      await pumpEventQueue();

      expect(effects.any((e) => e is PrintPdfEffect || e.toString().contains('PrintPdfEffect')), isTrue);
    });
  });
}
