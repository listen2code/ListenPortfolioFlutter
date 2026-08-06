import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';

class SettingsVersionTile extends StatefulWidget {
  final VoidCallback onTrigger;

  const SettingsVersionTile({super.key, required this.onTrigger});

  @override
  State<SettingsVersionTile> createState() => _SettingsVersionTileState();
}

class _SettingsVersionTileState extends State<SettingsVersionTile> {
  int _clickCount = 0;
  DateTime? _lastClickTime;
  String _versionDisplay = '${I18nKeys.appVersion.tr} ${AppConstants.appVersion}';

  @override
  void initState() {
    super.initState();
    _loadVersionInfo();
  }

  Future<void> _loadVersionInfo() async {
    final base = '${I18nKeys.appVersion.tr} ${AppConstants.appVersion}';
    final formatted = await shorebirdService.getFormattedVersion(base);
    if (mounted) {
      setState(() {
        _versionDisplay = formatted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Center(
        child: CommonText(
          _versionDisplay,
          style: context.textTheme.labelSmall?.copyWith(color: Colors.grey),
        ),
      ),
      onTap: () {
        final now = DateTime.now();
        if (_lastClickTime == null || now.difference(_lastClickTime!) > const Duration(seconds: 2)) {
          _clickCount = 1;
        } else {
          _clickCount++;
        }
        _lastClickTime = now;

        if (_clickCount >= 7) {
          _clickCount = 0;
          widget.onTrigger();
        }
      },
    );
  }
}
