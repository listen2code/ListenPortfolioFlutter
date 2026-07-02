import 'dart:async';

import 'package:listen_core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../shared/shared.dart';
import '../../../data/models/playback_step.dart';
import '../../../data/models/playback_tape_metadata.dart';
import '../../provider/playback_provider.dart';
import 'playback_tape_list_intent.dart';
import 'playback_tape_list_state.dart';

part 'playback_tape_list_view_model.g.dart';

@riverpod
class PlaybackTapeListViewModel extends _$PlaybackTapeListViewModel
    with ViewModelMixin<PlaybackTapeListState, PlaybackTapeListIntent> {
  @override
  PlaybackTapeListState build() {
    return const PlaybackTapeListState();
  }

  @override
  void onReady() {
    super.onReady();
    handleIntent(const PlaybackTapeListIntent.loadTapes());
  }

  @override
  FutureOr<void> onIntent(PlaybackTapeListIntent intent) {
    intent.map(
      loadTapes: (_) => _loadTapes(),
      deleteTape: (val) => _deleteTape(val.tapeKey),
      startPlayback: (val) => _startPlayback(val.tapeKey),
      showTapeDetails: (val) => _showTapeDetails(val.tapeKey, val.tapeName),
    );
  }

  Future<void> _loadTapes() async {
    await call(
      ref.execute<List<PlaybackTapeMetadata>, BaseParam>(getPlaybackTapesUseCaseProvider),
      showLoading: true,
      onSuccess: (tapesList) async {
        final tapes = tapesList.reversed.toList();
        updateState(state.copyWith(tapes: tapes));
      },
      onFailure: (failure) {
        appLogger.e('Failed to load tape list: ${failure.message}');
      },
    );
  }

  void _deleteTape(String tapeKey) {
    emitEffect(
      ConfirmEffect(
        title: I18nKeys.delete.tr,
        message: I18nKeys.deleteTapeConfirmMsg.tr,
        okText: I18nKeys.delete.tr,
        cancelText: I18nKeys.cancel.tr,
        onResult: (confirmed) async {
          if (confirmed) {
            await call(
              ref.execute<void, String>(deletePlaybackTapeUseCaseProvider, param: tapeKey),
              showLoading: true,
              onSuccess: (_) async {
                emitEffect(MessageEffect(I18nKeys.tapeDeletedMsg.tr));
                _loadTapes();
              },
              onFailure: (failure) {
                appLogger.e('Failed to delete tape: ${failure.message}');
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _startPlayback(String tapeKey) async {
    await call(
      ref.execute<List<PlaybackStep>, String>(getPlaybackTapeStepsUseCaseProvider, param: tapeKey),
      showLoading: true,
      onSuccess: (steps) async {
        if (steps.isEmpty) return;

        PlaybackStep? firstStep;
        for (final s in steps) {
          if (s.type == PlaybackStep.intent) {
            firstStep = s;
            break;
          }
        }

        if (firstStep != null) {
          final route = firstStep.route;

          // Reset to Home screen to ensure fresh state
          emitEffect(NavigationEffect(target: Routes.home, isReplaceAll: true));
          await Future<dynamic>.delayed(const Duration(milliseconds: 600));

          // Navigate to the target route if it's not Home
          if (route != null && route != Routes.home) {
            emitEffect(NavigationEffect(target: route));
            await Future<dynamic>.delayed(const Duration(milliseconds: 500));
          }
        }

        // Start playback
        MviPlaybackPlayer.instance.play(tapeKey);
      },
      onFailure: (failure) {
        appLogger.e('Failed to load steps: ${failure.message}');
      },
    );
  }

  Future<void> _showTapeDetails(String tapeKey, String tapeName) async {
    await call(
      ref.execute<List<PlaybackStep>, String>(getPlaybackTapeStepsUseCaseProvider, param: tapeKey),
      showLoading: true,
      onSuccess: (steps) async {
        if (steps.isNotEmpty) {
          emitEffect(ShowTapeDetailsEffect(steps, tapeName));
        }
      },
      onFailure: (failure) {
        appLogger.e('Failed to load tape details: ${failure.message}');
      },
    );
  }
}
