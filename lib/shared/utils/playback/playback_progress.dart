/// Represents the execution lifecycle states of the MVI tape playback system.
///
/// Lifecycle transition flow:
/// ```
/// [idle] -> [loading] -> [playing] -> [completed] -> (auto-reset after delay) -> [idle]
///    |           |            |
///    +-----------+------------+-----> [error] ----> (auto-reset after delay) -> [idle]
/// ```
enum PlaybackStatus {
  /// The player is inactive and waiting for a playback session to start.
  idle,

  /// The player is loading tape steps from persistent storage or preparing the initial state.
  loading,

  /// The player is actively sequentially executing recorded MVI steps (Intents/Pops).
  playing,

  /// All steps have been successfully replayed; sandboxed state restoration has finished.
  completed,

  /// An unhandled exception or deserialization fault halted replay execution.
  error,
}

/// Immutable snapshot representing the real-time progress and telemetry of an active MVI playback session.
///
/// Design Rationale:
/// - **Immutability**: Every field is marked `final` to ensure thread-safety and prevent
///   accidental shared-state mutation across asynchronous replay ticks.
/// - **Unidirectional Data Flow**: UI listeners or debug overlays receive discrete, predictable
///   snapshots emitted via `MviPlaybackPlayer.onProgressChanged`.
/// - **`copyWith` Pattern**: Allows localized atomic state updates without mutating existing references,
///   mirroring standard Redux / MVI architectural practices.
class PlaybackProgress {
  /// Whether a tape is actively being replayed or processed.
  final bool isPlaying;

  /// High-level lifecycle phase of the player.
  final PlaybackStatus status;

  /// 1-based index of the currently executing step (0 when idle or preparing).
  final int currentStepIndex;

  /// Total count of executable steps in the current tape (excluding the initial state step).
  final int totalSteps;

  /// Human-readable descriptor or serialized signature of the current step (e.g. `[intent][LoginViewModel]: submit`).
  final String currentStepName;

  const PlaybackProgress({
    required this.isPlaying,
    required this.status,
    required this.currentStepIndex,
    required this.totalSteps,
    required this.currentStepName,
  });

  /// Returns a new [PlaybackProgress] instance with selectively overridden properties.
  ///
  /// Unspecified fields retain their existing values, ensuring atomic and non-destructive state mutations.
  PlaybackProgress copyWith({
    bool? isPlaying,
    PlaybackStatus? status,
    int? currentStepIndex,
    int? totalSteps,
    String? currentStepName,
  }) {
    return PlaybackProgress(
      isPlaying: isPlaying ?? this.isPlaying,
      status: status ?? this.status,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      totalSteps: totalSteps ?? this.totalSteps,
      currentStepName: currentStepName ?? this.currentStepName,
    );
  }
}

