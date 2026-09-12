import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';

import '../../../features/auth/data/models/user_model.dart';
import '../../../features/settings/data/models/playback_step.dart';
import '../../constants/app_constants.dart';
import '../../i18n/translations_key.dart';
import '../auth_manager.dart';
import '../playback_registry_init.dart';
import '../routes.dart';
import 'playback_progress.dart';

/// Global MVI playback engine that faithfully replays recorded tapes.
///
/// Core Capabilities:
/// - **State Sandboxing & Snapshot Isolation**: Caches the live user session before playback starts,
///   loads the tape's initial state, and guarantees restoration in a `finally` block even if the replay aborts.
/// - **Reflection-less Intent Dispatching**: Integrates with [MviPlaybackRegistry] to deserialize recorded
///   intent strings back into concrete typed [BaseIntent] instances without runtime reflection (`dart:mirrors`).
/// - **Intelligent Navigation Pop Handling**: Replays both named page pops and modal dialog/bottom-sheet dismissals,
///   safely inspecting the current top route to prevent double-pop anomalies.
/// - **Real-Time Telemetry**: Broadcasts progress updates via [onProgressChanged] and logs every step to [appLogger]
///   for in-app inspection via the APM LogOverlay.
class MviPlaybackPlayer {
  MviPlaybackPlayer._();

  /// Log tag prefix used for APM telemetry and debugging.
  static final String tag = 'PLAYBACK';

  /// Global singleton instance of the playback player.
  static final MviPlaybackPlayer instance = MviPlaybackPlayer._();

  /// Configurable delay interval between consecutive replay steps.
  ///
  /// Defaults to 1200ms to allow smooth Flutter transition animations (Hero, route pushes,
  /// dialog popups, keyboard dismissals) to settle before dispatching the next user intent.
  static Duration stepDelay = const Duration(milliseconds: 1200);

  /// Current immutable progress state snapshot.
  PlaybackProgress _progress = const PlaybackProgress(
    isPlaying: false,
    status: PlaybackStatus.idle,
    currentStepIndex: 0,
    totalSteps: 0,
    currentStepName: '',
  );

  /// Current immutable progress state snapshot.
  PlaybackProgress get progress => _progress;

  /// Optional listener callback invoked whenever playback progress, step index, or status changes.
  void Function(PlaybackProgress progress)? onProgressChanged;

  /// Atomically updates internal [_progress] using the `copyWith` pattern and notifies [onProgressChanged].
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

  /// Replays a recorded tape identified by [tapeKey], or directly from provided [steps].
  ///
  /// Execution Lifecycle:
  /// 1. **Guard Against Concurrent Playback**: If already playing, immediately exits.
  /// 2. **Step Resolution**: Loads serialized JSON from [SpUtil] unless explicit [steps] are supplied.
  /// 3. **Environment Caching**: Dumps the user's active persistent storage and credentials ([_cachePreState]).
  /// 4. **Initial State Injection**: If the tape contains an `initState` step, applies it to reset storage
  ///    and memory login state ([_applyState]).
  /// 5. **Route Synchronization**: Resets navigation stack to [Routes.home], then navigates to the starting route.
  /// 6. **Sequential Step Dispatching**:
  ///    - For `intent`: Finds active ViewModel via [ActiveViewModels.get], deserializes via [MviPlaybackRegistry],
  ///      and invokes `handleIntent`.
  ///    - For `pop`: Checks top route via [Navigator.popUntil]; dismisses modal popups or pops page routes safely.
  ///    - Waits for [stepDelay] between steps.
  /// 7. **Guaranteed Cleanup**: In a `finally` block, restores the cached pre-playback state ([prePlaybackState]),
  ///    resets [isPlaying] to false, and schedules a status cleanup after 3 seconds.
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

    // Step 1: Deep snapshot of current user session to ensure a clean sandbox rollback
    final Map<String, Map<String, dynamic>> prePlaybackState = await _cachePreState();

    try {
      final List<PlaybackStep> mutableSteps = List<PlaybackStep>.from(resolvedSteps);
      PlaybackStep? initialStateStep;
      if (mutableSteps.isNotEmpty && mutableSteps.first.type == PlaybackStep.initState) {
        initialStateStep = mutableSteps.removeAt(0);
      }
      _updateProgress(totalSteps: mutableSteps.length);

      // Step 2: Inject baseline state recorded when the tape was created
      if (initialStateStep != null) {
        appLogger.i('[$tag] Applying init user state');
        await _applyState(jsonDecode(initialStateStep.name) as Map<String, dynamic>);
      }

      // Step 3: Align navigation stack to starting screen
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

      // Step 4: Step-by-step playback loop
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
          // 1. Locate the active ViewModel instance registered in ActiveViewModels
          final vm = ActiveViewModels.get(viewModelTag);
          if (vm == null) {
            appLogger.w(
              '[$tag] Active ViewModel not found: $viewModelTag, skipping step, Active ViewModels: ${ActiveViewModels.all.keys.toList()}',
            );
          } else {
            // 2. Deserialize the intent string to a concrete Intent object without mirrors
            final intent = MviPlaybackRegistry.parseAndDeserialize(name);
            if (intent != null) {
              appLogger.i('[$tag][$viewModelTag] Success to handleIntent: $intent');
              // 3. Dispatch the intent to the ViewModel's state machine
              vm.handleIntent(intent);
            } else {
              appLogger.w('[$tag][$viewModelTag] Failed to deserialize Intent: $name');
            }
          }
        } else if (type == PlaybackStep.pop) {
          final isRecordedPopup = name.startsWith('${PlaybackStep.pop}:');
          Route<dynamic>? currentTopRoute;
          AppNavConfig.navigatorKey.currentState?.popUntil((r) {
            currentTopRoute = r;
            return true;
          });

          if (isRecordedPopup) {
            // Check if the current top route is a dialog, sheet, or popup menu
            final isCurrentRoutePopup = currentTopRoute != null && currentTopRoute is! PageRoute;
            if (isCurrentRoutePopup) {
              appLogger.i('[$tag] Replaying popup dismissal (pop) for: $name');
              AppNav.back();
            } else {
              appLogger.i('[$tag] Skipping popup dismissal (pop) for: $name (already dismissed)');
            }
          } else {
            // Verify route settings name to avoid popping the wrong page
            if (currentTopRoute?.settings.name == name) {
              appLogger.i('[$tag] Replaying page transition back navigation (pop) from: $name');
              AppNav.back();
            } else {
              appLogger.i(
                '[$tag] Skipping page transition back navigation (pop) from: $name (already popped to: ${currentTopRoute?.settings.name})',
              );
            }
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
      // Step 5: Guaranteed sandbox restoration - roll back SpUtil, SecureStorage, and AuthManager
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

  /// Restores storage state and in-memory auth state from a serialized or cached snapshot map.
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

  /// Dumps the current persistent state into an in-memory map prior to replaying a tape.
  ///
  /// Preserves tape data keys so tapes themselves are never wiped during the sandbox cycle.
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

  /// Clears non-tape preferences and repopulates them from [spMap].
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

  /// Rewrites secure tokens to [SecureStorageUtil] and synchronizes [authManager] in-memory state.
  ///
  /// Crucial Rationale:
  /// Protected routes and navigation guards check [authManager.isLoggedIn] synchronously in memory.
  /// Simply updating persistent disk storage without notifying [authManager] leaves the app in an
  /// inconsistent state where route navigation will fail or redirect unexpectedly to login.
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
