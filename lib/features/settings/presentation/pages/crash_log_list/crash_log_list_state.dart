import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'crash_log_list_state.freezed.dart';

@freezed
abstract class CrashLogListState extends BaseState with _$CrashLogListState {
  const factory CrashLogListState({@Default([]) List<File> logs, @Default(true) bool isLoading}) =
      _CrashLogListState;
  const CrashLogListState._();
}
