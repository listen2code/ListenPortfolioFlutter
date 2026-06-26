import 'package:flutter/material.dart';

import '../shared.dart';

class CommonSettingsCard extends StatelessWidget {
  final List<Widget> children;

  const CommonSettingsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8.f,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(20.f),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              children[i],
              if (i < children.length - 1)
                Divider(
                  height: 1,
                  thickness: 0.5,
                  indent: 60.f,
                  endIndent: 20.f,
                  color: context.theme.dividerColor.withValues(alpha: 0.05),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
