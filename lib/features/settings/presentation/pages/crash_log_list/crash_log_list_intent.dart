import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'crash_log_list_intent.freezed.dart';

@freezed
class CrashLogListIntent extends BaseIntent with _$CrashLogListIntent {
  const factory CrashLogListIntent.init() = _Init;
  const factory CrashLogListIntent.refresh() = _Refresh;
  const factory CrashLogListIntent.triggerCrash() = _TriggerCrash;
  const factory CrashLogListIntent.deleteAll() = _DeleteAll;
  const factory CrashLogListIntent.deleteLog(File file) = _DeleteLog;
  const factory CrashLogListIntent.shareLog(File file) = _ShareLog;
  const factory CrashLogListIntent.viewLog(File file) = _ViewLog;
  const CrashLogListIntent._();
}
