import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class ProjectsSkeleton extends StatelessWidget {
  const ProjectsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 20.f, bottom: 20.f),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            margin: EdgeInsets.only(bottom: 20.f, left: 20.f, right: 20.f),
            decoration: BoxDecoration(
              color: context.theme.cardColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(24.f),
              border: Border.all(color: context.theme.dividerColor.withValues(alpha: 0.05), width: 1.f),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10.f,
                  offset: Offset(0, 5.f),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image/Header Area
                CommonSkeleton(width: double.infinity, height: 140.f, borderRadius: 0),
                Padding(
                  padding: EdgeInsets.all(20.f),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonSkeleton.line(width: 140.f, height: 20.f),
                          CommonSkeleton(width: 60.f, height: 20.f, borderRadius: 8.f),
                        ],
                      ),
                      SizedBox(height: 16.f),
                      CommonSkeleton.line(width: double.infinity, height: 14.f),
                      SizedBox(height: 8.f),
                      CommonSkeleton.line(width: 200.f, height: 14.f),
                      SizedBox(height: 20.f),
                      // Tech stack tags
                      Row(
                        children: List.generate(
                          3,
                          (i) => Padding(
                            padding: EdgeInsets.only(right: 8.f),
                            child: CommonSkeleton(width: 50.f, height: 18.f, borderRadius: 6.f),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.f),
                      // Action button (Full width skeleton)
                      CommonSkeleton(width: double.infinity, height: 36.f, borderRadius: 10.f),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
