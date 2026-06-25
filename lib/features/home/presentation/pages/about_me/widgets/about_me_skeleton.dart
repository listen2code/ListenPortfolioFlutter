import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class AboutMeSkeleton extends StatelessWidget {
  const AboutMeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.f),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.f),
          // Header Skeleton
          Center(
            child: Column(
              children: [
                CommonSkeleton.circle(size: 120.f),
                SizedBox(height: 16.f),
                CommonSkeleton.line(width: 150.f, height: 24.f),
                SizedBox(height: 8.f),
                CommonSkeleton.line(width: 200.f, height: 16.f),
                SizedBox(height: 8.f),
                CommonSkeleton.line(width: 100.f, height: 14.f),
              ],
            ),
          ),
          SizedBox(height: 35.f),
          // Bio Skeleton
          CommonSkeleton.line(width: 100.f, height: 20.f),
          SizedBox(height: 12.f),
          CommonSkeleton.line(width: double.infinity, height: 14.f),
          SizedBox(height: 8.f),
          CommonSkeleton.line(width: double.infinity, height: 14.f),
          SizedBox(height: 8.f),
          CommonSkeleton.line(width: 200.f, height: 14.f),
          SizedBox(height: 25.f),
          // Timeline Section Skeleton (Experience/Education)
          CommonSkeleton.line(width: 120.f, height: 20.f),
          SizedBox(height: 15.f),
          ...List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 20.f),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CommonSkeleton.circle(size: 12.f),
                      if (index < 2)
                        Container(
                          width: 2.f,
                          height: 60.f,
                          color: context.theme.dividerColor.withValues(alpha: 0.1),
                        ),
                    ],
                  ),
                  SizedBox(width: 15.f),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonSkeleton.line(width: 180.f, height: 18.f),
                        SizedBox(height: 6.f),
                        CommonSkeleton.line(width: 120.f, height: 12.f),
                        SizedBox(height: 8.f),
                        CommonSkeleton.line(width: double.infinity, height: 14.f),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
