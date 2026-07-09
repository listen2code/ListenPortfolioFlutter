/// Represents the execution state of the MVI playback system.
enum PlaybackStatus { idle, loading, playing, completed, error }

/// Progress state details for MVI playback.
class PlaybackProgress {
  final bool isPlaying;
  final PlaybackStatus status;
  final int currentStepIndex;
  final int totalSteps;
  final String currentStepName;

  const PlaybackProgress({
    required this.isPlaying,
    required this.status,
    required this.currentStepIndex,
    required this.totalSteps,
    required this.currentStepName,
  });

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
