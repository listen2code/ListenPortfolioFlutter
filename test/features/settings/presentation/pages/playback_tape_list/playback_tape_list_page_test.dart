import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/data/models/playback_tape_metadata.dart';
import 'package:listen_portfolio_flutter/features/settings/domain/repositories/playback_tape_repository.dart';
import 'package:listen_portfolio_flutter/features/settings/domain/usecases/delete_playback_tape_use_case.dart';
import 'package:listen_portfolio_flutter/features/settings/domain/usecases/get_playback_tape_steps_use_case.dart';
import 'package:listen_portfolio_flutter/features/settings/domain/usecases/get_playback_tapes_use_case.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/playback_tape_list/playback_tape_list_page.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/provider/playback_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MockPlaybackTapeRepository extends Mock implements PlaybackTapeRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockPlaybackTapeRepository mockRepo;

  final sampleTapes = [
    const PlaybackTapeMetadata(key: 'tape_1', name: 'User Login Tape', timestamp: 1700000000000, steps: 5),
    const PlaybackTapeMetadata(key: 'tape_2', name: '', timestamp: 1700000001000, steps: 12),
  ];

  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  setUp(() {
    mockRepo = MockPlaybackTapeRepository();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        playbackTapeRepositoryProvider.overrideWithValue(mockRepo),
        getPlaybackTapesUseCaseProvider.overrideWith((ref) => Future.value(GetPlaybackTapesUseCase(mockRepo))),
        getPlaybackTapeStepsUseCaseProvider.overrideWith((ref) => Future.value(GetPlaybackTapeStepsUseCase(mockRepo))),
        deletePlaybackTapeUseCaseProvider.overrideWith((ref) => Future.value(DeletePlaybackTapeUseCase(mockRepo))),
      ],
      child: const MaterialApp(
        home: PlaybackTapeListPage(),
      ),
    );
  }

  group('PlaybackTapeListPage Widget Tests', () {
    testWidgets('should render tape list and trigger playback and delete buttons', (WidgetTester tester) async {
      when(() => mockRepo.getTapes()).thenAnswer((_) async => Right(sampleTapes));
      when(() => mockRepo.getTapeSteps(any())).thenAnswer((_) async => const Right([]));
      when(() => mockRepo.deleteTape(any())).thenAnswer((_) async => const Right(null));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(I18nKeys.playbackTapeList.tr), findsOneWidget);
      expect(find.text('User Login Tape'), findsOneWidget);
      expect(find.text(I18nKeys.unnamedTape.tr), findsOneWidget);

      // Verify action buttons
      final playButtons = find.byIcon(Icons.play_circle_outline);
      expect(playButtons, findsNWidgets(2));

      final deleteButtons = find.byIcon(Icons.delete_outline);
      expect(deleteButtons, findsNWidgets(2));

      // Tap play button on first item
      await tester.tap(playButtons.first);
      await tester.pump();

      // Tap delete button on second item
      await tester.tap(deleteButtons.last);
      await tester.pump();
    });
  });
}
