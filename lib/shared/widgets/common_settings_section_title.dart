import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../shared.dart';

class CommonSettingsSectionTitle extends StatelessWidget {
  final String title;

  const CommonSettingsSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.f, bottom: 8.f, top: 5.f),
      child: CommonText(
        title.toUpperCase(),
        style: context.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
