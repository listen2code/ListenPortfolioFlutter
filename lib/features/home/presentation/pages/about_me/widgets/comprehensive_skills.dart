import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../../../../data/models/about_me_model.dart';
import 'skills_radar_chart.dart';

enum SkillsViewMode {
  radar,
  list,
}

class ComprehensiveSkills extends StatefulWidget {
  final List<SkillCategoryModel> skills;

  const ComprehensiveSkills({super.key, required this.skills});

  @override
  State<ComprehensiveSkills> createState() => _ComprehensiveSkillsState();
}

class _ComprehensiveSkillsState extends State<ComprehensiveSkills>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _curveAnimation;

  SkillsViewMode _viewMode = SkillsViewMode.radar;
  int _selectedDimensionIndex = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _curveAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant ComprehensiveSkills oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.skills != widget.skills) {
      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  int get _totalSkillsCount {
    int count = 0;
    for (final s in widget.skills) {
      count += s.items.length;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.skills.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final safeIndex = _selectedDimensionIndex.clamp(0, widget.skills.length - 1);
    final selectedCategory = widget.skills[safeIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Header with Title, Count Badge and View Mode Switcher
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  CommonSectionHeader(
                    title: I18nKeys.coreSkills.tr,
                    showVerticalBar: true,
                  ),
                  SizedBox(width: 8.f),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 3.f),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.f),
                    ),
                    child: CommonText(
                      I18nKeys.allSkillsCount.trArgs(['$_totalSkillsCount']),
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildViewModeToggle(colorScheme, textTheme),
          ],
        ),
        SizedBox(height: 16.f),

        // 2. Body based on selected View Mode
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _viewMode == SkillsViewMode.radar
              ? _buildRadarModeView(context, selectedCategory, safeIndex)
              : _buildListModeView(context),
        ),
      ],
    );
  }

  Widget _buildViewModeToggle(ColorScheme colorScheme, TextTheme textTheme) {
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
          _buildToggleOption(
            title: I18nKeys.viewModeRadar.tr,
            icon: Icons.radar,
            isSelected: _viewMode == SkillsViewMode.radar,
            onTap: () {
              if (_viewMode != SkillsViewMode.radar) {
                setState(() {
                  _viewMode = SkillsViewMode.radar;
                });
                _animController.forward(from: 0.0);
              }
            },
          ),
          _buildToggleOption(
            title: I18nKeys.viewModeList.tr,
            icon: Icons.format_list_bulleted,
            isSelected: _viewMode == SkillsViewMode.list,
            onTap: () {
              if (_viewMode != SkillsViewMode.list) {
                setState(() {
                  _viewMode = SkillsViewMode.list;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return CommonClickable(
      onTap: onTap,
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

  Widget _buildRadarModeView(
    BuildContext context,
    SkillCategoryModel selectedCategory,
    int activeIndex,
  ) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Container(
      key: const ValueKey('radar_mode'),
      padding: EdgeInsets.all(16.f),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16.f),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle & Tap prompt
          Row(
            children: [
              Icon(
                Icons.touch_app_outlined,
                size: 14.f,
                color: colorScheme.primary,
              ),
              SizedBox(width: 6.f),
              Expanded(
                child: CommonText(
                  I18nKeys.tapToInspectDimension.tr,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.f),

          // Custom Radar Chart Canvas
          SkillsRadarChart(
            skills: widget.skills,
            selectedIndex: activeIndex,
            onSelectDimension: (index) {
              setState(() {
                _selectedDimensionIndex = index;
              });
            },
            animation: _curveAnimation,
          ),
          SizedBox(height: 16.f),

          // Dimension Quick Switcher Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(widget.skills.length, (i) {
                final category = widget.skills[i];
                final bool isSelected = i == activeIndex;

                return Padding(
                  padding: EdgeInsets.only(right: 8.f),
                  child: CommonClickable(
                    onTap: () {
                      setState(() {
                        _selectedDimensionIndex = i;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.f, vertical: 6.f),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12.f),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary.withValues(alpha: 0.8)
                              : colorScheme.outlineVariant.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonText(
                            category.category ?? '',
                            style: textTheme.labelSmall?.copyWith(
                              color: isSelected
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          SizedBox(width: 4.f),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.f, vertical: 1.f),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(6.f),
                            ),
                            child: CommonText(
                              '${category.score}',
                              style: textTheme.labelSmall?.copyWith(
                                color: isSelected
                                    ? colorScheme.onPrimary
                                    : colorScheme.onSurfaceVariant,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 14.f),

          // Inspector Detail Card for Selected Dimension
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.f),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12.f),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Category Title and Score Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CommonText(
                        selectedCategory.category ?? '',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.f),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 3.f),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.f),
                      ),
                      child: CommonText(
                        I18nKeys.skillScore.trArgs(['${selectedCategory.score}']),
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.f),

                // Animated Score Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.f),
                  child: LinearProgressIndicator(
                    value: (selectedCategory.score / 100.0).clamp(0.0, 1.0),
                    minHeight: 6.f,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  ),
                ),
                SizedBox(height: 12.f),

                // Skill Tag Chips
                Wrap(
                  spacing: 8.f,
                  runSpacing: 8.f,
                  children: selectedCategory.items.map((skillItem) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.f, vertical: 5.f),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8.f),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                        ),
                      ),
                      child: CommonText(
                        skillItem,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListModeView(BuildContext context) {
    return Column(
      key: const ValueKey('list_mode'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.skills.map((s) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.f),
          child: _buildSkillCategoryCard(context, s),
        );
      }).toList(),
    );
  }

  Widget _buildSkillCategoryCard(BuildContext context, SkillCategoryModel category) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.f),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12.f),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CommonText(
                  category.category ?? '',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.f),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 3.f),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.f),
                ),
                child: CommonText(
                  '${category.score} pts',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.f),
          Wrap(
            spacing: 8.f,
            runSpacing: 8.f,
            children: category.items.map((item) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.f, vertical: 5.f),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.f),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                  ),
                ),
                child: CommonText(
                  item,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
