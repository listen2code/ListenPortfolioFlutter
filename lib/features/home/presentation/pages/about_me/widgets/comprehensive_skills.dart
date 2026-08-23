import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../../../../data/models/about_me_model.dart';
import 'skill_category_card.dart';
import 'skills_inspector_detail_card.dart';
import 'skills_radar_chart.dart';
import 'skills_view_mode_toggle.dart';

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
  bool _isProgrammaticScroll = false;

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
    if (_selectedDimensionIndex == index &&
        _pageController.hasClients &&
        _pageController.page?.round() == index) {
      return;
    }

    setState(() {
      _selectedDimensionIndex = index;
    });
    _scrollToChip(index);

    if (_pageController.hasClients && _pageController.page?.round() != index) {
      _isProgrammaticScroll = true;
      _pageController
          .animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
          )
          .then((_) {
            if (mounted) {
              _isProgrammaticScroll = false;
            }
          });
    }
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
            SkillsViewModeToggle(
              viewMode: _viewMode,
              onViewModeChanged: (mode) {
                if (_viewMode != mode) {
                  setState(() {
                    _viewMode = mode;
                  });
                  if (mode == SkillsViewMode.radar) {
                    _animController.forward(from: 0.0);
                  }
                }
              },
            ),
          ],
        ),
        SizedBox(height: 16.f),

        // 2. Body based on selected View Mode
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _viewMode == SkillsViewMode.radar
              ? _buildRadarModeView(context, safeIndex)
              : _buildListModeView(context),
        ),
      ],
    );
  }

  Widget _buildRadarModeView(BuildContext context, int activeIndex) {
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
          _buildQuickSwitcherChips(colorScheme, textTheme, activeIndex),
          SizedBox(height: 14.f),

          // Inspector Detail Card with Left/Right Swipe Support
          SizedBox(
            height: 215.f,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollStartNotification &&
                    notification.dragDetails != null) {
                  _isProgrammaticScroll = false;
                }
                return false;
              },
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.skills.length,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  if (_isProgrammaticScroll) {
                    if (index == _selectedDimensionIndex) {
                      _isProgrammaticScroll = false;
                    }
                    return;
                  }
                  if (_selectedDimensionIndex != index) {
                    setState(() {
                      _selectedDimensionIndex = index;
                    });
                    _scrollToChip(index);
                  }
                },
                itemBuilder: (context, index) {
                  final category = widget.skills[index];
                  return SkillsInspectorDetailCard(
                    category: category,
                    index: index,
                    totalCount: widget.skills.length,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSwitcherChips(
    ColorScheme colorScheme,
    TextTheme textTheme,
    int activeIndex,
  ) {
    return SingleChildScrollView(
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
    );
  }

  Widget _buildListModeView(BuildContext context) {
    return Column(
      key: const ValueKey('list_mode'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.skills.map((s) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.f),
          child: SkillCategoryCard(category: s),
        );
      }).toList(),
    );
  }
}
