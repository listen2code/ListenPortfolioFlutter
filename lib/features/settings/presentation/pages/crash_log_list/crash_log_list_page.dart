import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';
import 'crash_log_list_intent.dart';
import 'crash_log_list_state.dart';
import 'crash_log_list_view_model.dart';
import 'widgets/crash_log_card.dart';

class CrashLogListPage extends ConsumerWidget {
  const CrashLogListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(crashLogListViewModelProvider);
    final viewModel = ref.read(crashLogListViewModelProvider.notifier);

    return BaseRefreshPage<CrashLogListViewModel, CrashLogListState>(
      title: I18nKeys.crashReports.tr,
      provider: crashLogListViewModelProvider,
      actions: [
        CommonIconButton(
          icon: const Icon(Icons.flash_on_rounded),
          onPressed: () => viewModel.handleIntent(const CrashLogListIntent.triggerCrash()),
          tooltip: I18nKeys.triggerCrash.tr,
        ),
        CommonIconButton(
          icon: const Icon(Icons.delete_sweep_rounded),
          onPressed: state.logs.isEmpty
              ? null
              : () => viewModel.handleIntent(const CrashLogListIntent.deleteAll()),
          tooltip: I18nKeys.deleteAll.tr,
        ),
      ],
      body: (context, child, viewModel, state) {
        if (state.logs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bug_report_outlined, size: 64.f, color: Colors.grey.withValues(alpha: 0.5)),
                SizedBox(height: 16.f),
                CommonText(I18nKeys.noCrashReports.tr, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(16.f),
          itemCount: state.logs.length,
          separatorBuilder: (_, _) => SizedBox(height: 12.f),
          itemBuilder: (context, index) {
            final file = state.logs[index];
            final fileName = file.path.split('/').last;
            final stats = file.statSync();
            final dateStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(stats.modified);

            return CrashLogCard(
              file: file,
              name: fileName,
              date: dateStr,
              onTap: () => viewModel.handleIntent(CrashLogListIntent.viewLog(file)),
              onShare: () => viewModel.handleIntent(CrashLogListIntent.shareLog(file)),
              onDelete: () => viewModel.handleIntent(CrashLogListIntent.deleteLog(file)),
            );
          },
        );
      },
    );
  }
}
