import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../../../../data/models/about_me_model.dart';

class SkillsRadarChart extends StatelessWidget {
  final List<SkillCategoryModel> skills;
  final int selectedIndex;
  final ValueChanged<int> onSelectDimension;
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
    if (skills.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        // Keep an adaptive aspect ratio for comfortable radar display
        final double height = math.min(width * 0.85, 320.f);

        return CommonClickable(
          ripple: false,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
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

  void _handleTap(Offset position, double width, double height) {
    if (skills.isEmpty) return;

    final Offset center = Offset(width / 2, height / 2);
    final double dx = position.dx - center.dx;
    final double dy = position.dy - center.dy;
    final double distance = math.sqrt(dx * dx + dy * dy);

    // If tap is too close to center, ignore
    if (distance < 10.f) return;

    final int count = skills.length;
    final double sliceAngle = 2 * math.pi / count;

    // Angle starts from top (-pi / 2)
    double angle = math.atan2(dy, dx) + math.pi / 2;
    if (angle < 0) {
      angle += 2 * math.pi;
    }

    final int index = (angle / sliceAngle).round() % count;
    if (index >= 0 && index < count && index != selectedIndex) {
      onSelectDimension(index);
    }
  }
}

class _SkillsRadarPainter extends CustomPainter {
  final List<SkillCategoryModel> skills;
  final int selectedIndex;
  final double animationValue;
  final ColorScheme colorScheme;
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

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width, size.height) / 2 * 0.68;
    final int count = skills.length;
    final double sliceAngle = 2 * math.pi / count;

    // 1. Draw web grid levels (5 concentric polygon rings)
    _drawGridWeb(canvas, center, radius, count, sliceAngle);

    // 2. Draw radial axis lines from center
    _drawAxisLines(canvas, center, radius, count, sliceAngle);

    // 3. Draw animated data polygon with gradient fill and stroke
    _drawDataPolygon(canvas, center, radius, count, sliceAngle, size);

    // 4. Draw data point dots & active indicator
    _drawDataPoints(canvas, center, radius, count, sliceAngle);

    // 5. Draw axis labels with pill badges
    _drawLabels(canvas, center, radius, count, sliceAngle);
  }

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

    for (int i = levels; i >= 1; i--) {
      final double levelRadius = radius * (i / levels);
      final Path path = Path();

      for (int j = 0; j < count; j++) {
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

      // Alternate background tint for web polygons
      if (i % 2 == 1) {
        canvas.drawPath(path, fillPaint);
      }
      canvas.drawPath(path, linePaint);
    }
  }

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

    // Gradient fill for radar data area
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

    // Stroke for radar data perimeter
    final Paint strokePaint = Paint()
      ..color = colorScheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(dataPath, strokePaint);
  }

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
        // Outer pulsing glow for active dimension
        canvas
          ..drawCircle(point, 9.0 * animationValue, selectedGlowPaint)
          ..drawCircle(point, 5.0, dotInnerPaint)
          ..drawCircle(point, 5.0, dotOuterPaint);
      } else {
        canvas
          ..drawCircle(point, 3.5, dotInnerPaint)
          ..drawCircle(point, 3.5, dotOuterPaint);
      }
    }
  }

  void _drawLabels(
    Canvas canvas,
    Offset center,
    double radius,
    int count,
    double sliceAngle,
  ) {
    for (int i = 0; i < count; i++) {
      final double angle = -math.pi / 2 + i * sliceAngle;
      final bool isSelected = i == selectedIndex;

      // Label offset slightly outside outer web perimeter
      final double labelRadius = radius + 22.f;
      final double x = center.dx + labelRadius * math.cos(angle);
      final double y = center.dy + labelRadius * math.sin(angle);

      final String categoryName = skills[i].category ?? '';
      final int score = skills[i].score;
      final String labelText = '$categoryName $score';

      final TextStyle style = (textTheme.labelSmall ?? const TextStyle()).copyWith(
        color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        fontSize: 10.5,
      );

      final TextSpan span = TextSpan(text: labelText, style: style);
      final TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      // Compute badge position aligned by angle quadrant
      double calculatedBadgeX = x - tp.width / 2;
      final double badgeY = y - tp.height / 2;

      // Alignment tweaks based on direction
      if (angle > -math.pi / 4 && angle < math.pi / 4) {
        // Right side
        calculatedBadgeX = x - 4.f;
      } else if (angle > 3 * math.pi / 4 || angle < -3 * math.pi / 4) {
        // Left side
        calculatedBadgeX = x - tp.width + 4.f;
      }

      final Rect badgeRect = Rect.fromLTWH(
        calculatedBadgeX - 6.f,
        badgeY - 3.f,
        tp.width + 12.f,
        tp.height + 6.f,
      );

      final RRect badgeRRect = RRect.fromRectAndRadius(
        badgeRect,
        Radius.circular(6.f),
      );

      final Paint bgPaint = Paint()
        ..color = isSelected
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.85)
        ..style = PaintingStyle.fill;

      final Paint borderPaint = Paint()
        ..color = isSelected
            ? colorScheme.primary.withValues(alpha: 0.6)
            : colorScheme.outlineVariant.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas
        ..drawRRect(badgeRRect, bgPaint)
        ..drawRRect(badgeRRect, borderPaint);

      tp.paint(canvas, Offset(calculatedBadgeX, badgeY));
    }
  }

  @override
  bool shouldRepaint(covariant _SkillsRadarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.skills != skills ||
        oldDelegate.colorScheme != colorScheme;
  }
}
