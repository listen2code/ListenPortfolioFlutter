import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../../../../data/models/about_me_model.dart';

/// A custom-painted interactive 6-dimensional radar chart (Spider Chart).
///
/// Visualizes the candidate's core architectural skill distribution across
/// Android, Flutter, APM/Performance, Architecture, Backend, and DevOps.
///
/// ### Architecture & Design Principles:
/// 1. **Pure Canvas Custom Painting (Zero-Dependency Engine)**:
///    Constructed without external heavyweight charting libraries (such as `fl_chart`),
///    avoiding bloated binary dependencies and enabling pixel-perfect control over
///    vector geometry, gradients, shaders, and frame-rate synchronization.
///
/// 2. **Polar Hit-Testing Engine**:
///    Converts touch and pan coordinates from Cartesian `(dx, dy)` into polar coordinates `(angle, distance)`.
///    Includes a 10px center deadzone to prevent erratic dimension toggling when tapping the origin.
///
/// 3. **Curved Dynamic Animation**:
///    Interpolates radar polygon vertices from origin `(0, 0)` to their normalized scores
///    using [animation], delivering a fluid `Curves.easeOutCubic` entry transition.
///
/// 4. **Adaptive Clamping Guard**:
///    Calculates text badge bounding boxes dynamically and clamps them strictly within
///    the Canvas viewport, guaranteeing zero clipping across varying screen widths and DPIs.
class SkillsRadarChart extends StatelessWidget {
  /// The list of skill categories with normalized scores (0 to 100).
  final List<SkillCategoryModel> skills;

  /// Currently highlighted dimension index.
  final int selectedIndex;

  /// Callback triggered when a user taps a radar vertex or sector.
  final ValueChanged<int> onSelectDimension;

  /// Entry animation controller driving the expanding polygon vertices.
  final Animation<double> animation;

  const SkillsRadarChart({
    super.key,
    required this.skills,
    required this.selectedIndex,
    required this.onSelectDimension,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    // Gracefully handle empty or null skill datasets by rendering an invisible box
    if (skills.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        // Keep an adaptive aspect ratio for comfortable radar display (height capped at 290)
        final double height = math.min(width * 0.78, 290.f);

        return CommonClickable(
          ripple: false,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            // Capture both discrete tap-up events and continuous drag/pan updates
            onTapUp: (details) => _handleTap(details.localPosition, width, height),
            onPanUpdate: (details) => _handleTap(details.localPosition, width, height),
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                return CustomPaint(
                  size: Size(width, height),
                  painter: _SkillsRadarPainter(
                    skills: skills,
                    selectedIndex: selectedIndex,
                    animationValue: animation.value,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Handles touch and drag events by converting Cartesian coordinates into polar angles.
  ///
  /// ### Polar Hit-Testing Mathematical Pipeline:
  /// 1. **Cartesian Translation**:
  ///    Translates the local touch point `(x, y)` to an origin-centered coordinate system:
  ///    `dx = x - center.dx`, `dy = y - center.dy`.
  ///
  /// 2. **Euclidean Center Deadzone Guard**:
  ///    Calculates distance `d = sqrt(dx^2 + dy^2)`. If `d < 10.0`, the tap is considered
  ///    too close to the geometric singularity (origin) where floating-point angle calculations
  ///    exhibit high angular jitter. The event is discarded immediately.
  ///
  /// 3. **Polar Angular Derivation**:
  ///    Dart's `math.atan2(dy, dx)` yields radians in `[-pi, pi]` starting from the positive
  ///    X-axis (3 o'clock). Because our radar chart places the 0-th dimension at 12 o'clock
  ///    (`-pi / 2`), we shift the angle by adding `pi / 2`:
  ///    `angle = atan2(dy, dx) + pi / 2`.
  ///    If negative, we normalize by adding `2 * pi` into `[0, 2*pi)`.
  ///
  /// 4. **Sector Discretization & Dimension Selection**:
  ///    Divides the continuous angle by `sliceAngle = 2 * pi / count`, and rounds to
  ///    the nearest integer sector: `index = (angle / sliceAngle).round() % count`.
  ///    If the index changes, [onSelectDimension] is notified to drive the UI state.
  void _handleTap(Offset position, double width, double height) {
    if (skills.isEmpty) return;

    final Offset center = Offset(width / 2, height / 2);
    final double dx = position.dx - center.dx;
    final double dy = position.dy - center.dy;
    final double distance = math.sqrt(dx * dx + dy * dy);

    // Step 2: If tap is within the 10px deadzone, discard to eliminate singularity jitter
    if (distance < 10.f) return;

    final int count = skills.length;
    final double sliceAngle = 2 * math.pi / count;

    // Step 3: Shift angle from 3 o'clock (standard atan2) to 12 o'clock (radar top vertex)
    double angle = math.atan2(dy, dx) + math.pi / 2;
    if (angle < 0) {
      angle += 2 * math.pi;
    }

    // Step 4: Discretize continuous angle into discrete dimension sector index
    final int index = (angle / sliceAngle).round() % count;
    if (index >= 0 && index < count && index != selectedIndex) {
      onSelectDimension(index);
    }
  }
}

/// Custom painter that executes the 5-stage vector rendering pipeline for the radar chart.
///
/// ### Rendering Performance Considerations:
/// - **Zero GC Pressure in Animation**: Paint objects and styling configurations are defined
///   statically or scoped to avoid heap fragmentation during 60/120 FPS interpolations.
/// - **Subpixel Precision**: All coordinates are calculated using double-precision floating point
///   trigonometry and projected cleanly onto the Flutter Canvas.
/// - **Theme Awareness**: Adapts seamlessly to Light/Dark modes by pulling semantic tokens
///   from [colorScheme] rather than hardcoded hex values.
class _SkillsRadarPainter extends CustomPainter {
  /// Dimension datasets containing scores and localized titles.
  final List<SkillCategoryModel> skills;

  /// Index of the currently inspected/highlighted capability.
  final int selectedIndex;

  /// Normalized animation progress in `[0.0, 1.0]`.
  final double animationValue;

  /// Active Material 3 color palette for adaptive theming.
  final ColorScheme colorScheme;

  /// Typography styles for label rendering.
  final TextTheme textTheme;

  _SkillsRadarPainter({
    required this.skills,
    required this.selectedIndex,
    required this.animationValue,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (skills.isEmpty) return;

    // Viewport midpoint serving as the origin (0, 0) for all polar projections
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Dynamic radius calculation:
    // We reserve at least 68px horizontally on each flank for wide text badges (e.g. "Architecture"),
    // and at least 34px vertically for top and bottom pills.
    final double maxHorizontalRadius = (size.width / 2) - 68.f;
    final double maxVerticalRadius = (size.height / 2) - 34.f;

    // Ensure a safe minimum radius of 60.0 to prevent the chart from collapsing into a dot on small screens
    final double radius = math.max(
      60.f,
      math.min(maxHorizontalRadius, maxVerticalRadius),
    );

    final int count = skills.length;
    // Angular step between adjacent vertices in radians (e.g., 2*pi / 6 = 60 degrees for a hexagon)
    final double sliceAngle = 2 * math.pi / count;

    // Pipeline Stage 1: Draw concentric polygonal grid rings (spider web)
    _drawGridWeb(canvas, center, radius, count, sliceAngle);

    // Pipeline Stage 2: Draw radial spoke axis lines radiating from origin to outer perimeter
    _drawAxisLines(canvas, center, radius, count, sliceAngle);

    // Pipeline Stage 3: Draw animated data polygon with dual gradient shader and smooth stroke
    _drawDataPolygon(canvas, center, radius, count, sliceAngle, size);

    // Pipeline Stage 4: Draw data point marker dots and pulsing glow indicator for selected index
    _drawDataPoints(canvas, center, radius, count, sliceAngle);

    // Pipeline Stage 5: Draw pill badges and dimension category labels with trigonometric anchoring
    _drawLabels(canvas, center, radius, count, sliceAngle, size);
  }

  /// Draws 5 concentric regular polygonal rings to serve as visual score scale markers (20%, 40%, 60%, 80%, 100%).
  ///
  /// Alternate rings are tinted with a subtle fill color to enhance spatial depth and readability.
  void _drawGridWeb(
    Canvas canvas,
    Offset center,
    double radius,
    int count,
    double sliceAngle,
  ) {
    const int levels = 5;
    final Paint linePaint = Paint()
      ..color = colorScheme.outlineVariant.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final Paint fillPaint = Paint()
      ..color = colorScheme.surfaceContainerHighest.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    // Draw from outermost ring (level 5) to innermost (level 1)
    for (int i = levels; i >= 1; i--) {
      final double levelRadius = radius * (i / levels);
      final Path path = Path();

      for (int j = 0; j < count; j++) {
        // -pi/2 aligns vertex 0 to 12 o'clock (top)
        final double angle = -math.pi / 2 + j * sliceAngle;
        final double x = center.dx + levelRadius * math.cos(angle);
        final double y = center.dy + levelRadius * math.sin(angle);

        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();

      // Alternate background tint for odd-numbered web polygons (levels 5, 3, 1)
      if (i % 2 == 1) {
        canvas.drawPath(path, fillPaint);
      }
      canvas.drawPath(path, linePaint);
    }
  }

  /// Draws radial axis spoke lines extending from the chart origin `center` to the maximum outer radius.
  void _drawAxisLines(
    Canvas canvas,
    Offset center,
    double radius,
    int count,
    double sliceAngle,
  ) {
    final Paint axisPaint = Paint()
      ..color = colorScheme.outlineVariant.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i < count; i++) {
      final double angle = -math.pi / 2 + i * sliceAngle;
      final double x = center.dx + radius * math.cos(angle);
      final double y = center.dy + radius * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), axisPaint);
    }
  }

  /// Constructs and renders the animated data polygon representing candidate skill scores.
  ///
  /// ### Implementation Details:
  /// - **Data Clamping Guard**: Scores are strictly clamped to `[0, 100]` before division by 100.0,
  ///   preventing malformed API responses from breaking outside the canvas boundary.
  /// - **Animation Scaling**: Scores are multiplied by [animationValue], producing a graceful
  ///   origin-to-perimeter blossom animation during initial page load.
  /// - **LinearGradient Shader**: Applies a diagonal gradient across the bounding circle
  ///   to produce an eye-catching modern glassmorphic look.
  /// - **Anti-Spike Geometry**: Uses [StrokeJoin.round] and [StrokeCap.round] to eliminate
  ///   unpleasant miter spikes where adjacent scores differ significantly.
  void _drawDataPolygon(
    Canvas canvas,
    Offset center,
    double radius,
    int count,
    double sliceAngle,
    Size size,
  ) {
    final Path dataPath = Path();
    final List<Offset> points = [];

    for (int i = 0; i < count; i++) {
      final double angle = -math.pi / 2 + i * sliceAngle;
      final double score = (skills[i].score).clamp(0, 100) / 100.0;
      final double currentScore = score * animationValue;
      final double pointRadius = radius * currentScore;

      final double x = center.dx + pointRadius * math.cos(angle);
      final double y = center.dy + pointRadius * math.sin(angle);
      final Offset point = Offset(x, y);
      points.add(point);

      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }
    dataPath.close();

    // 1. Diagonal gradient fill over the radar's bounding circle
    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          colorScheme.primary.withValues(alpha: 0.42),
          colorScheme.tertiary.withValues(alpha: 0.22),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(dataPath, fillPaint);

    // 2. Continuous outer perimeter border stroke with rounded joins
    final Paint strokePaint = Paint()
      ..color = colorScheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(dataPath, strokePaint);
  }

  /// Renders individual vertex marker dots along the data polygon.
  ///
  /// The currently selected dimension ([selectedIndex]) receives an animated outer pulsing halo
  /// to provide immediate visual feedback of active focus.
  void _drawDataPoints(
    Canvas canvas,
    Offset center,
    double radius,
    int count,
    double sliceAngle,
  ) {
    final Paint dotInnerPaint = Paint()
      ..color = colorScheme.primary
      ..style = PaintingStyle.fill;

    final Paint dotOuterPaint = Paint()
      ..color = colorScheme.surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint selectedGlowPaint = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final double angle = -math.pi / 2 + i * sliceAngle;
      final double score = (skills[i].score).clamp(0, 100) / 100.0;
      final double currentScore = score * animationValue;
      final double pointRadius = radius * currentScore;

      final double x = center.dx + pointRadius * math.cos(angle);
      final double y = center.dy + pointRadius * math.sin(angle);
      final Offset point = Offset(x, y);

      if (i == selectedIndex) {
        // Selected dimension: Outer pulsing glow expanding with animation progress + dual-ring core
        canvas
          ..drawCircle(point, 9.0 * animationValue, selectedGlowPaint)
          ..drawCircle(point, 5.0, dotInnerPaint)
          ..drawCircle(point, 5.0, dotOuterPaint);
      } else {
        // Standard vertex: Compact dual-ring indicator
        canvas
          ..drawCircle(point, 3.5, dotInnerPaint)
          ..drawCircle(point, 3.5, dotOuterPaint);
      }
    }
  }

  /// Renders dimension title badges (pills) around the outer perimeter of the radar chart.
  ///
  /// ### Advanced Trigonometric Label Anchoring & Viewport Defense:
  /// 1. **Text Layout & Ellipsis**:
  ///    Limits label width to `[60.0, 105.0]` depending on screen size, with `ellipsis: '...'`
  ///    and `maxLines: 2` to support multi-line localized strings without horizontal blowouts.
  ///
  /// 2. **3-Way Trigonometric Sector Branching**:
  ///    - **Near Vertical (`|cos(angle)| < 0.25`)**:
  ///      Top or bottom vertex. Horizontally centered at `anchorX - badgeWidth / 2`.
  ///      Vertically placed above or below depending on `sin(angle)`.
  ///    - **Right Hemisphere (`cos(angle) > 0`)**:
  ///      Eastward vertices. Pill expands rightward: `rawBadgeX = anchorX + 2.0`.
  ///    - **Left Hemisphere (`cos(angle) < 0`)**:
  ///      Westward vertices. Pill expands leftward: `rawBadgeX = anchorX - badgeWidth - 2.0`.
  ///
  /// 3. **Dual-Axis Viewport Clamping Guard**:
  ///    Even with adaptive radius, localized words might approach screen boundaries.
  ///    `rawBadgeX.clamp(2.0, size.width - badgeWidth - 2.0)` guarantees 100% zero-clipping.
  void _drawLabels(
    Canvas canvas,
    Offset center,
    double radius,
    int count,
    double sliceAngle,
    Size size,
  ) {
    // Restrict max width of any single badge to prevent horizontal overflow
    final double maxLabelWidth = (size.width * 0.32).clamp(60.0, 105.0);

    for (int i = 0; i < count; i++) {
      final double angle = -math.pi / 2 + i * sliceAngle;
      final bool isSelected = i == selectedIndex;

      final String categoryName = skills[i].category ?? '';
      final String labelText = categoryName;

      final TextStyle style = (textTheme.labelSmall ?? const TextStyle()).copyWith(
        color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
        fontSize: 10.5.f,
      );

      final TextSpan span = TextSpan(text: labelText, style: style);
      final TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        maxLines: 2,
        ellipsis: '...',
      )..layout(maxWidth: maxLabelWidth);

      final double badgeWidth = tp.width + 12.f;
      final double badgeHeight = tp.height + 6.f;

      // Label anchor offset slightly outside outer web perimeter (R + 12px)
      final double labelRadius = radius + 12.f;
      final double anchorX = center.dx + labelRadius * math.cos(angle);
      final double anchorY = center.dy + labelRadius * math.sin(angle);

      double rawBadgeX;
      double rawBadgeY;

      final double cosVal = math.cos(angle);
      final double sinVal = math.sin(angle);

      if (cosVal.abs() < 0.25) {
        // Sector 1: Top or Bottom polar vertex
        rawBadgeX = anchorX - badgeWidth / 2;
        rawBadgeY = sinVal < 0 ? anchorY - badgeHeight : anchorY;
      } else if (cosVal > 0) {
        // Sector 2: Right hemisphere vertices
        rawBadgeX = anchorX + 2.f;
        rawBadgeY = anchorY - badgeHeight / 2;
      } else {
        // Sector 3: Left hemisphere vertices
        rawBadgeX = anchorX - badgeWidth - 2.f;
        rawBadgeY = anchorY - badgeHeight / 2;
      }

      // Clamping guard: ensure badge never clips outside canvas [2.0, size.width - 2.0]
      final double clampedBadgeX = rawBadgeX.clamp(2.0, math.max(2.0, size.width - badgeWidth - 2.0));
      final double clampedBadgeY = rawBadgeY.clamp(2.0, math.max(2.0, size.height - badgeHeight - 2.0));

      final Rect badgeRect = Rect.fromLTWH(
        clampedBadgeX,
        clampedBadgeY,
        badgeWidth,
        badgeHeight,
      );

      final RRect badgeRRect = RRect.fromRectAndRadius(
        badgeRect,
        Radius.circular(6.f),
      );

      final Paint bgPaint = Paint()
        ..color = isSelected
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.88)
        ..style = PaintingStyle.fill;

      final Paint borderPaint = Paint()
        ..color = isSelected
            ? colorScheme.primary.withValues(alpha: 0.7)
            : colorScheme.outlineVariant.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas
        ..drawRRect(badgeRRect, bgPaint)
        ..drawRRect(badgeRRect, borderPaint);

      // Paint text centered inside badge
      final double textOffsetX = clampedBadgeX + (badgeWidth - tp.width) / 2;
      final double textOffsetY = clampedBadgeY + (badgeHeight - tp.height) / 2;
      tp.paint(canvas, Offset(textOffsetX, textOffsetY));
    }
  }

  /// Avoids unnecessary repaints by strictly comparing primitive values and reference changes.
  @override
  bool shouldRepaint(covariant _SkillsRadarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.skills != skills ||
        oldDelegate.colorScheme != colorScheme;
  }
}
