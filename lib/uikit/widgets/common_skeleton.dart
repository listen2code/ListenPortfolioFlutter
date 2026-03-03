import 'package:flutter/material.dart';

/// A professional skeleton loader widget to provide better visual feedback during loading.
class CommonSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;
  final EdgeInsetsGeometry? margin;

  const CommonSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.shape = BoxShape.rectangle,
    this.margin,
  });

  /// Factory for a circular skeleton (e.g., Avatars).
  factory CommonSkeleton.circle({required double size, EdgeInsetsGeometry? margin}) {
    return CommonSkeleton(width: size, height: size, shape: BoxShape.circle, margin: margin);
  }

  /// Factory for a typical line of text.
  factory CommonSkeleton.line({
    double width = double.infinity,
    double height = 16,
    double borderRadius = 4,
    EdgeInsetsGeometry? margin,
  }) {
    return CommonSkeleton(width: width, height: height, borderRadius: borderRadius, margin: margin);
  }

  @override
  State<CommonSkeleton> createState() => _CommonSkeletonState();
}

class _CommonSkeletonState extends State<CommonSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;

    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: baseColor,
          shape: widget.shape,
          borderRadius: widget.shape == BoxShape.rectangle
              ? BorderRadius.circular(widget.borderRadius)
              : null,
        ),
      ),
    );
  }
}

/// A helper widget to build a skeleton list item (ListTile style).
class CommonSkeletonListTile extends StatelessWidget {
  final bool hasLeading;
  final bool hasSubtitle;

  const CommonSkeletonListTile({super.key, this.hasLeading = true, this.hasSubtitle = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (hasLeading) ...[CommonSkeleton.circle(size: 48), const SizedBox(width: 16)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonSkeleton.line(width: double.infinity, height: 14),
                if (hasSubtitle) ...[const SizedBox(height: 8), CommonSkeleton.line(width: 150, height: 10)],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
