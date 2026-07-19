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
    return intent.when<FutureOr<void>>(
      loadTapes: _loadTapes,
      deleteTape: _deleteTape,
      confirmDeleteTape: _onConfirmDeleteTape,
      startPlayback: _startPlayback,
      showTapeDetails: _showTapeDetails,
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
        emitEffect(MessageEffect.error('Failed to load tape list: ${failure.message}'));
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
            handleIntent(PlaybackTapeListIntent.confirmDeleteTape(tapeKey));
          }
        },
      ),
    );
  }

  Future<void> _onConfirmDeleteTape(String tapeKey) async {
    await call(
      ref.execute<void, String>(deletePlaybackTapeUseCaseProvider, param: tapeKey),
      showLoading: true,
      onSuccess: (_) async {
        emitEffect(MessageEffect(I18nKeys.tapeDeletedMsg.tr));
        _loadTapes();
      },
      onFailure: (failure) {
        emitEffect(MessageEffect.error('Failed to delete tape: ${failure.message}'));
      },
    );
  }

  Future<void> _startPlayback(String tapeKey) async {
    await call(
      ref.execute<List<PlaybackStep>, String>(getPlaybackTapeStepsUseCaseProvider, param: tapeKey),
      showLoading: true,
      onSuccess: (steps) async {
        if (steps.isEmpty) {
          appLogger.e('steps is empty');
          return;
        }
        // Start playback
        emitEffect(PlayTapeEffect(tapeKey, steps));
      },
      onFailure: (failure) {
        emitEffect(MessageEffect.error('Failed to load steps: ${failure.message}'));
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
        emitEffect(MessageEffect.error('Failed to load tape details: ${failure.message}'));
      },
    );
  }
}
