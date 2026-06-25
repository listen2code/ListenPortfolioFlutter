import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class ArchitectureSkeleton extends StatelessWidget {
  const ArchitectureSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.f),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonSkeleton.line(width: double.infinity, height: 16.f),
          SizedBox(height: 8.f),
          CommonSkeleton.line(width: 200.f, height: 16.f),
          SizedBox(height: 30.f),
          ...List.generate(
            4,
            (index) => Container(
              margin: EdgeInsets.only(bottom: 25.f),
              padding: EdgeInsets.all(20.f),
              decoration: BoxDecoration(
                color: context.theme.cardColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20.f),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CommonSkeleton.circle(size: 24.f),
                      SizedBox(width: 12.f),
                      CommonSkeleton.line(width: 150.f, height: 18.f),
                    ],
                  ),
                  SizedBox(height: 20.f),
                  CommonSkeleton.line(width: double.infinity, height: 14.f),
                  SizedBox(height: 10.f),
                  CommonSkeleton.line(width: double.infinity, height: 14.f),
                  SizedBox(height: 10.f),
                  CommonSkeleton.line(width: 180.f, height: 14.f),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
