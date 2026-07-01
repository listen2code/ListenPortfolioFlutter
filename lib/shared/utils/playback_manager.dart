import 'dart:convert';

import 'package:listen_core/core.dart';

import '../../features/settings/data/models/playback_step.dart';
import '../constants/app_constants.dart';
import '../i18n/translations_key.dart';
import 'playback_registry_init.dart';

/// Global MVI recorder that captures all Active ViewModels' Intents and Effects.
class MviPlaybackRecorder {
  MviPlaybackRecorder._();
  static final MviPlaybackRecorder instance = MviPlaybackRecorder._();

  /// Callback delegate to persist a recorded tape.
  static Future<void> Function(String tapeKey, List<PlaybackStep> steps, String name, int timestamp)?
  saveTapeDelegate;

  bool _isRecording = false;
  final List<PlaybackStep> _recordedSteps = [];
  int? _startTimestamp;

  bool get isRecording => _isRecording;
  List<PlaybackStep> get recordedSteps => List.unmodifiable(_recordedSteps);

  void startRecording() {
    _recordedSteps.clear();
    _startTimestamp = DateTime.now().millisecondsSinceEpoch;
    _isRecording = true;

    // Bind global observer callbacks
    MviPlaybackObserver.onIntentDispatched = _onIntent;
    MviPlaybackObserver.onEffectEmitted = _onEffect;

    appLogger.i('[${MviPlaybackPlayer.tag}] : Recording started...');
  }

  void _onIntent(String tag, dynamic intentVal) {
    if (!_isRecording) return;
    _recordedSteps.add(
      PlaybackStep(
        type: PlaybackStep.intent,
        viewModelTag: tag,
        name: intentVal.toString(),
        route: ActiveViewModels.getRoute(tag),
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  void _onEffect(String tag, dynamic effectVal) {
    if (!_isRecording) return;
    _recordedSteps.add(
      PlaybackStep(
        type: PlaybackStep.effect,
        viewModelTag: tag,
        name: effectVal.toString(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  /// Stops recording and saves to SharedPreferences.
  Future<String> stopRecording({String? customName}) async {
    if (!_isRecording) return '';
    _isRecording = false;

    // Unbind callbacks
    MviPlaybackObserver.onIntentDispatched = null;
    MviPlaybackObserver.onEffectEmitted = null;

    if (_recordedSteps.isEmpty) {
      appLogger.i('[${MviPlaybackPlayer.tag}] : Recording is empty, not saved.');
      return '';
    }

    // Generate default name
    String defaultName = 'Unnamed Tape';
    final firstIntent = _recordedSteps.firstWhere(
      (s) => s.type == PlaybackStep.intent,
      orElse: () => const PlaybackStep(type: '', viewModelTag: '', name: '', timestamp: 0),
    );
    if (firstIntent.name.isNotEmpty) {
      final tag = firstIntent.viewModelTag;
      final fullName = firstIntent.name;
      final shortName = fullName.split('(').first;
      defaultName = '$tag -> $shortName';
    }

    final String name = (customName != null && customName.trim().isNotEmpty)
        ? customName.trim()
        : defaultName;

    final timestamp = _startTimestamp ?? DateTime.now().millisecondsSinceEpoch;
    final tapeKey = '${AppConstants.playbackTapeKey}$timestamp';

    if (saveTapeDelegate != null) {
      await saveTapeDelegate!(tapeKey, _recordedSteps, name, timestamp);
    }

    appLogger.i('[${MviPlaybackPlayer.tag}] : Tape saved, Key: $tapeKey, Name: $name');
    return name;
  }
}

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
}

/// Global MVI playback player to execute recorded tapes.
class MviPlaybackPlayer {
  MviPlaybackPlayer._();
  static final String tag = 'PLAYBACK';
  static final MviPlaybackPlayer instance = MviPlaybackPlayer._();

  /// Configurable delay between replaying each step.
  static Duration stepDelay = const Duration(milliseconds: 1200);

  bool _isPlaying = false;
  PlaybackStatus _status = PlaybackStatus.idle;
  String _currentStepName = '';
  int _currentStepIndex = 0;
  int _totalSteps = 0;

  bool get isPlaying => _isPlaying;
  PlaybackStatus get status => _status;
  String get currentStepName => _currentStepName;
  int get currentStepIndex => _currentStepIndex;
  int get totalSteps => _totalSteps;

  PlaybackProgress get progress => PlaybackProgress(
    isPlaying: _isPlaying,
    status: _status,
    currentStepIndex: _currentStepIndex,
    totalSteps: _totalSteps,
    currentStepName: _currentStepName,
  );

  /// Callback when playback progress changes.
  void Function(PlaybackProgress progress)? onProgressChanged;

  Future<void> play(String tapeKey) async {
    if (_isPlaying) return;
    _isPlaying = true;
    _status = PlaybackStatus.loading;
    _currentStepIndex = 0;
    _totalSteps = 0;
    _currentStepName = I18nKeys.loading.tr;
    onProgressChanged?.call(progress);

    appLogger.i('[$tag] Playback started for tape key: $tapeKey');

    try {
      final tapeJson = SpUtil.getString(tapeKey);
      if (tapeJson == null) {
        throw Exception('Tape data not found');
      }

      final List<dynamic> rawSteps = jsonDecode(tapeJson) as List<dynamic>;
      final steps = rawSteps.map((s) => PlaybackStep.fromJson(s as Map<String, dynamic>)).toList();
      _totalSteps = steps.length;
      _status = PlaybackStatus.playing;
      onProgressChanged?.call(progress);

      for (int i = 0; i < steps.length; i++) {
        _currentStepIndex = i + 1;
        final step = steps[i];
        final type = step.type;
        final tag = step.viewModelTag;
        final name = step.name;

        // Log each step to system log, making it queryable in the log overlay window
        appLogger.i('[$tag] Replaying step ${i + 1}/${steps.length}: [$type] $tag -> $name');

        _currentStepName = '[$type] $tag: ${name.split('(').first}';
        onProgressChanged?.call(progress);

        if (type == PlaybackStep.intent) {
          // 1. Locate the active ViewModel
          final vm = ActiveViewModels.get(tag);
          if (vm == null) {
            appLogger.w('[$tag] Active ViewModel not found: $tag, skipping step');
          } else {
            // 2. Deserialize the intent string to a concrete Intent object
            final intent = MviPlaybackRegistry.parseAndDeserialize(name);
            if (intent != null) {
              appLogger.i('[$tag] Success to handleIntent: $intent');
              // 3. Dispatch the intent
              vm.handleIntent(intent);
            } else {
              appLogger.w('[$tag] Failed to deserialize Intent: $name');
            }
          }
        }

        // Wait between steps for UI transitions to render
        await Future<dynamic>.delayed(stepDelay);
      }

      _currentStepName = I18nKeys.playbackFinishedMsg.tr;
      _status = PlaybackStatus.completed;
      appLogger.i('[$tag] Playback finished.');
    } catch (e) {
      _currentStepName = 'Playback error: $e';
      _status = PlaybackStatus.error;
      appLogger.e('[$tag] Playback encountered an error: $e');
    } finally {
      _isPlaying = false;
      onProgressChanged?.call(progress);
      // Clear status display after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (!_isPlaying) {
          _currentStepName = '';
          _status = PlaybackStatus.idle;
          onProgressChanged?.call(progress);
        }
      });
    }
  }
}
