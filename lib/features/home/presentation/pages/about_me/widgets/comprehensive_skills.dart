import 'package:flutter/material.dart';
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
  late final PageController _pageController;
  final ScrollController _chipsScrollController = ScrollController();

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
    _pageController = PageController(initialPage: _selectedDimensionIndex);
    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant ComprehensiveSkills oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.skills != widget.skills) {
      _animController.forward(from: 0.0);
      if (_selectedDimensionIndex >= widget.skills.length) {
        _selectedDimensionIndex = 0;
      }
      if (_pageController.hasClients && _pageController.page?.round() != _selectedDimensionIndex) {
        _pageController.jumpToPage(_selectedDimensionIndex);
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _pageController.dispose();
    _chipsScrollController.dispose();
    super.dispose();
  }

  void _onSelectDimension(int index) {
    if (index < 0 || index >= widget.skills.length) return;
    setState(() {
      _selectedDimensionIndex = index;
    });
    if (_pageController.hasClients && _pageController.page?.round() != index) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
    _scrollToChip(index);
  }

  void _scrollToChip(int index) {
    if (!_chipsScrollController.hasClients) return;
    const double approxChipWidth = 115.0;
    final double targetOffset = (index * approxChipWidth - 40.0).clamp(
      0.0,
      _chipsScrollController.position.maxScrollExtent,
    );
    _chipsScrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
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
            onSelectDimension: _onSelectDimension,
            animation: _curveAnimation,
          ),
          SizedBox(height: 16.f),

          // Dimension Quick Switcher Chips
          SingleChildScrollView(
            controller: _chipsScrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(widget.skills.length, (i) {
                final category = widget.skills[i];
                final bool isSelected = i == activeIndex;

                return Padding(
                  padding: EdgeInsets.only(right: 8.f),
                  child: CommonClickable(
                    onTap: () => _onSelectDimension(i),
                    borderRadius: BorderRadius.circular(12.f),
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

          // Inspector Detail Card with Left/Right Swipe Support (Optimized height & compact chips)
          SizedBox(
            height: 215.f,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.skills.length,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                if (_selectedDimensionIndex != index) {
                  setState(() {
                    _selectedDimensionIndex = index;
                  });
                  _scrollToChip(index);
                }
              },
              itemBuilder: (context, index) {
                final category = widget.skills[index];
                return _buildInspectorDetailCard(context, category, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectorDetailCard(
    BuildContext context,
    SkillCategoryModel category,
    int index,
  ) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.f),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.f),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Category Title, Pagination Indicator and Score Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: CommonText(
                        category.category ?? '',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 6.f),
                    CommonText(
                      '(${index + 1}/${widget.skills.length})',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                        fontSize: 10.f,
                      ),
                    ),
                  ],
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
                  I18nKeys.skillScore.trArgs(['${category.score}']),
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.f),

          // Animated Score Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4.f),
            child: LinearProgressIndicator(
              value: (category.score / 100.0).clamp(0.0, 1.0),
              minHeight: 5.f,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          SizedBox(height: 10.f),

          // Compact Skill Tag Chips (Multi-tag layout optimization)
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Wrap(
                spacing: 6.f,
                runSpacing: 6.f,
                children: category.items.map((skillItem) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 4.f),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6.f),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                      ),
                    ),
                    child: CommonText(
                      skillItem,
                      style: textTheme.labelSmall?.copyWith(
                        fontSize: 10.5.f,
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
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
      padding: EdgeInsets.all(12.f),
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
          SizedBox(height: 8.f),
          Wrap(
            spacing: 6.f,
            runSpacing: 6.f,
            children: category.items.map((item) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8.f, vertical: 4.f),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(6.f),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                  ),
                ),
                child: CommonText(
                  item,
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 10.5.f,
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
