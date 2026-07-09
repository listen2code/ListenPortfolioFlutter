import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../features/settings/data/models/playback_step.dart';
import '../../constants/app_constants.dart';
import '../../shared.dart';
import 'playback_progress.dart';
import 'playback_player.dart';

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
  Map<String, dynamic>? _initialState;

  bool get isRecording => _isRecording;
  List<PlaybackStep> get recordedSteps => List.unmodifiable(_recordedSteps);

  Future<Map<String, dynamic>?> _captureInitialState() async {
    try {
      final Map<String, dynamic> spSnapshot = {};
      final keys = SpUtil.getKeys();
      for (final key in keys) {
        if (key.contains(AppConstants.playbackTapeKey) || key.contains(AppConstants.playbackTapesListKey)) {
          continue;
        }
        spSnapshot[key] = SpUtil.get(key);
      }

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

  /// Stops recording and saves to SharedPreferences.
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
