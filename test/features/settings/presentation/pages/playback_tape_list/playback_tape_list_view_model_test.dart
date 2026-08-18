import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/data/models/playback_step.dart';
import 'package:listen_portfolio_flutter/features/settings/data/models/playback_tape_metadata.dart';
import 'package:listen_portfolio_flutter/features/settings/domain/repositories/playback_tape_repository.dart';
import 'package:listen_portfolio_flutter/features/settings/domain/usecases/delete_playback_tape_use_case.dart';
import 'package:listen_portfolio_flutter/features/settings/domain/usecases/get_playback_tape_steps_use_case.dart';
import 'package:listen_portfolio_flutter/features/settings/domain/usecases/get_playback_tapes_use_case.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/playback_tape_list/playback_tape_list_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/playback_tape_list/playback_tape_list_state.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/playback_tape_list/playback_tape_list_view_model.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/provider/playback_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:mocktail/mocktail.dart';

class MockPlaybackTapeRepository extends Mock implements PlaybackTapeRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockPlaybackTapeRepository mockRepo;
  late ProviderContainer container;

  final sampleTapes = [
    const PlaybackTapeMetadata(key: 'tape_1', name: 'Tape 1', timestamp: 1000000, steps: 5),
    const PlaybackTapeMetadata(key: 'tape_2', name: 'Tape 2', timestamp: 2000000, steps: 8),
  ];

  final sampleSteps = [
    const PlaybackStep(type: PlaybackStep.intent, viewModelTag: 'LoginVM', name: 'login()', timestamp: 1000),
    const PlaybackStep(type: PlaybackStep.effect, viewModelTag: 'LoginVM', name: 'NavigationEffect', timestamp: 2000),
  ];

  setUp(() {
    mockRepo = MockPlaybackTapeRepository();
    container = ProviderContainer(
      overrides: [
        playbackTapeRepositoryProvider.overrideWithValue(mockRepo),
        getPlaybackTapesUseCaseProvider.overrideWith((ref) => Future.value(GetPlaybackTapesUseCase(mockRepo))),
        getPlaybackTapeStepsUseCaseProvider.overrideWith((ref) => Future.value(GetPlaybackTapeStepsUseCase(mockRepo))),
        deletePlaybackTapeUseCaseProvider.overrideWith((ref) => Future.value(DeletePlaybackTapeUseCase(mockRepo))),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('PlaybackTapeListViewModel Tests', () {
    test('initial state should be empty tapes list', () {
      final state = container.read(playbackTapeListViewModelProvider);
      expect(state.tapes, isEmpty);
    });

    test('loadTapes intent should update state with reversed tapes on success', () async {
      when(() => mockRepo.getTapes()).thenAnswer((_) async => Right(sampleTapes));

      final viewModel = container.read(playbackTapeListViewModelProvider.notifier);
      await viewModel.handleIntent(const PlaybackTapeListIntent.loadTapes());

      final state = container.read(playbackTapeListViewModelProvider);
      expect(state.tapes.length, 2);
      expect(state.tapes.first.key, 'tape_2');
      expect(state.tapes.last.key, 'tape_1');
    });

    test('loadTapes failure should emit MessageEffect.error', () async {
      when(() => mockRepo.getTapes()).thenAnswer((_) async => const Left(ServerFailure('Disk error')));

      final viewModel = container.read(playbackTapeListViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      await viewModel.handleIntent(const PlaybackTapeListIntent.loadTapes());
      await pumpEventQueue();

      expect(effects.whereType<MessageEffect>().isNotEmpty, isTrue);
      final errorEffect = effects.whereType<MessageEffect>().first;
      expect(errorEffect.message, contains('Disk error'));
    });

    test('deleteTape intent should emit ConfirmEffect with confirmation callback', () async {
      final viewModel = container.read(playbackTapeListViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      viewModel.handleIntent(const PlaybackTapeListIntent.deleteTape('tape_1'));
      await pumpEventQueue();

      expect(effects.whereType<ConfirmEffect>().isNotEmpty, isTrue);
      final confirmEffect = effects.whereType<ConfirmEffect>().first;
      expect(confirmEffect.title, I18nKeys.delete.tr);
    });

    test('confirmDeleteTape failure should emit MessageEffect.error', () async {
      when(() => mockRepo.deleteTape('tape_1')).thenAnswer((_) async => const Left(ServerFailure('Cannot delete')));

      final viewModel = container.read(playbackTapeListViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      await viewModel.handleIntent(const PlaybackTapeListIntent.confirmDeleteTape('tape_1'));
      await pumpEventQueue();

      expect(effects.whereType<MessageEffect>().isNotEmpty, isTrue);
    });

    test('startPlayback intent should emit PlayTapeEffect when steps is not empty', () async {
      when(() => mockRepo.getTapeSteps('tape_1')).thenAnswer((_) async => Right(sampleSteps));

      final viewModel = container.read(playbackTapeListViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      await viewModel.handleIntent(const PlaybackTapeListIntent.startPlayback('tape_1'));
      await pumpEventQueue();

      expect(effects.whereType<PlayTapeEffect>().isNotEmpty, isTrue);
      final playEffect = effects.whereType<PlayTapeEffect>().first;
      expect(playEffect.tapeKey, 'tape_1');
      expect(playEffect.steps.length, 2);
    });

    test('showTapeDetails intent should emit ShowTapeDetailsEffect', () async {
      when(() => mockRepo.getTapeSteps('tape_1')).thenAnswer((_) async => Right(sampleSteps));

      final viewModel = container.read(playbackTapeListViewModelProvider.notifier);
      final effects = <BaseEffect>[];
      viewModel.effectStream.listen(effects.add);

      await viewModel.handleIntent(const PlaybackTapeListIntent.showTapeDetails('tape_1', 'Tape 1'));
      await pumpEventQueue();

      expect(effects.whereType<ShowTapeDetailsEffect>().isNotEmpty, isTrue);
      final detailsEffect = effects.whereType<ShowTapeDetailsEffect>().first;
      expect(detailsEffect.name, 'Tape 1');
      expect(detailsEffect.steps.length, 2);
    });
  });
}
