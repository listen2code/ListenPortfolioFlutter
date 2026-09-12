import 'package:listen_core/core.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

/// Lifecycle states of the Shorebird OTA Code Push patch engine.
enum ShorebirdCodePushStatus {
  /// Engine is idle, no update checks or downloads are in progress.
  idle,

  /// Querying Shorebird Cloud servers for patch metadata.
  checking,

  /// A new patch binary is available for download on Shorebird Cloud.
  updateAvailable,

  /// Background delta binary download in progress.
  downloading,

  /// Patch has been downloaded and verified; will activate on next cold start.
  patchDownloaded,

  /// Current app is executing the latest available patch or base release.
  upToDate,

  /// Shorebird engine is unavailable on this platform or build (e.g. debug mode or Web).
  unavailable,

  /// Network failure, signature mismatch, or exception during update lifecycle.
  error,
}

/// Abstract contract governing Over-The-Air (OTA) Dart code push updates.
///
/// ### Architecture & Design Principles:
/// 1. **Inversion of Control (IoC)**:
///    The core app and UI layers depend strictly on this abstraction rather than directly
///    referencing `package:shorebird_code_push`. This enables seamless mocking in unit tests
///    and avoids compilation crashes on unsupported platforms (e.g., Flutter Web).
///
/// 2. **Non-Blocking Background Lifecycle**:
///    OTA checks and binary patch downloads run asynchronously in low-priority background
///    threads or microtasks. They never hold up cold boot, main thread event loops, or
///    UI render frames.
///
/// 3. **Store Compliance (Google Play & Apple App Store)**:
///    Complies with App Store Review Guideline 3.3.2 and Google Play Developer Policies.
///    Updates are limited to Dart code executed within Flutter's sandboxed AOT engine;
///    dynamic loading of arbitrary native C/C++/Swift binary code is strictly avoided.
abstract class IShorebirdService {
  /// Whether the Shorebird native engine is active on the current device and build flavor.
  bool get isAvailable;

  /// Retrieves the sequence number of the currently active patch (e.g. `1`, `2`),
  /// or `null` if the app is running the unpatched base store release.
  Future<int?> getCurrentPatchNumber();

  /// Returns `true` if the currently executing application has booted from an OTA patch.
  Future<bool> get isRunningPatch;

  /// Appends the patch indicator to the semantic version string
  /// (e.g. `1.1.11+1 (Patch #1)` or `1.1.11+1`).
  Future<String> getFormattedVersion(String baseVersion);

  /// Checks if a newer patch is available on Shorebird Cloud.
  Future<bool> checkForUpdate();

  /// Downloads the latest available patch delta in the background.
  ///
  /// The patch will take effect automatically upon the next cold launch of the app.
  Future<bool> downloadUpdate();

  /// Encapsulates the complete OTA lifecycle: checks for updates, downloads the patch
  /// if found, and invokes [onPatchDownloaded] upon successful acquisition.
  ///
  /// Returns `true` if a new patch was downloaded, `false` otherwise.
  Future<bool> checkAndInstallPatch({void Function()? onPatchDownloaded});

  /// Current reactive status of the code push lifecycle.
  ShorebirdCodePushStatus get status;
}

class ShorebirdServiceImpl implements IShorebirdService {
  final ShorebirdUpdater _updater;
  ShorebirdCodePushStatus _status = ShorebirdCodePushStatus.idle;

  ShorebirdServiceImpl({ShorebirdUpdater? updater})
      : _updater = updater ?? ShorebirdUpdater();

  @override
  bool get isAvailable => _updater.isAvailable;

  @override
  ShorebirdCodePushStatus get status => _status;

  @override
  Future<int?> getCurrentPatchNumber() async {
    if (!isAvailable) {
      appLogger.w('[Shorebird] getCurrentPatchNumber: Shorebird is not available.');
      return null;
    }
    try {
      final patch = await _updater.readCurrentPatch();
      appLogger.i('[Shorebird] Current patch info: ${patch != null ? "Patch #${patch.number}" : "Base release (No patch)"}');
      return patch?.number;
    } catch (e, stack) {
      appLogger.e('[Shorebird] Failed to read current patch', error: e, stackTrace: stack);
      return null;
    }
  }

  @override
  Future<bool> get isRunningPatch async {
    final patchNum = await getCurrentPatchNumber();
    return patchNum != null && patchNum > 0;
  }

  @override
  Future<String> getFormattedVersion(String baseVersion) async {
    final patchNum = await getCurrentPatchNumber();
    if (patchNum != null && patchNum > 0) {
      return '$baseVersion (Patch #$patchNum)';
    }
    return baseVersion;
  }

  @override
  Future<bool> checkForUpdate() async {
    if (!isAvailable) {
      _status = ShorebirdCodePushStatus.unavailable;
      appLogger.w('[Shorebird] checkForUpdate: Shorebird is not available on this device/build.');
      return false;
    }

    _status = ShorebirdCodePushStatus.checking;
    appLogger.i('[Shorebird] Checking for patch updates from Shorebird Cloud...');
    try {
      final updateStatus = await _updater.checkForUpdate();
      appLogger.i('[Shorebird] Check update response: $updateStatus');
      if (updateStatus == UpdateStatus.outdated) {
        _status = ShorebirdCodePushStatus.updateAvailable;
        appLogger.i('[Shorebird] New patch AVAILABLE!');
        return true;
      } else {
        _status = ShorebirdCodePushStatus.upToDate;
        appLogger.i('[Shorebird] App is UP TO DATE with latest patch.');
        return false;
      }
    } catch (e, stack) {
      _status = ShorebirdCodePushStatus.error;
      appLogger.e('[Shorebird] Update check failed with error', error: e, stackTrace: stack);
      return false;
    }
  }

  @override
  Future<bool> downloadUpdate() async {
    if (!isAvailable) {
      appLogger.w('[Shorebird] downloadUpdate: Shorebird is not available.');
      return false;
    }

    _status = ShorebirdCodePushStatus.downloading;
    appLogger.i('[Shorebird] Downloading patch from Shorebird Cloud...');
    try {
      await _updater.update();
      _status = ShorebirdCodePushStatus.patchDownloaded;
      appLogger.i('[Shorebird] Patch downloaded successfully. Will apply on next app restart.');
      return true;
    } on UpdateException catch (e, stack) {
      _status = ShorebirdCodePushStatus.error;
      appLogger.e('[Shorebird] Patch download failed: ${e.message} (reason: ${e.reason})', error: e, stackTrace: stack);
      return false;
    } catch (e, stack) {
      _status = ShorebirdCodePushStatus.error;
      appLogger.e('[Shorebird] Unexpected error during patch download', error: e, stackTrace: stack);
      return false;
    }
  }

  /// Orchestrates the full OTA code push lifecycle:
  /// 1. Verifies if Shorebird engine is active.
  /// 2. Queries Shorebird Cloud for available patch updates.
  /// 3. Downloads the incremental delta package in the background.
  /// 4. Executes [onPatchDownloaded] callback to notify UI or dispatch effects.
  ///
  /// Returns `true` if a new patch was downloaded and staged, `false` otherwise.
  @override
  Future<bool> checkAndInstallPatch({void Function()? onPatchDownloaded}) async {
    appLogger.i('[Shorebird] checkAndInstallPatch: Starting full patch update workflow...');
    if (!isAvailable) {
      appLogger.w('[Shorebird] checkAndInstallPatch: Shorebird is not available on this device/build.');
      return false;
    }

    final hasUpdate = await checkForUpdate();
    if (!hasUpdate) {
      appLogger.i('[Shorebird] checkAndInstallPatch: App is already up to date. No patch needed.');
      return false;
    }

    appLogger.i('[Shorebird] checkAndInstallPatch: New patch available! Starting background download...');
    final downloaded = await downloadUpdate();
    if (downloaded) {
      appLogger.i('[Shorebird] checkAndInstallPatch: Patch downloaded successfully! Triggering onPatchDownloaded callback...');
      if (onPatchDownloaded != null) {
        try {
          onPatchDownloaded();
        } catch (e, stack) {
          appLogger.e('[Shorebird] checkAndInstallPatch: Error executing onPatchDownloaded callback', error: e, stackTrace: stack);
        }
      }
      return true;
    } else {
      appLogger.e('[Shorebird] checkAndInstallPatch: Patch download failed.');
      return false;
    }
  }
}

/// ============================================================================
/// NoOpShorebirdService (Null Object Pattern)
/// ============================================================================
/// Fallback implementation used on unsupported platforms (e.g. Flutter Web, Desktop)
/// or in headless test environments where the native Shorebird updater is absent.
///
/// Ensures calls to [shorebirdService] never throw [LateInitializationError] or null
/// pointer exceptions, returning safe defaults.
class NoOpShorebirdService implements IShorebirdService {
  const NoOpShorebirdService();

  @override
  bool get isAvailable => false;

  @override
  ShorebirdCodePushStatus get status => ShorebirdCodePushStatus.unavailable;

  @override
  Future<int?> getCurrentPatchNumber() async => null;

  @override
  Future<bool> get isRunningPatch async => false;

  @override
  Future<String> getFormattedVersion(String baseVersion) async => baseVersion;

  @override
  Future<bool> checkForUpdate() async => false;

  @override
  Future<bool> downloadUpdate() async => false;

  @override
  Future<bool> checkAndInstallPatch({void Function()? onPatchDownloaded}) async => false;
}

/// Global instance of [IShorebirdService], safely initialized with [NoOpShorebirdService]
/// to prevent late initialization crashes on Web or during pre-bootstrap test execution.
IShorebirdService shorebirdService = const NoOpShorebirdService();
