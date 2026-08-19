import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';
import '../../../domain/models/fault_injection_scenario.dart';

class FaultExecutionConsole extends StatelessWidget {
  final List<ExecutionStepLog> logs;
  final String? activeTraceId;
  final VoidCallback onClear;
  final ValueChanged<String> onCopyTrace;
  final ValueChanged<String> onDrillTrace;

  const FaultExecutionConsole({
    super.key,
    required this.logs,
    required this.activeTraceId,
    required this.onClear,
    required this.onCopyTrace,
    required this.onDrillTrace,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('HH:mm:ss.SSS');

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16.f),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      padding: EdgeInsets.all(14.f),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Console Top Bar: Title + Trace Actions + Clear Button
          Row(
            children: [
              Icon(
                Icons.terminal_rounded,
                size: 18.f,
                color: context.colorScheme.primary,
              ),
              SizedBox(width: 8.f),
              Expanded(
                child: CommonText(
                  I18nKeys.faultConsoleTitle.tr,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (logs.isNotEmpty)
                CommonIconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    size: 18.f,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: onClear,
                  tooltip: I18nKeys.faultClearConsole.tr,
                ),
            ],
          ),

          // Trace ID Action Bar (if active)
          if (activeTraceId != null) ...[
            SizedBox(height: 8.f),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.f, vertical: 6.f),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(8.f),
                border: Border.all(
                  color: context.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.fingerprint_rounded,
                    size: 16.f,
                    color: context.colorScheme.primary,
                  ),
                  SizedBox(width: 6.f),
                  Expanded(
                    child: CommonText(
                      'Trace: $activeTraceId',
                      style: context.textTheme.labelSmall?.copyWith(
                        fontFamily: 'monospace',
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  CommonClickable(
                    onTap: () => onCopyTrace(activeTraceId!),
                    child: Padding(
                      padding: EdgeInsets.all(4.f),
                      child: Icon(
                        Icons.copy_rounded,
                        size: 16.f,
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.f),
                  CommonClickable(
                    onTap: () => onDrillTrace(activeTraceId!),
                    child: Padding(
                      padding: EdgeInsets.all(4.f),
                      child: Icon(
                        Icons.open_in_new_rounded,
                        size: 16.f,
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 10.f),

          // Log List or Placeholder
          if (logs.isEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: 24.f, horizontal: 16.f),
              alignment: Alignment.center,
              child: CommonText(
                I18nKeys.faultNoLogsYet.tr,
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                ),
              ),
            )
          else
            Container(
              constraints: BoxConstraints(maxHeight: 220.f),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: logs.length,
                separatorBuilder: (_, _) => SizedBox(height: 6.f),
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final timeStr = dateFormat.format(log.timestamp);

                  Color logColor = context.colorScheme.onSurface;
                  if (log.isError) {
                    logColor = context.colorScheme.error;
                  } else if (log.isSuccess) {
                    logColor = context.colorScheme.primary;
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        '[$timeStr] ',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.colorScheme.outline,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Expanded(
                        child: CommonText(
                          log.message,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: logColor,
                            fontFamily: 'monospace',
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
