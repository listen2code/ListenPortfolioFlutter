import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';
import '../../../domain/models/fault_injection_scenario.dart';

class FaultScenarioCard extends StatelessWidget {
  final FaultScenarioModel scenario;
  final bool isRunning;
  final VoidCallback onRun;

  const FaultScenarioCard({
    super.key,
    required this.scenario,
    required this.isRunning,
    required this.onRun,
  });

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusBg, statusFg, statusIcon) = _getStatusMeta(context, scenario.status);
    final (categoryLabel, categoryBg, categoryFg) = _getCategoryMeta(context, scenario.category);

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.f),
        border: Border.all(
          color: scenario.status == ScenarioStatus.running
              ? context.colorScheme.primary
              : context.colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: scenario.status == ScenarioStatus.running ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 10.f,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.f),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Category Badge + Status Badge + Latency
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 4.f),
                decoration: BoxDecoration(
                  color: categoryBg,
                  borderRadius: BorderRadius.circular(6.f),
                ),
                child: CommonText(
                  categoryLabel,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: categoryFg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8.f),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 4.f),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6.f),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 12.f, color: statusFg),
                    SizedBox(width: 4.f),
                    CommonText(
                      statusLabel,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: statusFg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (scenario.lastExecutionDurationMs != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.f, vertical: 2.f),
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4.f),
                  ),
                  child: CommonText(
                    '${scenario.lastExecutionDurationMs}ms',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 12.f),

          // Title & Description (Wrapped with Expanded / maxLines protection)
          CommonText(
            scenario.titleKey.tr,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.f),
          CommonText(
            scenario.descKey.tr,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),

          SizedBox(height: 16.f),

          // Bottom Action Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CommonButton(
                height: 38.f,
                width: 120.f,
                isLoading: isRunning,
                text: isRunning ? I18nKeys.faultRunning.tr : I18nKeys.faultRunScenario.tr,
                onPressed: isRunning ? null : onRun,
              ),
            ],
          ),
        ],
      ),
    );
  }

  (String, Color, Color) _getCategoryMeta(BuildContext context, FaultCategory category) {
    switch (category) {
      case FaultCategory.network:
        return (
          I18nKeys.faultCategoryNetwork.tr,
          context.colorScheme.primaryContainer.withValues(alpha: 0.6),
          context.colorScheme.onPrimaryContainer,
        );
      case FaultCategory.stability:
        return (
          I18nKeys.faultCategoryStability.tr,
          context.colorScheme.errorContainer.withValues(alpha: 0.6),
          context.colorScheme.onErrorContainer,
        );
      case FaultCategory.performance:
        return (
          I18nKeys.faultCategoryPerformance.tr,
          context.colorScheme.tertiaryContainer.withValues(alpha: 0.6),
          context.colorScheme.onTertiaryContainer,
        );
      case FaultCategory.all:
        return (
          I18nKeys.faultAllCategories.tr,
          context.colorScheme.surfaceContainerHighest,
          context.colorScheme.onSurfaceVariant,
        );
    }
  }

  (String, Color, Color, IconData) _getStatusMeta(BuildContext context, ScenarioStatus status) {
    switch (status) {
      case ScenarioStatus.idle:
        return (
          I18nKeys.faultStatusIdle.tr,
          context.colorScheme.surfaceContainerHighest,
          context.colorScheme.onSurfaceVariant,
          Icons.circle_outlined,
        );
      case ScenarioStatus.running:
        return (
          I18nKeys.faultRunning.tr,
          context.colorScheme.primaryContainer,
          context.colorScheme.primary,
          Icons.sync_rounded,
        );
      case ScenarioStatus.recovered:
        return (
          I18nKeys.faultRecovered.tr,
          context.colorScheme.secondaryContainer,
          context.colorScheme.secondary,
          Icons.shield_outlined,
        );
      case ScenarioStatus.success:
        return (
          I18nKeys.faultSuccess.tr,
          context.colorScheme.primaryContainer,
          context.colorScheme.primary,
          Icons.check_circle_outline_rounded,
        );
      case ScenarioStatus.failed:
        return (
          I18nKeys.faultFailed.tr,
          context.colorScheme.errorContainer,
          context.colorScheme.error,
          Icons.error_outline_rounded,
        );
    }
  }
}
