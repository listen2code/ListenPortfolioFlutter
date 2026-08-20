import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/data/models/playback_step.dart';
import 'package:listen_portfolio_flutter/features/settings/data/models/playback_tape_metadata.dart';
import 'package:listen_portfolio_flutter/features/settings/data/repositories/playback_tape_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PlaybackTapeRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    repository = const PlaybackTapeRepositoryImpl();
  });

  group('PlaybackTapeRepositoryImpl Unit Tests', () {
    test('getTapes returns empty list when no data is in storage', () async {
      final result = await repository.getTapes();
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should be Right'),
        (tapes) => expect(tapes, isEmpty),
      );
    });

    test('saveTape, getTapes, getTapeSteps, and deleteTape CRUD operations', () async {
      const metadata = PlaybackTapeMetadata(
        key: 'tape_login_flow',
        name: 'Login Flow Tape',
        timestamp: 123456789,
        steps: 2,
      );

      final steps = <PlaybackStep>[
        const PlaybackStep(
          type: PlaybackStep.intent,
          viewModelTag: 'LoginViewModel',
          name: 'LoginIntent.emailChanged()',
          timestamp: 123456789,
        ),
        const PlaybackStep(
          type: PlaybackStep.intent,
          viewModelTag: 'LoginViewModel',
          name: 'LoginIntent.submit()',
          timestamp: 123456790,
        ),
      ];

      // 1. Save tape
      final saveResult = await repository.saveTape('tape_login_flow', steps, metadata);
      expect(saveResult.isRight(), isTrue);

      // 2. Get tapes
      final getTapesResult = await repository.getTapes();
      expect(getTapesResult.isRight(), isTrue);
      getTapesResult.fold(
        (failure) => fail('Should be Right'),
        (tapes) {
          expect(tapes.length, equals(1));
          expect(tapes.first.key, equals('tape_login_flow'));
          expect(tapes.first.name, equals('Login Flow Tape'));
        },
      );

      // 3. Get tape steps
      final getStepsResult = await repository.getTapeSteps('tape_login_flow');
      expect(getStepsResult.isRight(), isTrue);
      getStepsResult.fold(
        (failure) => fail('Should be Right'),
        (loadedSteps) {
          expect(loadedSteps.length, equals(2));
          expect(loadedSteps[0].viewModelTag, equals('LoginViewModel'));
          expect(loadedSteps[0].name, equals('LoginIntent.emailChanged()'));
          expect(loadedSteps[1].name, equals('LoginIntent.submit()'));
        },
      );

      // 4. Delete tape
      final deleteResult = await repository.deleteTape('tape_login_flow');
      expect(deleteResult.isRight(), isTrue);

      // 5. Verify deleted
      final getTapesAfterDelete = await repository.getTapes();
      getTapesAfterDelete.fold(
        (failure) => fail('Should be Right'),
        (tapes) => expect(tapes, isEmpty),
      );

      final getStepsAfterDelete = await repository.getTapeSteps('tape_login_flow');
      getStepsAfterDelete.fold(
        (failure) => fail('Should be Right'),
        (s) => expect(s, isEmpty),
      );
    });
  });
}
