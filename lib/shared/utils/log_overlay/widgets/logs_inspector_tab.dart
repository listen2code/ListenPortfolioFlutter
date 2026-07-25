part of '../log_overlay_manager.dart';

class _LogsInspectorTab extends StatefulWidget {
  final TextEditingController traceController;
  final ValueChanged<String> onNavigateToPerf;

  const _LogsInspectorTab({
    required this.traceController,
    required this.onNavigateToPerf,
  });

  @override
  State<_LogsInspectorTab> createState() => _LogsInspectorTabState();
}

class _LogsInspectorTabState extends State<_LogsInspectorTab> {
  LogFilter currentFilter = LogFilter.all;
  bool isFilterVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLogsSubHeader(),
        const Divider(color: Colors.white10, height: 1),
        // Level 3: Collapsible Filter Bar
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterBar(),
              const Divider(color: Colors.white10, height: 1),
            ],
          ),
          crossFadeState: isFilterVisible ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        Expanded(
          child: _buildLogsTabContent(),
        ),
      ],
    );
  }

  Widget _buildLogsSubHeader() {
    final filterText = isFilterVisible ? I18nKeys.btnHideFilter.tr : I18nKeys.btnFilterLogs.tr;
    final refreshText = I18nKeys.btnRefresh.tr;
    final copyText = I18nKeys.btnCopy.tr;
    final clearText = I18nKeys.btnClear.tr;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Colors.white.withValues(alpha: 0.02),
      child: Row(
        children: [
          _subHeaderActionButton(
            filterText,
            isFilterVisible ? Icons.filter_list_off_rounded : Icons.filter_list_rounded,
            () {
              setState(() => isFilterVisible = !isFilterVisible);
            },
            color: isFilterVisible ? Colors.greenAccent : Colors.white70,
          ),
          const SizedBox(width: 8),
          _subHeaderActionButton(refreshText, Icons.refresh_rounded, () {
            LogManager.refresh();
          }),
          const SizedBox(width: 8),
          _subHeaderActionButton(copyText, Icons.copy_rounded, () {
            Clipboard.setData(ClipboardData(text: LogManager.getAllLogsAsText()));
            CommonToast.show(I18nKeys.copiedToClipboard.tr);
          }),
          const SizedBox(width: 8),
          _subHeaderActionButton(clearText, Icons.delete_sweep_outlined, () {
            LogManager.clear();
          }),
        ],
      ),
    );
  }

  Widget _subHeaderActionButton(
    String label,
    IconData icon,
    VoidCallback onTap, {
    Color color = Colors.white70,
  }) {
    return CommonClickable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white10, width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            CommonText(label, style: TextStyle(color: color, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogsTabContent() {
    return ValueListenableBuilder<List<LogEntry>>(
      valueListenable: LogManager.logNotifier,
      builder: (context, logs, _) {
        final traceFilter = widget.traceController.text.trim();
        // Apply source, Trace ID and Performance filtering
        final filteredLogs = logs.where((log) {
          // Trace ID filter
          if (traceFilter.isNotEmpty && !log.message.contains(traceFilter)) {
            return false;
          }

          // Source, Perf, and Playback filter
          final bool isServerLog =
              log.message.contains(LogManager.mockServerTag) ||
              log.message.contains(LogManager.requestTag) ||
              log.message.contains(LogManager.responseTag) ||
              log.message.contains(LogManager.errorTag) ||
              log.message.contains(LogManager.authInterceptorTag) ||
              log.message.contains(LogManager.errorInterceptorTag) ||
              log.message.contains(LogManager.repositoryTag);
          final bool isPerf =
              log.message.contains(LogManager.summaryTag) || log.message.contains(LogManager.termTag);
          final bool isPlayback = log.message.contains('[${MviPlaybackPlayer.tag}]');

          switch (currentFilter) {
            case LogFilter.all:
              return true;
            case LogFilter.server:
              return isServerLog;
            case LogFilter.app:
              return !isServerLog && !isPerf && !isPlayback;
            case LogFilter.perf:
              return isPerf;
            case LogFilter.playback:
              return isPlayback;
          }
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: filteredLogs.length,
          itemBuilder: (context, index) {
            final log = filteredLogs[filteredLogs.length - 1 - index];
            return _buildLogRow(log);
          },
        );
      },
    );
  }

  Widget _buildLogRow(LogEntry log) {
    // Attempt to extract traceId from format [uuid-v4] or mainTraceId
    final traceRegex = RegExp('\\[([a-f0-9-]{36}|${ZoneManager.mainTraceId})\\]');
    final match = traceRegex.firstMatch(log.message);
    final String? traceId = match?.group(1);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 10),
          children: [
            TextSpan(
              text: '[${log.formattedTime}] ',
              style: const TextStyle(color: Colors.white38),
            ),
            if (traceId != null) ...[
              const TextSpan(
                text: '[',
                style: TextStyle(color: Colors.white24),
              ),
              TextSpan(
                text: traceId,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.dashed,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    widget.onNavigateToPerf(traceId);
                  },
              ),
              const TextSpan(
                text: '] ',
                style: TextStyle(color: Colors.white24),
              ),
              TextSpan(
                text: log.message.replaceFirst('[$traceId]', ''),
                style: TextStyle(color: _getLogColor(log.level)),
              ),
            ] else
              TextSpan(
                text: log.message,
                style: TextStyle(color: _getLogColor(log.level)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white.withValues(alpha: 0.02),
      child: Column(
        children: [
          Row(
            children: [
              _filterChip('All', LogFilter.all),
              const SizedBox(width: 6),
              _filterChip('Server', LogFilter.server, color: Colors.orangeAccent),
              const SizedBox(width: 6),
              _filterChip('App', LogFilter.app, color: Colors.blueAccent),
              const SizedBox(width: 6),
              _filterChip('Perf', LogFilter.perf, color: Colors.purpleAccent),
              const SizedBox(width: 6),
              _filterChip('playback', LogFilter.playback, color: Colors.redAccent),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, size: 14, color: Colors.white24),
                const SizedBox(width: 8),
                Expanded(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textTheme: const TextTheme(
                        bodyLarge: TextStyle(color: Colors.white70, fontSize: 11),
                        titleMedium: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      inputDecorationTheme: const InputDecorationTheme(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                    child: CommonTextField(
                      controller: widget.traceController,
                      hintText: 'Filter by Trace ID...',
                    ),
                  ),
                ),
                if (widget.traceController.text.isNotEmpty)
                  CommonClickable(
                    onTap: () => widget.traceController.clear(),
                    child: const Icon(Icons.close_rounded, size: 14, color: Colors.white24),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, LogFilter filter, {Color? color}) {
    final bool isSelected = currentFilter == filter;
    return CommonClickable(
      onTap: () => setState(() => currentFilter = filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? Colors.greenAccent).withValues(alpha: 0.2) : Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? (color ?? Colors.greenAccent).withValues(alpha: 0.5) : Colors.white10,
            width: 0.5,
          ),
        ),
        child: CommonText(
          label,
          style: TextStyle(
            color: isSelected ? (color ?? Colors.greenAccent) : Colors.white38,
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Color _getLogColor(LogLevel level) {
    switch (level) {
      case LogLevel.error:
        return Colors.redAccent;
      case LogLevel.warning:
        return Colors.orangeAccent;
      case LogLevel.debug:
        return Colors.blueAccent;
      default:
        return Colors.white70;
    }
  }
}
