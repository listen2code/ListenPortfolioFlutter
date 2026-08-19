import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../shared/shared.dart';
import '../../domain/models/fault_injection_scenario.dart';
import 'fault_injection_intent.dart';
import 'fault_injection_state.dart';
import 'fault_injection_view_model.dart';
import 'widgets/fault_category_selector.dart';
import 'widgets/fault_execution_console.dart';
import 'widgets/fault_scenario_card.dart';

class FaultInjectionPage extends ConsumerWidget {
  const FaultInjectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRefreshPage<FaultInjectionViewModel, FaultInjectionState>(
      title: I18nKeys.faultInjectionPlayground.tr,
      provider: faultInjectionViewModelProvider,
      actions: [
        CommonIconButton(
          icon: const Icon(Icons.restart_alt_rounded),
          onPressed: () {
            ref.read(faultInjectionViewModelProvider.notifier).handleIntent(
                  const FaultInjectionIntent.resetAll(),
                );
          },
          tooltip: I18nKeys.faultResetAll.tr,
        ),
      ],
      body: (context, child, viewModel, state) {
        final filteredScenarios = state.selectedCategory == FaultCategory.all
            ? state.scenarios
            : state.scenarios.where((s) => s.category == state.selectedCategory).toList();

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.f),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Summary Banner (Total Runs, Recovered, Safe Mode State)
              _buildStatsBanner(context, state),

              SizedBox(height: 16.f),

              // 2. Category Filter Tabs
              FaultCategorySelector(
                selectedCategory: state.selectedCategory,
                onCategoryChanged: (cat) {
                  viewModel.handleIntent(FaultInjectionIntent.selectCategory(cat));
                },
              ),

              SizedBox(height: 16.f),

              // 3. Scenario Cards List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredScenarios.length,
                separatorBuilder: (_, _) => SizedBox(height: 12.f),
                itemBuilder: (context, index) {
                  final scenario = filteredScenarios[index];
                  final isRunning = state.runningType == scenario.type;

                  return FaultScenarioCard(
                    scenario: scenario,
                    isRunning: isRunning,
                    onRun: () {
                      viewModel.handleIntent(FaultInjectionIntent.runScenario(scenario.type));
                    },
                  );
                },
              ),

              SizedBox(height: 20.f),

              // 4. Live Execution Console & Trace Inspector
              FaultExecutionConsole(
                logs: state.consoleLogs,
                activeTraceId: state.activeTraceId,
                onClear: () {
                  viewModel.handleIntent(const FaultInjectionIntent.clearConsole());
                },
                onCopyTrace: (traceId) {
                  viewModel.handleIntent(FaultInjectionIntent.copyTraceId(traceId));
                },
                onDrillTrace: (traceId) {
                  viewModel.handleIntent(FaultInjectionIntent.drillTrace(traceId));
                  if (context.mounted) {
                    LogOverlayManager.show(context, startExpanded: true);
                  }
                },
              ),

              SizedBox(height: 24.f),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsBanner(BuildContext context, FaultInjectionState state) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colorScheme.primaryContainer.withValues(alpha: 0.7),
            context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.f),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      padding: EdgeInsets.all(16.f),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.health_and_safety_outlined,
                color: context.colorScheme.primary,
                size: 22.f,
              ),
              SizedBox(width: 8.f),
              Expanded(
                child: CommonText(
                  I18nKeys.faultInjectionSubtitle.tr,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.f),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                title: I18nKeys.faultRunScenario.tr,
                value: '${state.totalRuns}',
                icon: Icons.play_circle_outline_rounded,
                color: context.colorScheme.primary,
              ),
              _buildStatItem(
                context,
                title: I18nKeys.faultRecovered.tr,
                value: '${state.recoveredCount}',
                icon: Icons.verified_user_outlined,
                color: context.colorScheme.secondary,
              ),
              _buildStatItem(
                context,
                title: I18nKeys.faultScenarioSafeModeTitle.tr,
                value: state.isSafeModeTriggered ? 'Active' : 'Standby',
                icon: Icons.shield_outlined,
                color: state.isSafeModeTriggered ? context.colorScheme.error : context.colorScheme.outline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.f, color: color),
            SizedBox(width: 4.f),
            CommonText(
              value,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.f),
        CommonText(
          title,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
