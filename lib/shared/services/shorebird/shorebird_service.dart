import 'package:listen_core/core.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

/// Enum representing the status of Shorebird Code Push updates.
enum ShorebirdCodePushStatus {
  idle,
  checking,
  updateAvailable,
  downloading,
  patchDownloaded,
  upToDate,
  unavailable,
  error,
}

abstract class IShorebirdService {
  /// Whether Shorebird Code Push is available on the current device build.
  bool get isAvailable;

  /// Gets current installed patch number or null if running base release.
  Future<int?> getCurrentPatchNumber();

  /// Whether current running app is executing an OTA Patch.
  Future<bool> get isRunningPatch;

  /// Formats version string with patch status (e.g. "1.1.11+1 (Patch #2)" or "1.1.11+1").
  Future<String> getFormattedVersion(String baseVersion);

  /// Checks if a new patch is available on Shorebird server.
  Future<bool> checkForUpdate();

  /// Downloads and installs the latest patch in the background.
  Future<bool> downloadUpdate();

  /// Encapsulates checking for updates and downloading if available.
  /// If a new patch is downloaded, triggers [onPatchDownloaded] callback.
  /// Returns `true` if a new patch was downloaded, `false` otherwise.
  Future<bool> checkAndInstallPatch({void Function()? onPatchDownloaded});

  /// Current status of the code push lifecycle.
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

/// Global instance of ShorebirdService.
late IShorebirdService shorebirdService;
