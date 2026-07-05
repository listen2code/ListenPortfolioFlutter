import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../features/auth/data/models/user_model.dart';
import '../../features/settings/data/models/playback_step.dart';
import '../constants/app_constants.dart';
import '../i18n/translations_key.dart';
import 'auth_manager.dart';
import 'playback_registry_init.dart';
import 'routes.dart';

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

/// Global MVI playback player to execute recorded tapes.
class MviPlaybackPlayer {
  MviPlaybackPlayer._();
  static final String tag = 'PLAYBACK';
  static final MviPlaybackPlayer instance = MviPlaybackPlayer._();

  /// Configurable delay between replaying each step.
  static Duration stepDelay = const Duration(milliseconds: 1200);

  PlaybackProgress _progress = const PlaybackProgress(
    isPlaying: false,
    status: PlaybackStatus.idle,
    currentStepIndex: 0,
    totalSteps: 0,
    currentStepName: '',
  );

  PlaybackProgress get progress => _progress;



  /// Callback when playback progress changes.
  void Function(PlaybackProgress progress)? onProgressChanged;

  void _updateProgress({
    bool? isPlaying,
    PlaybackStatus? status,
    int? currentStepIndex,
    int? totalSteps,
    String? currentStepName,
  }) {
    _progress = _progress.copyWith(
      isPlaying: isPlaying,
      status: status,
      currentStepIndex: currentStepIndex,
      totalSteps: totalSteps,
      currentStepName: currentStepName,
    );
    onProgressChanged?.call(_progress);
  }

  Future<void> play(String tapeKey, [List<PlaybackStep>? steps]) async {
    if (_progress.isPlaying) return;
    _updateProgress(
      isPlaying: true,
      status: PlaybackStatus.loading,
      currentStepIndex: 0,
      currentStepName: I18nKeys.loading.tr,
    );

    appLogger.i('[$tag] Playback started for tape key: $tapeKey');

    // Resolve steps
    List<PlaybackStep> resolvedSteps;
    try {
      if (steps != null) {
        resolvedSteps = steps;
      } else {
        final tapeJson = SpUtil.getString(tapeKey);
        if (tapeJson == null) {
          throw Exception('Tape data not found');
        }
        final List<dynamic> rawSteps = jsonDecode(tapeJson) as List<dynamic>;
        resolvedSteps = rawSteps.map((s) => PlaybackStep.fromJson(s as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      _updateProgress(
        isPlaying: false,
        status: PlaybackStatus.error,
        currentStepName: 'Failed to load steps: $e',
      );
      rethrow;
    }

    final Map<String, Map<String, dynamic>> prePlaybackState = await _cachePreState();

    try {
      final List<PlaybackStep> mutableSteps = List<PlaybackStep>.from(resolvedSteps);
      PlaybackStep? initialStateStep;
      if (mutableSteps.isNotEmpty && mutableSteps.first.type == PlaybackStep.initState) {
        initialStateStep = mutableSteps.removeAt(0);
      }
      _updateProgress(totalSteps: mutableSteps.length);

      if (initialStateStep != null) {
        appLogger.i('[$tag] Applying init user state');
        await _applyState(jsonDecode(initialStateStep.name) as Map<String, dynamic>);
      }

      final PlaybackStep? firstStep = mutableSteps.firstWhereOrNull(
        (tape) => tape.type == PlaybackStep.intent,
      );
      if (firstStep != null && firstStep.route != null) {
        final route = firstStep.route;

        // Reset to Home screen to ensure fresh state
        AppNav.offAll(Routes.home);
        await Future<dynamic>.delayed(const Duration(milliseconds: 500));

        // Navigate to the target route if it's not Home
        if (route != Routes.home) {
          AppNav.to(route!);
          await Future<dynamic>.delayed(const Duration(milliseconds: 500));
        }
      }

      _updateProgress(status: PlaybackStatus.playing);

      for (int i = 0; i < mutableSteps.length; i++) {
        final step = mutableSteps[i];
        final type = step.type;
        final viewModelTag = step.viewModelTag;
        final name = step.name;

        // Log each step to system log, making it queryable in the log overlay window
        appLogger.i('[$tag] Replaying step ${i + 1}/${mutableSteps.length}: [$type] $viewModelTag -> $name');

        _updateProgress(
          currentStepIndex: i + 1,
          currentStepName: '[$type][$viewModelTag]: ${name.split('(').first}',
        );

        if (type == PlaybackStep.intent) {
          // 1. Locate the active ViewModel
          final vm = ActiveViewModels.get(viewModelTag);
          if (vm == null) {
            appLogger.w(
              '[$tag] Active ViewModel not found: $viewModelTag, skipping step, Active ViewModels: ${ActiveViewModels.all.keys.toList()}',
            );
          } else {
            // 2. Deserialize the intent string to a concrete Intent object
            final intent = MviPlaybackRegistry.parseAndDeserialize(name);
            if (intent != null) {
              appLogger.i('[$tag][$viewModelTag] Success to handleIntent: $intent');
              // 3. Dispatch the intent
              vm.handleIntent(intent);
            } else {
              appLogger.w('[$tag][$viewModelTag] Failed to deserialize Intent: $name');
            }
          }
        } else if (type == PlaybackStep.pop) {
          final isRecordedPopup = name.startsWith('${PlaybackStep.pop}:');
          if (isRecordedPopup) {
            Route<dynamic>? currentTopRoute;
            AppNavConfig.navigatorKey.currentState?.popUntil((r) {
              currentTopRoute = r;
              return true;
            });

            final isCurrentRoutePopup = currentTopRoute != null && currentTopRoute is! PageRoute;
            if (isCurrentRoutePopup) {
              appLogger.i('[$tag] Replaying popup dismissal (pop) for: $name');
              AppNav.back();
            } else {
              appLogger.i('[$tag] Skipping popup dismissal (pop) for: $name (already dismissed)');
            }
          } else {
            appLogger.i('[$tag] Replaying page transition back navigation (pop) from: $name');
            AppNav.back();
          }
        }

        // Wait between steps for UI transitions to render
        await Future<dynamic>.delayed(stepDelay);
      }

      _updateProgress(status: PlaybackStatus.completed, currentStepName: I18nKeys.playbackFinishedMsg.tr);
      appLogger.i('[$tag] Playback finished.');
    } catch (e) {
      _updateProgress(status: PlaybackStatus.error, currentStepName: 'Playback error: $e');
      appLogger.e('[$tag] Playback encountered an error: $e');
    } finally {
      appLogger.i('[$tag] Restoring pre-playback user state sandbox...');
      await _applyState(prePlaybackState);

      _updateProgress(isPlaying: false);
      // Clear status display after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (!_progress.isPlaying) {
          _updateProgress(status: PlaybackStatus.idle, currentStepName: '');
        }
      });
    }
  }

  Future<void> _applyState(Map<String, dynamic> stateMap) async {
    try {
      appLogger.i('[$tag] Restoring initial state snapshot: $stateMap');

      final spMap = stateMap[PlaybackStep.sp] as Map<String, dynamic>?;
      final secureMap = stateMap[PlaybackStep.secure] as Map<String, dynamic>?;

      await _applySpState(spMap);
      await _applySecureAndAuthState(secureMap, spMap);
    } catch (e) {
      appLogger.e('[$tag] Failed to restore initial state: $e');
    }
  }

  Future<Map<String, Map<String, dynamic>>> _cachePreState() async {
    final Map<String, dynamic> prePlaybackSp = {};
    for (final key in SpUtil.getKeys()) {
      if (key.contains(AppConstants.playbackTapeKey) || key.contains(AppConstants.playbackTapesListKey)) {
        continue;
      }
      prePlaybackSp[key] = SpUtil.get(key);
    }
    final prePlaybackSecure = {
      AppConstants.authTokenKey: await SecureStorageUtil.get(AppConstants.authTokenKey),
      AppConstants.refreshTokenKey: await SecureStorageUtil.get(AppConstants.refreshTokenKey),
      AppConstants.loginPasswordKey: await SecureStorageUtil.get(AppConstants.loginPasswordKey),
    };
    return {PlaybackStep.sp: prePlaybackSp, PlaybackStep.secure: prePlaybackSecure};
  }

  Future<void> _applySpState(Map<String, dynamic>? spMap) async {
    if (spMap == null) return;
    for (final key in SpUtil.getKeys()) {
      if (key.contains(AppConstants.playbackTapeKey) || key.contains(AppConstants.playbackTapesListKey)) {
        continue;
      }
      await SpUtil.remove(key);
    }
    for (final entry in spMap.entries) {
      final key = entry.key;
      final val = entry.value;
      await SpUtil.put(key, val);
    }
    await SpUtil.reload();
  }

  Future<void> _applySecureAndAuthState(Map<String, dynamic>? secureMap, Map<String, dynamic>? spMap) async {
    if (secureMap == null) return;
    final authToken = secureMap[AppConstants.authTokenKey] as String?;
    final refreshToken = secureMap[AppConstants.refreshTokenKey] as String?;
    final loginPassword = secureMap[AppConstants.loginPasswordKey] as String?;

    await SecureStorageUtil.put(AppConstants.authTokenKey, authToken);
    await SecureStorageUtil.put(AppConstants.refreshTokenKey, refreshToken);
    await SecureStorageUtil.put(AppConstants.loginPasswordKey, loginPassword);

    if (spMap != null) {
      final userDataKeyWithPrefix = spMap.containsKey(AppConstants.userDataKey)
          ? AppConstants.userDataKey
          : spMap.keys.firstWhere((k) => k.endsWith(AppConstants.userDataKey), orElse: () => '');
      final userData = userDataKeyWithPrefix.isNotEmpty ? spMap[userDataKeyWithPrefix] as String? : null;

      if (authToken != null && userData != null) {
        final userMap = jsonDecode(userData) as Map<String, dynamic>;
        final user = UserModel.fromJson(userMap);
        authManager.login(user);
      } else {
        authManager.logout();
      }
    } else {
      authManager.logout();
    }
  }
}
