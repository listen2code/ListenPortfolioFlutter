import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

enum SkillsViewMode {
  radar,
  list,
}

class SkillsViewModeToggle extends StatelessWidget {
  final SkillsViewMode viewMode;
  final ValueChanged<SkillsViewMode> onViewModeChanged;

  const SkillsViewModeToggle({
    super.key,
    required this.viewMode,
    required this.onViewModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: EdgeInsets.all(3.f),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10.f),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleOption(
            title: I18nKeys.viewModeRadar.tr,
            icon: Icons.radar,
            isSelected: viewMode == SkillsViewMode.radar,
            onTap: () => onViewModeChanged(SkillsViewMode.radar),
          ),
          _ToggleOption(
            title: I18nKeys.viewModeList.tr,
            icon: Icons.format_list_bulleted,
            isSelected: viewMode == SkillsViewMode.list,
            onTap: () => onViewModeChanged(SkillsViewMode.list),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return CommonClickable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7.f),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.f, vertical: 5.f),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(7.f),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13.f,
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 4.f),
            CommonText(
              title,
              style: textTheme.labelSmall?.copyWith(
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
