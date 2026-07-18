import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../../../shared/utils/playback_registry_init.dart';

part 'crash_log_list_intent.freezed.dart';

@freezed
class CrashLogListIntent extends BaseIntent with _$CrashLogListIntent {
  const factory CrashLogListIntent.init() = _Init;
  const factory CrashLogListIntent.refresh() = _Refresh;
  const factory CrashLogListIntent.triggerCrash() = _TriggerCrash;
  const factory CrashLogListIntent.confirmTriggerCrash() = _ConfirmTriggerCrash;
  const factory CrashLogListIntent.deleteAll() = _DeleteAll;
  const factory CrashLogListIntent.confirmDeleteAll() = _ConfirmDeleteAll;
  const factory CrashLogListIntent.deleteLog(File file) = _DeleteLog;
  const factory CrashLogListIntent.confirmDeleteLog(File file) = _ConfirmDeleteLog;
  const factory CrashLogListIntent.shareLog(File file) = _ShareLog;
  const factory CrashLogListIntent.viewLog(File file) = _ViewLog;
  const CrashLogListIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('CrashLogListIntent', 'init', (args) => const CrashLogListIntent.init());
    MviPlaybackRegistry.register('CrashLogListIntent', 'refresh', (args) => const CrashLogListIntent.refresh());
    MviPlaybackRegistry.register('CrashLogListIntent', 'triggerCrash', (args) => const CrashLogListIntent.triggerCrash());
    MviPlaybackRegistry.register('CrashLogListIntent', 'deleteAll', (args) => const CrashLogListIntent.deleteAll());
    MviPlaybackRegistry.register('CrashLogListIntent', 'deleteLog', (args) => CrashLogListIntent.deleteLog(File(args['file'] ?? '')));
    MviPlaybackRegistry.register('CrashLogListIntent', 'viewLog', (args) => CrashLogListIntent.viewLog(File(args['file'] ?? '')));
    MviPlaybackRegistry.register('CrashLogListIntent', 'shareLog', (args) => CrashLogListIntent.shareLog(File(args['file'] ?? '')));
    MviPlaybackRegistry.register('CrashLogListIntent', 'confirmTriggerCrash', (args) => const CrashLogListIntent.confirmTriggerCrash());
    MviPlaybackRegistry.register('CrashLogListIntent', 'confirmDeleteAll', (args) => const CrashLogListIntent.confirmDeleteAll());
    MviPlaybackRegistry.register('CrashLogListIntent', 'confirmDeleteLog', (args) => CrashLogListIntent.confirmDeleteLog(File(args['file'] ?? '')));
  }
}
