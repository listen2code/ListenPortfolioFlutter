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
    if (!isAvailable) return null;
    try {
      final patch = await _updater.readCurrentPatch();
      return patch?.number;
    } catch (e, stack) {
      appLogger.e('Failed to read Shorebird current patch', error: e, stackTrace: stack);
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
      return false;
    }

    _status = ShorebirdCodePushStatus.checking;
    try {
      final updateStatus = await _updater.checkForUpdate();
      if (updateStatus == UpdateStatus.outdated) {
        _status = ShorebirdCodePushStatus.updateAvailable;
        return true;
      } else {
        _status = ShorebirdCodePushStatus.upToDate;
        return false;
      }
    } catch (e, stack) {
      _status = ShorebirdCodePushStatus.error;
      appLogger.e('Shorebird update check failed', error: e, stackTrace: stack);
      return false;
    }
  }

  @override
  Future<bool> downloadUpdate() async {
    if (!isAvailable) return false;

    _status = ShorebirdCodePushStatus.downloading;
    try {
      await _updater.update();
      _status = ShorebirdCodePushStatus.patchDownloaded;
      appLogger.i('Shorebird patch downloaded successfully. Patch will apply on next app restart.');
      return true;
    } on UpdateException catch (e, stack) {
      _status = ShorebirdCodePushStatus.error;
      appLogger.e('Shorebird update download failed: ${e.message}', error: e, stackTrace: stack);
      return false;
    } catch (e, stack) {
      _status = ShorebirdCodePushStatus.error;
      appLogger.e('Unexpected error during Shorebird update download', error: e, stackTrace: stack);
      return false;
    }
  }
}

/// Global instance of ShorebirdService.
late IShorebirdService shorebirdService;
