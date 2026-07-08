part of '../log_overlay_manager.dart';

/// A mini real-time FPS chart widget drawn using CustomPainter.
///
/// Implements [RepaintBoundary] and disables anti-aliasing for optimized drawing.
class _FpsMiniChart extends StatelessWidget {
  const _FpsMiniChart();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<FrameMonitorSnapshot?>(
      valueListenable: FrameMonitor.instance.snapshot,
      builder: (context, snapshot, _) {
        if (snapshot == null) return const SizedBox.shrink();

        final double fps = snapshot.fps;
        final Color color = _fpsColor(fps);

        return RepaintBoundary(
          child: SizedBox(
            width: 70,
            height: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPaint(
                  size: const Size(60, 16),
                  painter: _MiniChartPainter(frames: snapshot.recentFrames, color: color),
                ),
                const SizedBox(height: 2),
                CommonText(
                  '${fps.round()} FPS',
                  style: TextStyle(color: color, fontSize: 8.0, fontWeight: FontWeight.bold, height: 1.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _fpsColor(double fps) {
    if (fps >= 55) return Colors.greenAccent;
    if (fps >= 50) return Colors.yellowAccent;
    if (fps >= 30) return Colors.orangeAccent;
    return Colors.redAccent;
  }
}

/// Fast CustomPainter for drawing chronological frame latencies on a mini canvas.
class _MiniChartPainter extends CustomPainter {
  final RingBuffer<FrameMetric> frames;
  final Color color;

  _MiniChartPainter({required this.frames, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (frames.isEmpty) return;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = false; // Disable anti-aliasing for batch-rendering acceleration

    final int len = frames.length;
    final int displayCount = len > 25 ? 25 : len;
    final int startIndex = len - displayCount;

    final double stepX = size.width / 24.0;
    // Find local worst frame latency to auto-scale the Y axis adaptively
    double localMaxUs = 16670.0;
    for (int i = 0; i < displayCount; i++) {
      final metric = frames[startIndex + i];
      final double latencyUs = math.max(metric.buildDurationUs, metric.rasterDurationUs).toDouble();
      if (latencyUs > localMaxUs) {
        localMaxUs = latencyUs;
      }
    }
    final double maxLatencyUs = (localMaxUs * 1.2).clamp(16670.0, 500000.0);

    final path = Path();
    bool first = true;

    for (int i = 0; i < displayCount; i++) {
      final metric = frames[startIndex + i];

      // Perform pixel snapping to avoid sub-pixel rendering blur
      final double x = (i * stepX).roundToDouble();
      final double latencyUs = math.max(metric.buildDurationUs, metric.rasterDurationUs).toDouble();
      final double yFraction = (latencyUs / maxLatencyUs).clamp(0.0, 1.0);
      final double y = (size.height - (yFraction * size.height)).roundToDouble();

      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MiniChartPainter oldDelegate) => true;
}

/// A line chart displaying real-time FPS frame rendering latency with reference lines.
class _FpsLineChart extends StatelessWidget {
  final FrameMonitorSnapshot snapshot;

  const _FpsLineChart({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _LineChartPainter(frames: snapshot.recentFrames),
      ),
    );
  }
}

/// Canvas painter optimized using batch-rendering instruction.
class _LineChartPainter extends CustomPainter {
  final RingBuffer<FrameMetric> frames;

  const _LineChartPainter({required this.frames});

  @override
  void paint(Canvas canvas, Size size) {
    if (frames.isEmpty) return;

    final int len = frames.length;
    // Map to maximum 120 frames in the viewport (~2 seconds of timeline)
    final int displayCount = len > 120 ? 120 : len;
    final int startIndex = len - displayCount;

    final double stepX = size.width / 119.0;
    // Find local worst frame latency to auto-scale the Y axis adaptively
    double localMaxUs = 16670.0;
    for (int i = 0; i < displayCount; i++) {
      final metric = frames[startIndex + i];
      final double latencyUs = math.max(metric.buildDurationUs, metric.rasterDurationUs).toDouble();
      if (latencyUs > localMaxUs) {
        localMaxUs = latencyUs;
      }
    }
    final double maxLatencyUs = (localMaxUs * 1.2).clamp(16670.0, 500000.0);

    // 1. Draw horizontal reference threshold grid lines
    _drawReferenceLine(
      canvas,
      size,
      16670,
      maxLatencyUs,
      '16.6ms (60Hz)',
      Colors.yellowAccent.withValues(alpha: 0.15),
    );
    _drawReferenceLine(
      canvas,
      size,
      8333,
      maxLatencyUs,
      '8.3ms (120Hz)',
      Colors.redAccent.withValues(alpha: 0.15),
    );

    // 2. Prepare paths for UI Frame build lines and GPU raster lines
    final path = Path();
    bool first = true;
    final List<Offset> jankPoints = [];

    for (int i = 0; i < displayCount; i++) {
      final metric = frames[startIndex + i];
      final double x = (i * stepX).roundToDouble(); // Pixel snapping

      final double latencyUs = math.max(metric.buildDurationUs, metric.rasterDurationUs).toDouble();
      final double yFraction = (latencyUs / maxLatencyUs).clamp(0.0, 1.0);
      final double y = (size.height - (yFraction * size.height)).roundToDouble();

      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }

      if (metric.isJank) {
        jankPoints.add(Offset(x, y));
      }
    }

    // 3. Render core latency line
    final linePaint = Paint()
      ..color = Colors.greenAccent.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..isAntiAlias = true;

    canvas.drawPath(path, linePaint);

    // 4. Batch-draw drop-frame Jank anchors as red dots
    if (jankPoints.isNotEmpty) {
      final dotPaint = Paint()
        ..color = Colors.redAccent
        ..style = PaintingStyle.fill
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round;

      canvas.drawPoints(PointMode.points, jankPoints, dotPaint);
    }
  }

  void _drawReferenceLine(
    Canvas canvas,
    Size size,
    double targetUs,
    double maxUs,
    String label,
    Color color,
  ) {
    final double yFraction = (targetUs / maxUs).clamp(0.0, 1.0);
    final double y = (size.height - (yFraction * size.height)).roundToDouble();

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw dashed threshold line
    double curX = 0;
    const double dashWidth = 4.0;
    const double spaceWidth = 4.0;

    while (curX < size.width) {
      canvas.drawLine(Offset(curX, y), Offset(curX + dashWidth, y), linePaint);
      curX += dashWidth + spaceWidth;
    }

    // Draw indicator label text
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, Offset(8, y - 10));
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) => true;
}
