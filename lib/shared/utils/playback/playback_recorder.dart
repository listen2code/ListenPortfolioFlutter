import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../features/settings/data/models/playback_step.dart';
import '../../shared.dart';

/// Global MVI recording engine that observes and records all active ViewModels' user Intents,
/// system Effects, navigation pop transitions, and initial local storage snapshots.
///
/// Design Philosophy:
/// - **Non-Intrusive Tapeless Observation**: Instead of manually instrumenting every button or gesture
///   callback across hundreds of widgets, this recorder binds directly to the architectural boundary
///   ([MviPlaybackObserver] and [AppNav.onRoutePopped]). Any user interaction routed through MVI
///   is automatically captured with zero widget-level boilerplate.
/// - **Deterministic Environment Snapshot**: By snapshotting both [SpUtil] and [SecureStorageUtil] at the
///   start of a recording, the tape creates a hermetic baseline state so that subsequent replays can
///   reproduce identical application conditions regardless of external backend drifts.
class MviPlaybackRecorder {
  MviPlaybackRecorder._();

  /// Global singleton instance of the playback recorder.
  static final MviPlaybackRecorder instance = MviPlaybackRecorder._();

  /// Pluggable persistence callback delegate for saving recorded tapes.
  ///
  /// This inversion of control decouples the low-level recorder engine from specific storage
  /// implementations (e.g. SharedPreferences vs Hive vs remote HTTP upload), facilitating
  /// isolated unit testing with mock delegates.
  static Future<void> Function(String tapeKey, List<PlaybackStep> steps, String name, int timestamp)?
  saveTapeDelegate;

  /// Internal flag tracking whether an active recording session is underway.
  bool _isRecording = false;

  /// Ordered collection of recorded steps accumulated during the current recording session.
  final List<PlaybackStep> _recordedSteps = [];

  /// Millisecond timestamp marking the initiation of the recording session.
  int? _startTimestamp;

  /// Serialized baseline environment snapshot captured when recording started.
  Map<String, dynamic>? _initialState;

  /// Whether the recorder is currently listening to and capturing user events.
  bool get isRecording => _isRecording;

  /// Returns an unmodifiable view of the currently accumulated recording steps.
  List<PlaybackStep> get recordedSteps => List.unmodifiable(_recordedSteps);

  /// Captures a frozen snapshot of both plain key-value preferences and encrypted secure credentials.
  ///
  /// To prevent unbounded storage growth and circular references, keys containing
  /// [AppConstants.playbackTapeKey] or [AppConstants.playbackTapesListKey] are explicitly filtered out.
  Future<Map<String, dynamic>?> _captureInitialState() async {
    try {
      final Map<String, dynamic> spSnapshot = {};
      final keys = SpUtil.getKeys();
      for (final key in keys) {
        // Exclude tape metadata and raw tape payloads from the environment snapshot
        if (key.contains(AppConstants.playbackTapeKey) || key.contains(AppConstants.playbackTapesListKey)) {
          continue;
        }
        spSnapshot[key] = SpUtil.get(key);
      }

      // Snapshot critical encrypted authentication tokens
      final secureSnapshot = {
        AppConstants.authTokenKey: await SecureStorageUtil.get(AppConstants.authTokenKey),
        AppConstants.refreshTokenKey: await SecureStorageUtil.get(AppConstants.refreshTokenKey),
        AppConstants.loginPasswordKey: await SecureStorageUtil.get(AppConstants.loginPasswordKey),
      };

      return {PlaybackStep.sp: spSnapshot, PlaybackStep.secure: secureSnapshot};
    } catch (e) {
      appLogger.e('[${MviPlaybackPlayer.tag}] Failed to capture initial state: $e');
    }
    return null;
  }

  /// Initiates a new tape recording session.
  ///
  /// Steps performed:
  /// 1. Clears previously buffered steps and notes the starting millisecond timestamp.
  /// 2. Binds global hook observers ([MviPlaybackObserver.onIntentDispatched], [MviPlaybackObserver.onEffectEmitted],
  ///    and [AppNav.onRoutePopped]) synchronously to prevent missing early interactions.
  /// 3. Shows a brief loading HUD while asynchronously snapshotting persistent storage ([SpUtil] & [SecureStorageUtil]).
  Future<void> startRecording() async {
    _recordedSteps.clear();
    _startTimestamp = DateTime.now().millisecondsSinceEpoch;
    _isRecording = true;

    // Bind global observer callbacks synchronously first to prevent missing early intents
    MviPlaybackObserver.onIntentDispatched = _onIntent;
    MviPlaybackObserver.onEffectEmitted = _onEffect;
    AppNav.onRoutePopped = _onRoutePopped;

    try {
      CommonLoading.show();
    } catch (_) {}
    _initialState = await _captureInitialState();
    try {
      CommonLoading.hide();
    } catch (_) {}

    appLogger.i('[${MviPlaybackPlayer.tag}] : Recording started...');
  }

  /// Internal listener invoked whenever an Intent is dispatched to any active ViewModel.
  ///
  /// Associates the intent with its target [viewModelTag], string representation, active route,
  /// and timestamp, then appends a [PlaybackStep.intent] entry.
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

  /// Internal listener invoked whenever a ViewModel emits a UI side-effect.
  ///
  /// Recorded as [PlaybackStep.effect] primarily for diagnostics, auditing, and log overlay verification.
  /// Note: Effects are not actively re-emitted during replay because they are re-triggered naturally
  /// by the replayed Intents.
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

  /// Internal listener hooked into Navigator pop events.
  ///
  /// Rationale:
  /// Physical back buttons, swipe-back gestures, and AppBar back icons pop routes directly
  /// at the Navigator level without routing through a ViewModel Intent. By intercepting
  /// Navigator didPop events, we record these pops as explicit [PlaybackStep.pop] steps,
  /// preserving named page routes or modal popup signatures (e.g. dialogs/bottom sheets).
  void _onRoutePopped(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!_isRecording) return;
    if (route is! ModalRoute) return;

    _recordedSteps.add(
      PlaybackStep(
        type: PlaybackStep.pop,
        viewModelTag: PlaybackStep.system,
        name: route is PageRoute
            ? (route.settings.name ?? '')
            : '${PlaybackStep.pop}:${route.runtimeType.toString()}',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  /// Concludes the recording session and commits the tape via [saveTapeDelegate].
  ///
  /// Operations:
  /// 1. Unbinds all global observers to restore zero-overhead baseline runtime performance.
  /// 2. Prepends the captured initial state as step 0 ([PlaybackStep.initState]).
  /// 3. Generates a descriptive default tape name based on the first recorded user Intent (if no [customName] given).
  /// 4. Dispatches the serialized tape data to [saveTapeDelegate] for persistent storage.
  ///
  /// Returns the finalized tape name, or an empty string if no actions were recorded.
  Future<String> stopRecording({String? customName}) async {
    if (!_isRecording) return '';
    _isRecording = false;

    // Unbind callbacks
    MviPlaybackObserver.onIntentDispatched = null;
    MviPlaybackObserver.onEffectEmitted = null;
    AppNav.onRoutePopped = null;

    if (_recordedSteps.isEmpty) {
      appLogger.i('[${MviPlaybackPlayer.tag}] : Recording is empty, not saved.');
      return '';
    }

    if (_initialState != null) {
      _recordedSteps.insert(
        0,
        PlaybackStep(
          type: PlaybackStep.initState,
          viewModelTag: PlaybackStep.system,
          name: jsonEncode(_initialState),
          timestamp: _startTimestamp ?? DateTime.now().millisecondsSinceEpoch,
        ),
      );
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
