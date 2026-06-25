import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../shared.dart';

class CommonTimelineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final bool isLast;

  const CommonTimelineItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = context.accentColor;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12.f,
                height: 12.f,
                decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2.f, color: accentColor.withValues(alpha: 0.2)),
                ),
            ],
          ),
          SizedBox(width: 15.f),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                CommonText(
                  subtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.f),
                CommonText(
                  description,
                  style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.4),
                  useFittedBox: false,
                ),
                SizedBox(height: 20.f),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
