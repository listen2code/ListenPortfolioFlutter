import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class DeleteAccountWarningList extends StatelessWidget {
  final List<String> warnings;

  const DeleteAccountWarningList({super.key, required this.warnings});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final warning in warnings) _buildWarningItem(context, warning),
      ],
    );
  }

  Widget _buildWarningItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.f),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.f),
            child: Icon(Icons.circle, size: 6.f, color: Colors.grey),
          ),
          SizedBox(width: 12.f),
          Expanded(
            child: CommonText(
              text,
              style: context.textTheme.bodySmall?.copyWith(color: Colors.grey, height: 1.4),
              useFittedBox: false,
            ),
          ),
        ],
      ),
    );
  }
}
