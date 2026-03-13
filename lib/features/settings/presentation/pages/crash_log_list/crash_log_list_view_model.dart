import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/base/share_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/widgets/common_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'crash_log_list_intent.dart';
import 'crash_log_list_state.dart';

part 'crash_log_list_view_model.g.dart';

@riverpod
class CrashLogListViewModel extends _$CrashLogListViewModel
    with ViewModelMixin<CrashLogListState, CrashLogListIntent> {
  @override
  CrashLogListState build() => const CrashLogListState();

  @override
  void onInit() {
    handleIntent(const CrashLogListIntent.init());
  }

  @override
  FutureOr<void> onIntent(CrashLogListIntent intent) {
    return intent.when<FutureOr<void>>(
      init: _onInit,
      refresh: _onRefresh,
      triggerCrash: _onTriggerCrash,
      deleteAll: _onDeleteAll,
      deleteLog: _onDeleteLog,
      shareLog: _onShareLog,
      viewLog: _onViewLog,
    );
  }

  Future<void> _onInit() async {
    emitEffect(LoadingEffect(true));
    await _loadLogs();

    final String? initialFilePath = AppNav.getParam<String>(Routes.argFilePath);
    if (initialFilePath != null) {
      final file = File(initialFilePath);
      if (file.existsSync()) {
        await _onViewLog(file);
      }
    }
    emitEffect(LoadingEffect(false));
  }

  Future<void> _onRefresh() async {
    await _loadLogs();
  }

  Future<void> _loadLogs() async {
    emitEffect(LoadingEffect(true));
    try {
      final logs = await CrashManager.getSavedCrashLogs();
      updateState(state.copyWith(logs: logs));
    } catch (e) {
      emitEffect(MessageEffect.error(e.toString()));
    } finally {
      emitEffect(LoadingEffect(false));
    }
  }

  Future<void> _onTriggerCrash() async {
    final confirmed = await CommonDialog.showConfirm(
      title: I18nKeys.triggerCrash.tr,
      message: I18nKeys.triggerCrashDesc.tr,
      okText: I18nKeys.startTimer.tr,
    );

    if (confirmed == true) {
      CrashManager.scheduleRandomCrash();
      emitEffect(MessageEffect.info(I18nKeys.crashScheduled.tr));
    }
  }

  Future<void> _onDeleteAll() async {
    final confirmed = await CommonDialog.showConfirm(
      title: I18nKeys.deleteReport.tr,
      message: '${I18nKeys.deleteReportConfirm.tr} (ALL)',
      okText: I18nKeys.delete.tr,
      okColor: Colors.red,
    );

    if (confirmed == true) {
      emitEffect(LoadingEffect(true));
      try {
        await CrashManager.deleteAllCrashLogs();
        await _loadLogs();
        emitEffect(MessageEffect.info(I18nKeys.cacheCleared.tr));
      } finally {
        emitEffect(LoadingEffect(false));
      }
    }
  }

  Future<void> _onDeleteLog(File file) async {
    final confirmed = await CommonDialog.showConfirm(
      title: I18nKeys.deleteReport.tr,
      message: I18nKeys.deleteReportConfirm.tr,
      okText: I18nKeys.delete.tr,
      okColor: Colors.red,
    );

    if (confirmed == true) {
      emitEffect(LoadingEffect(true));
      try {
        await CrashManager.deleteCrashLog(file);
        await _loadLogs();
      } finally {
        emitEffect(LoadingEffect(false));
      }
    }
  }

  Future<void> _onShareLog(File file) async {
    emitEffect(ShareEffect(files: [file.path], text: 'Crash Log: ${file.path.split('/').last}'));
  }

  Future<void> _onViewLog(File file) async {
    emitEffect(LoadingEffect(true));
    try {
      final content = await file.readAsString();
      emitEffect(LoadingEffect(false));
      emitEffect(MessageEffect.dialog(content, title: file.path.split('/').last));
    } catch (e) {
      emitEffect(LoadingEffect(false));
      emitEffect(MessageEffect.error(e.toString()));
    }
  }
}
