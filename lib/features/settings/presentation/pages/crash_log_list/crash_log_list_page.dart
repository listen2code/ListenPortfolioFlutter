import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:listen_core/core.dart';
import 'view_log_effect.dart';
import '../../../../../shared/shared.dart';
import 'package:listen_uikit/uikit.dart';

import 'crash_log_list_intent.dart';
import 'crash_log_list_state.dart';
import 'crash_log_list_view_model.dart';

class CrashLogListPage extends ConsumerWidget {
  const CrashLogListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(crashLogListViewModelProvider);
    final viewModel = ref.read(crashLogListViewModelProvider.notifier);

    return BaseRefreshPage<CrashLogListViewModel, CrashLogListState>(
      title: I18nKeys.crashReports.tr,
      provider: crashLogListViewModelProvider,
      onEffect: (effect) {
        if (effect is ViewLogEffect) {
          _viewLog(context, effect.file);
        }
      },
      actions: [
        IconButton(
          icon: const Icon(Icons.flash_on_rounded),
          onPressed: () => viewModel.handleIntent(const CrashLogListIntent.triggerCrash()),
          tooltip: I18nKeys.triggerCrash.tr,
        ),
        IconButton(
          icon: const Icon(Icons.delete_sweep_rounded),
          onPressed: state.logs.isEmpty
              ? null
              : () => viewModel.handleIntent(const CrashLogListIntent.deleteAll()),
          tooltip: I18nKeys.deleteAll.tr,
        ),
      ],
      body: (context, child, viewModel, state) {
        if (state == null) return const SizedBox.shrink();

        if (state.logs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bug_report_outlined, size: 64.f, color: Colors.grey.withValues(alpha: 0.5)),
                SizedBox(height: 16.f),
                Text(I18nKeys.noCrashReports.tr, style: const TextStyle(color: Colors.grey)),
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

            return _buildLogCard(context, viewModel, file, fileName, dateStr);
          },
        );
      },
    );
  }

  Widget _buildLogCard(
    BuildContext context,
    CrashLogListViewModel? viewModel,
    File file,
    String name,
    String date,
  ) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.f),
        side: BorderSide(color: context.theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.f, vertical: 12.f),
        leading: Container(
          padding: EdgeInsets.all(8.f),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.f),
          ),
          child: const Icon(Icons.description_outlined, color: Colors.redAccent),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.f),
            Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 4.f),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: file.path));
                CommonToast.show(I18nKeys.copiedToClipboard.tr);
              },
              child: Text(
                file.path,
                style: TextStyle(
                  fontSize: 10,
                  color: context.accentColor.withValues(alpha: 0.7),
                  decoration: TextDecoration.underline,
                  decorationColor: context.accentColor.withValues(alpha: 0.5),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        onTap: () => viewModel?.handleIntent(CrashLogListIntent.viewLog(file)),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, color: Colors.grey),
          onSelected: (value) {
            if (value == 'share') {
              viewModel?.handleIntent(CrashLogListIntent.shareLog(file));
            } else if (value == 'delete') {
              viewModel?.handleIntent(CrashLogListIntent.deleteLog(file));
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  const Icon(Icons.share_outlined, size: 20, color: Colors.blueAccent),
                  SizedBox(width: 12.f),
                  Text(I18nKeys.share.tr),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.redAccent),
                  SizedBox(width: 12.f),
                  Text(I18nKeys.delete.tr),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewLog(BuildContext context, File file) async {
    final content = await file.readAsString();
    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LogDetailsSheet(content: content, fileName: file.path.split('/').last),
    );
  }
}

class _LogDetailsSheet extends StatelessWidget {
  final String content;
  final String fileName;

  const _LogDetailsSheet({required this.content, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    fileName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_all_rounded),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: content));
                    CommonToast.show(I18nKeys.copiedToClipboard.tr);
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText.rich(
                _buildRichContent(context),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _buildRichContent(BuildContext context) {
    final List<TextSpan> spans = [];
    final lines = content.split('\n');
    final isDark = context.theme.brightness == Brightness.dark;
    final defaultTextColor =
        context.theme.textTheme.bodyMedium?.color ?? (isDark ? Colors.white70 : Colors.black87);

    Color? stickyLevelColor;
    Color? stickyMessageColor;

    for (var line in lines) {
      if (line.isEmpty) {
        spans.add(const TextSpan(text: '\n'));
        continue;
      }

      if (line.startsWith('===')) {
        stickyLevelColor = null;
        stickyMessageColor = null;

        spans.add(
          TextSpan(
            text: '$line\n',
            style: TextStyle(color: context.accentColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        );
        continue;
      }

      bool hasNewTag = false;
      if (line.contains('[ERROR]')) {
        stickyLevelColor = isDark ? Colors.redAccent : Colors.red.shade700;
        stickyMessageColor = isDark ? Colors.red.shade100 : Colors.red.shade900;
        hasNewTag = true;
      } else if (line.contains('[WARNING]')) {
        stickyLevelColor = isDark ? Colors.orangeAccent : Colors.orange.shade800;
        stickyMessageColor = isDark ? Colors.orange.shade100 : Colors.orange.shade900;
        hasNewTag = true;
      } else if (line.contains('[INFO]')) {
        stickyLevelColor = isDark ? Colors.blueAccent : Colors.blue.shade700;
        stickyMessageColor = isDark ? Colors.blue.shade100 : Colors.blue.shade900;
        hasNewTag = true;
      } else if (line.contains('[DEBUG]')) {
        stickyLevelColor = isDark ? Colors.greenAccent : Colors.green.shade700;
        stickyMessageColor = isDark ? Colors.green.shade100 : Colors.green.shade900;
        hasNewTag = true;
      }

      if (hasNewTag) {
        _addFormattedLogLine(spans, line, stickyLevelColor!, stickyMessageColor!, defaultTextColor);
      } else if (line.startsWith('Error:') || line.startsWith('Time:')) {
        spans.add(
          TextSpan(
            text: '$line\n',
            style: TextStyle(color: defaultTextColor, fontWeight: FontWeight.w600),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: '$line\n',
            style: TextStyle(color: stickyMessageColor ?? defaultTextColor.withValues(alpha: 0.8)),
          ),
        );
      }
    }

    return TextSpan(children: spans);
  }

  void _addFormattedLogLine(
    List<TextSpan> spans,
    String line,
    Color levelColor,
    Color messageColor,
    Color defaultColor,
  ) {
    final regex = RegExp(r'^(\[.*?\])\s+(\[.*?\])\s+(.*)$');
    final match = regex.firstMatch(line);

    if (match != null) {
      spans.add(
        TextSpan(
          text: '${match.group(1)} ',
          style: TextStyle(color: defaultColor.withValues(alpha: 0.3)),
        ),
      );
      spans.add(
        TextSpan(
          text: '${match.group(2)} ',
          style: TextStyle(color: levelColor, fontWeight: FontWeight.bold),
        ),
      );
      spans.add(
        TextSpan(
          text: '${match.group(3)}\n',
          style: TextStyle(color: messageColor),
        ),
      );
    } else {
      spans.add(
        TextSpan(
          text: '$line\n',
          style: TextStyle(color: messageColor),
        ),
      );
    }
  }
}
