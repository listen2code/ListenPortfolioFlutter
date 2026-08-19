import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';
import '../../../domain/models/fault_injection_scenario.dart';

class FaultCategorySelector extends StatelessWidget {
  final FaultCategory selectedCategory;
  final ValueChanged<FaultCategory> onCategoryChanged;

  const FaultCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      (FaultCategory.all, I18nKeys.faultAllCategories.tr),
      (FaultCategory.network, I18nKeys.faultCategoryNetwork.tr),
      (FaultCategory.stability, I18nKeys.faultCategoryStability.tr),
      (FaultCategory.performance, I18nKeys.faultCategoryPerformance.tr),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((item) {
          final isSelected = item.$1 == selectedCategory;
          return Padding(
            padding: EdgeInsets.only(right: 8.f),
            child: CommonClickable(
              onTap: () => onCategoryChanged(item.$1),
              borderRadius: BorderRadius.circular(20.f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16.f, vertical: 8.f),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colorScheme.primary
                      : context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20.f),
                  border: Border.all(
                    color: isSelected
                        ? context.colorScheme.primary
                        : context.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: CommonText(
                  item.$2,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? context.colorScheme.onPrimary
                        : context.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
