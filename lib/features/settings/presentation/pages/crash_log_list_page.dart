import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';
import 'package:share_plus/share_plus.dart';

class CrashLogListPage extends StatefulWidget {
  const CrashLogListPage({super.key});

  @override
  State<CrashLogListPage> createState() => _CrashLogListPageState();
}

class _CrashLogListPageState extends State<CrashLogListPage> {
  List<File> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    // 1. Load logs
    await _refreshLogs();

    // 2. Try to get initial file path from route params using AppNav
    final String? initialFilePath = AppNav.getParam<String>(Routes.argFilePath);
    if (initialFilePath != null) {
      final file = File(initialFilePath);
      if (file.existsSync()) {
        _viewLog(file);
      }
    }
  }

  Future<void> _refreshLogs() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final logs = await CrashManager.getSavedCrashLogs();
    if (mounted) {
      setState(() {
        _logs = logs;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: I18nKeys.crashReports.tr,
      actions: [IconButton(icon: const Icon(Icons.flash_on_rounded), onPressed: _handleTriggerCrash)],
      body: (context, child) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_logs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bug_report_outlined, size: 64, color: Colors.grey.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                Text(I18nKeys.noCrashReports.tr, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _logs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final file = _logs[index];
            final fileName = file.path.split('/').last;
            final stats = file.statSync();
            final dateStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(stats.modified);

            return _buildLogCard(file, fileName, dateStr);
          },
        );
      },
    );
  }

  Widget _buildLogCard(File file, String name, String date) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias, // Ensure ink splashes are clipped to the card's rounded corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
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
            const SizedBox(height: 4),
            Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
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
        onTap: () => _viewLog(file),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, color: Colors.grey),
          onSelected: (value) {
            if (value == 'share') {
              _shareLogFile(file);
            } else if (value == 'delete') {
              _deleteLog(file);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  const Icon(Icons.share_outlined, size: 20, color: Colors.blueAccent),
                  const SizedBox(width: 12),
                  Text(I18nKeys.share.tr),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.redAccent),
                  const SizedBox(width: 12),
                  Text(I18nKeys.delete.tr),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareLogFile(File file) {
    SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: 'Crash Log: ${file.path.split('/').last}'),
    );
  }

  void _handleTriggerCrash() async {
    final confirmed = await CommonDialog.showConfirm(
      title: I18nKeys.triggerCrash.tr,
      message: I18nKeys.triggerCrashDesc.tr,
      okText: I18nKeys.startTimer.tr,
    );
    if (confirmed == true) {
      CrashManager.scheduleRandomCrash();
      CommonToast.show(I18nKeys.crashScheduled.tr);
    }
  }

  void _viewLog(File file) async {
    final content = await file.readAsString();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LogDetailsSheet(content: content, fileName: file.path.split('/').last),
    );
  }

  void _uploadLog(File file) async {
    CommonLoading.show(message: I18nKeys.uploading.tr);
    final success = await CrashManager.uploadCrashLog(file);
    CommonLoading.hide();

    if (success) {
      CommonToast.show(I18nKeys.uploadSuccess.tr);
    } else {
      CommonToast.show(I18nKeys.uploadFailed.tr);
    }
  }

  void _deleteLog(File file) async {
    final confirmed = await CommonDialog.showConfirm(
      title: I18nKeys.deleteReport.tr,
      message: I18nKeys.deleteReportConfirm.tr,
      okText: I18nKeys.delete.tr,
      okColor: Colors.red,
    );

    if (confirmed == true) {
      await CrashManager.deleteCrashLog(file);
      _refreshLogs();
    }
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
