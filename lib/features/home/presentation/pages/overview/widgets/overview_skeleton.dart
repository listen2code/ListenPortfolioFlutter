import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class OverviewSkeleton extends StatelessWidget {
  const OverviewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.f, vertical: 20.f),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonSkeleton.line(width: 180.f, height: 28.f),
          SizedBox(height: 12.f),
          CommonSkeleton.line(width: 260.f, height: 16.f),
          SizedBox(height: 24.f),
          CommonSkeleton(width: 120.f, height: 24.f, borderRadius: 20.f),
          SizedBox(height: 32.f),
          CommonSkeleton(width: double.infinity, height: 100.f, borderRadius: 20.f),
          SizedBox(height: 12.f),
          Row(
            children: [
              Expanded(
                child: CommonSkeleton(height: 80.f, borderRadius: 20.f),
              ),
              SizedBox(width: 12.f),
              Expanded(
                child: CommonSkeleton(height: 80.f, borderRadius: 20.f),
              ),
            ],
          ),
          SizedBox(height: 40.f),
          CommonSkeleton.line(width: 120.f, height: 20.f),
          SizedBox(height: 16.f),
          Row(
            children: [
              Expanded(
                child: CommonSkeleton(height: 90.f, borderRadius: 16.f),
              ),
              SizedBox(width: 12.f),
              Expanded(
                child: CommonSkeleton(height: 90.f, borderRadius: 16.f),
              ),
              SizedBox(width: 12.f),
              Expanded(
                child: CommonSkeleton(height: 90.f, borderRadius: 16.f),
              ),
            ],
          ),
          SizedBox(height: 40.f),
          CommonSkeleton.line(width: 150.f, height: 20.f),
          SizedBox(height: 16.f),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: List.generate(
                2,
                (index) => Padding(
                  padding: EdgeInsets.only(right: 16.f),
                  child: CommonSkeleton(width: 260.f, height: 160.f, borderRadius: 24.f),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
