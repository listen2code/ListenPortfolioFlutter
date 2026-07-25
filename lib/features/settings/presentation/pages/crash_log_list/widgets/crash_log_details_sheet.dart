import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class CrashLogDetailsSheet extends StatelessWidget {
  final String content;
  final String fileName;

  const CrashLogDetailsSheet({super.key, required this.content, required this.fileName});

  @override
  Widget build(BuildContext context) {
    final traceIdMatch = RegExp(r'^Trace ID:\s+(.+)$', multiLine: true).firstMatch(content);
    final String? traceId = traceIdMatch?.group(1)?.trim();
    final bool hasValidTraceId = traceId != null && traceId.isNotEmpty && traceId != 'no-trace-id';

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
                  child: CommonText(
                    fileName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasValidTraceId) ...[
                  CommonClickable(
                    onTap: () {
                      Navigator.pop(context); // Close details sheet
                      LogOverlayManager.traceFilterNotifier.value = traceId;
                      LogOverlayManager.show(context, startExpanded: true);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.3), width: 0.5),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.zoom_in_rounded, color: Colors.greenAccent, size: 13),
                          SizedBox(width: 4),
                          CommonText(
                            'Drill Logs',
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                CommonIconButton(
                  icon: const Icon(Icons.copy_all_rounded),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: content));
                    CommonToast.show(I18nKeys.copiedToClipboard.tr);
                  },
                  tooltip: I18nKeys.copyLogsSemanticLabel.tr,
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
      spans
        ..add(
          TextSpan(
            text: '${match.group(1)} ',
            style: TextStyle(color: defaultColor.withValues(alpha: 0.3)),
          ),
        )
        ..add(
          TextSpan(
            text: '${match.group(2)} ',
            style: TextStyle(color: levelColor, fontWeight: FontWeight.bold),
          ),
        )
        ..add(
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
