import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';
import '../overview_state.dart';

class StatusTag extends StatelessWidget {
  final OverviewState state;

  const StatusTag({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return CommonBadge(
      text: state.aboutMe?.status?.tr ?? I18nKeys.availableStatus.tr,
      icon: Icons.circle,
      iconSize: 6.f,
      color: Colors.green.withValues(alpha: 0.1),
      textColor: Colors.green,
      borderColor: Colors.green.withValues(alpha: 0.2),
      borderRadius: 20.f,
      padding: EdgeInsets.symmetric(horizontal: 10.f, vertical: 4.f),
      spacing: 6.f,
    );
  }
}
