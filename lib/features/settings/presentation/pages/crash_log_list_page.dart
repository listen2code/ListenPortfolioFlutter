import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/core/utils/crash_manager.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

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
    return BaseStatelessPage(
      title: 'Crash Reports',
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
                const Text('No crash reports found', style: TextStyle(color: Colors.grey)),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.description_outlined, color: Colors.redAccent),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        onTap: () => _viewLog(file),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.cloud_upload_outlined, color: Colors.blueAccent),
              onPressed: () => _uploadLog(file),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              onPressed: () => _deleteLog(file),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTriggerCrash() async {
    final confirmed = await CommonDialog.showConfirm(
      title: 'Trigger Injected Crash',
      message:
          'A random exception will be injected into any "dispatch" (UI interaction) that occurs after 10-20 seconds. Continue?',
      okText: 'Start Timer',
    );
    if (confirmed == true) {
      CrashManager.scheduleRandomCrash();
      CommonToast.show('Crash injection scheduled!');
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
    CommonLoading.show(message: 'Uploading...');
    final success = await CrashManager.uploadCrashLog(file);
    CommonLoading.hide();

    if (success) {
      CommonToast.show('Crash report uploaded successfully');
    } else {
      CommonToast.show('Upload failed');
    }
  }

  void _deleteLog(File file) async {
    final confirmed = await CommonDialog.showConfirm(
      title: 'Delete Report',
      message: 'Are you sure you want to delete this crash report?',
      okText: 'Delete',
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
                    CommonToast.show('Copied to clipboard');
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
        stickyLevelColor = Colors.redAccent;
        stickyMessageColor = Colors.red.shade100;
        hasNewTag = true;
      } else if (line.contains('[WARNING]')) {
        stickyLevelColor = Colors.orangeAccent;
        stickyMessageColor = Colors.orange.shade100;
        hasNewTag = true;
      } else if (line.contains('[INFO]')) {
        stickyLevelColor = Colors.blueAccent;
        stickyMessageColor = Colors.blue.shade100;
        hasNewTag = true;
      } else if (line.contains('[DEBUG]')) {
        stickyLevelColor = Colors.greenAccent;
        stickyMessageColor = Colors.green.shade100;
        hasNewTag = true;
      }

      if (hasNewTag) {
        // 如果是带标签的行，使用正则拆分渲染
        _addFormattedLogLine(spans, line, stickyLevelColor!, stickyMessageColor!);
      } else if (line.startsWith('Error:') || line.startsWith('Time:')) {
        spans.add(
          TextSpan(
            text: '$line\n',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        );
      } else {
        // 如果是不带标签的行（如堆栈或多行内容），延续上一个标签的颜色
        spans.add(
          TextSpan(
            text: '$line\n',
            style: TextStyle(color: stickyMessageColor ?? Colors.white70),
          ),
        );
      }
    }

    return TextSpan(children: spans);
  }

  void _addFormattedLogLine(List<TextSpan> spans, String line, Color levelColor, Color messageColor) {
    final regex = RegExp(r'^(\[.*?\])\s+(\[.*?\])\s+(.*)$');
    final match = regex.firstMatch(line);

    if (match != null) {
      spans.add(
        TextSpan(
          text: '${match.group(1)} ',
          style: const TextStyle(color: Colors.white30),
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
