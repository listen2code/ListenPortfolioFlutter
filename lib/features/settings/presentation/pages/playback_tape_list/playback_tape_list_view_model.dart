import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../shared/shared.dart';
import '../../../data/models/playback_step.dart';
import '../../../data/models/playback_tape_metadata.dart';
import '../../provider/playback_provider.dart';
import 'playback_tape_list_intent.dart';
import 'playback_tape_list_state.dart';

part 'playback_tape_list_view_model.g.dart';

/// MVI Presentation ViewModel managing the recorded tape list view, playback triggering, and tape deletion.
///
/// Architectural Highlights:
/// - **Clean Architecture Adherence**: Interacts exclusively with domain use cases
///   ([GetPlaybackTapesUseCase], [GetPlaybackTapeStepsUseCase], [DeletePlaybackTapeUseCase])
///   rather than accessing persistent storage or SharedPreferences directly.
/// - **Unidirectional Data Flow (MVI)**: Accepts [PlaybackTapeListIntent] actions, executes domain logic,
///   updates [PlaybackTapeListState], and emits single-use UI side-effects ([ConfirmEffect], [PlayTapeEffect], [ShowTapeDetailsEffect]).
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
    // Automatically trigger initial tape catalog fetch once the widget tree is mounted
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

  /// Loads all recorded tapes from persistent storage via domain use case and updates state.
  ///
  /// Reverses the list so newly recorded tapes appear at the top of the UI list.
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

  /// Prompts the user with a modal confirmation dialog before permanently deleting a tape.
  ///
  /// In automated playback mode, this [ConfirmEffect] is intercepted and automatically approved
  /// by `ConfirmProviderImpl`.
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

  /// Executes the actual deletion use case once the user (or playback engine) confirms deletion.
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

  /// Fetches the full chronological step payload for [tapeKey] and emits a [PlayTapeEffect] to launch playback.
  Future<void> _startPlayback(String tapeKey) async {
    await call(
      ref.execute<List<PlaybackStep>, String>(getPlaybackTapeStepsUseCaseProvider, param: tapeKey),
      showLoading: true,
      onSuccess: (steps) async {
        if (steps.isEmpty) {
          appLogger.e('steps is empty');
          return;
        }
        // Emit effect handled by UI provider to launch MviPlaybackPlayer
        emitEffect(PlayTapeEffect(tapeKey, steps));
      },
      onFailure: (failure) {
        emitEffect(MessageEffect.error('Failed to load steps: ${failure.message}'));
      },
    );
  }

  /// Fetches step details and emits [ShowTapeDetailsEffect] to display step inspection bottom sheet or dialog.
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

