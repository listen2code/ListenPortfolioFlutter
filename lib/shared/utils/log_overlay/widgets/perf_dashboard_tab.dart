part of '../log_overlay_manager.dart';

/// The main dashboard tab content for APM performance monitoring.
class _PerfDashboardTab extends StatefulWidget {
  final String? traceFilter;

  const _PerfDashboardTab({this.traceFilter});

  @override
  State<_PerfDashboardTab> createState() => _PerfDashboardTabState();
}

class _PerfDashboardTabState extends State<_PerfDashboardTab> {
  final Map<String, bool> _expandedIntents = {};

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<FrameMonitorSnapshot?>(
      valueListenable: FrameMonitor.instance.snapshot,
      builder: (context, snapshot, _) {
        if (snapshot == null) {
          return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (kDebugMode) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.25), width: 0.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Colors.orangeAccent, size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CommonText(
                        I18nKeys.appLogs.tr == '日志'
                            ? '当前处于调试模式，渲染耗时偏高。精确测定请在 Profile 模式下运行。'
                            : 'Debug overhead detected. Run in Profile Mode for precise performance metrics.',
                        style: const TextStyle(color: Colors.orangeAccent, fontSize: 10, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            // 1. Large Real-Time FPS Line Chart
            _buildChartSection(snapshot),
            const SizedBox(height: 16),

            // 2. Stats Cards
            _buildStatsGrid(snapshot),
            const SizedBox(height: 16),

            // App Launch baseline monitor section
            _buildLaunchMonitorSection(),
            const SizedBox(height: 16),

            // 3. Structure Trace Records (Pages and Intents)
            _buildTraceLogsSection(),
          ],
        );
      },
    );
  }

  Color _getFpsColor(FrameMonitorSnapshot snapshot) {
    double targetMaxFps = 60.0;
    if (snapshot.recentFrames.isNotEmpty) {
      final budget = snapshot.recentFrames[snapshot.recentFrames.length - 1].vsyncBudgetUs;
      if (budget > 0) {
        targetMaxFps = 1000000.0 / budget;
      }
    }
    final ratio = snapshot.fps / targetMaxFps;
    if (ratio >= 0.9) return Colors.greenAccent;
    if (ratio >= 0.75) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  Widget _buildChartSection(FrameMonitorSnapshot snapshot) {
    final fpsColor = _getFpsColor(snapshot);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CommonText(
                    I18nKeys.fpsTrend.tr,
                    style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: fpsColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: fpsColor.withValues(alpha: 0.3), width: 0.5),
                    ),
                    child: CommonText(
                      '${snapshot.fps.toStringAsFixed(1)} FPS',
                      style: TextStyle(
                        color: fpsColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              CommonText(I18nKeys.targetBudgetAuto.tr, style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(height: 130, child: _FpsLineChart(snapshot: snapshot)),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(FrameMonitorSnapshot snapshot) {
    final worstMs = snapshot.worstFrameUs / 1000.0;

    return Row(
      children: [
        // Jank Count Card
        Expanded(
          child: _buildStatCard(
            I18nKeys.jankStatistics.tr,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatItem(I18nKeys.janksTotal.tr, '${snapshot.jankCount}', Colors.orangeAccent),
                _buildStatItem(I18nKeys.severeJanks.tr, '${snapshot.severeJankCount}', Colors.redAccent),
                _buildStatItem(I18nKeys.worstFrame.tr, '${worstMs.toStringAsFixed(1)} ms', Colors.purpleAccent),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Memory Card
        Expanded(
          child: _buildStatCard(
            I18nKeys.memoryUsage.tr,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  '${snapshot.memoryMB} MB',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const CommonText(
                  'Dart RSS Footprint (Excludes Native Cache)',
                  style: TextStyle(color: Colors.white38, fontSize: 10, height: 1.3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, Widget content) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            title,
            style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          content,
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String val, Color valColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonText(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
          CommonText(
            val,
            style: TextStyle(color: valColor, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTraceLogsSection() {
    return ValueListenableBuilder<List<PerfTraceEntry>>(
      valueListenable: PerfTraceStore.instance.traces,
      builder: (context, traces, _) {
        final filter = widget.traceFilter?.trim() ?? '';
        final filteredTraces = traces.where((t) {
          if (filter.isNotEmpty && t.traceId != filter) return false;
          return true;
        }).toList();

        if (filteredTraces.isEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            alignment: Alignment.center,
            child: CommonText(
              I18nKeys.noTraceRecords.tr,
              style: const TextStyle(color: Colors.white24, fontSize: 11, height: 1.4),
            ),
          );
        }

        // Partition traces into Page Render and Intent Traces
        final pages = filteredTraces.where((t) => t.label == 'Page Render').toList();
        final intents = filteredTraces.where((t) => t.label == 'Intent').toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pages.isNotEmpty) ...[
              CommonSettingsSectionTitle(
                title: I18nKeys.pageRenderTraces.tr,
              ),
              const SizedBox(height: 8),
              _buildPageTracesCard(pages),
              const SizedBox(height: 20),
            ],
            if (intents.isNotEmpty) ...[
              CommonSettingsSectionTitle(
                title: I18nKeys.intentTraces.tr,
              ),
              const SizedBox(height: 8),
              _buildIntentTracesCard(intents),
            ],
          ],
        );
      },
    );
  }

  Widget _buildPageTracesCard(List<PerfTraceEntry> pages) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: pages.length,
        separatorBuilder: (_, _) => const Divider(color: Colors.white10, height: 1),
        itemBuilder: (context, idx) {
          final page = pages[pages.length - 1 - idx];
          final color = _pageLatencyColor(page.totalMs);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.circle, size: 8, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        page.name,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      CommonText(
                        'Trace ID: ${page.traceId}',
                        style: const TextStyle(color: Colors.white24, fontSize: 9),
                      ),
                    ],
                  ),
                ),
                CommonText(
                  '${page.totalMs} ms',
                  style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _pageLatencyColor(int ms) {
    if (ms <= 16) return Colors.greenAccent;
    if (ms <= 32) return Colors.yellowAccent;
    return Colors.redAccent;
  }

  Widget _buildIntentTracesCard(List<PerfTraceEntry> intents) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: intents.length,
        separatorBuilder: (_, _) => const Divider(color: Colors.white10, height: 1),
        itemBuilder: (context, idx) {
          final intent = intents[intents.length - 1 - idx];
          final isExpanded = _expandedIntents[intent.traceId] ?? (widget.traceFilter == intent.traceId);

          return Column(
            children: [
              CommonClickable(
                onTap: () {
                  setState(() {
                    _expandedIntents[intent.traceId] = !isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                        color: Colors.white30,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              intent.name,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            CommonText(
                              'Trace ID: ${intent.traceId}',
                              style: const TextStyle(color: Colors.white24, fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                      CommonText(
                        '${intent.totalMs} ms',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isExpanded) ...[
                Container(
                  padding: const EdgeInsets.only(left: 40, right: 16, bottom: 12),
                  child: Column(
                    children: intent.stages.map((stage) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              '├ ${stage.name}',
                              style: const TextStyle(color: Colors.white38, fontSize: 10),
                            ),
                            CommonText(
                              '${stage.durationMs} ms',
                              style: const TextStyle(color: Colors.white54, fontSize: 10),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildLaunchMonitorSection() {
    return ValueListenableBuilder<LaunchReport?>(
      valueListenable: LaunchMonitor.latestReport,
      builder: (context, report, _) {
        if (report == null) {
          return const SizedBox.shrink();
        }

        final history = LaunchMonitor.getHistory();
        final regressionColor = report.isRegression ? Colors.redAccent : Colors.greenAccent;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonSettingsSectionTitle(
              title: I18nKeys.appLogs.tr == '日志' ? '启动耗时基线监测' : 'App Launch Baseline Monitor',
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        I18nKeys.appLogs.tr == '日志' ? '本次启动总时延' : 'Latest Launch Duration',
                        style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: regressionColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: regressionColor.withValues(alpha: 0.3), width: 0.5),
                        ),
                        child: CommonText(
                          report.isRegression
                              ? (I18nKeys.appLogs.tr == '日志'
                                  ? '性能退化 +${report.regressionAmountMs}ms'
                                  : 'Regression +${report.regressionAmountMs}ms')
                              : (I18nKeys.appLogs.tr == '日志' ? '健康 / 无退化' : 'Healthy / Stable'),
                          style: TextStyle(color: regressionColor, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        '${report.totalMs} ms',
                        style: TextStyle(color: regressionColor, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      CommonText(
                        report.timestamp.toLocal().toString().substring(11, 19),
                        style: const TextStyle(color: Colors.white24, fontSize: 10),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLaunchBreakdownItem(
                          I18nKeys.appLogs.tr == '日志' ? '冷启动引导' : 'Cold Boot', '${report.coldBootMs}ms'),
                      _buildLaunchBreakdownItem(
                          I18nKeys.appLogs.tr == '日志' ? '系统初始化' : 'Services Init', '${report.initMs}ms'),
                      _buildLaunchBreakdownItem(
                          I18nKeys.appLogs.tr == '日志' ? '首帧绘制' : 'First Frame Render', '${report.renderMs}ms'),
                    ],
                  ),
                  if (history.length > 1) ...[
                    const Divider(color: Colors.white10, height: 16),
                    Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        title: CommonText(
                          I18nKeys.appLogs.tr == '日志' ? '历史启动数据统计' : 'Launch History Statistics',
                          style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: history.length,
                            itemBuilder: (context, index) {
                              final item = history[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonText(
                                      'Launch #${history.length - index}',
                                      style: const TextStyle(color: Colors.white38, fontSize: 10),
                                    ),
                                    CommonText(
                                      '${item.totalMs}ms (Boot: ${item.coldBootMs}ms, Init: ${item.initMs}ms, Render: ${item.renderMs}ms)',
                                      style: const TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'monospace'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLaunchBreakdownItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(label, style: const TextStyle(color: Colors.white38, fontSize: 9)),
        const SizedBox(height: 2),
        CommonText(value, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
