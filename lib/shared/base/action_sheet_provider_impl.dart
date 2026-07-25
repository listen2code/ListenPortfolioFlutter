import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../shared.dart';

class ActionSheetOption {
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;
  final bool visible;

  const ActionSheetOption({
    required this.label,
    required this.icon,
    this.color,
    required this.onTap,
    this.visible = true,
  });
}

class ActionSheetEffect extends BaseEffect {
  final List<ActionSheetOption> options;

  ActionSheetEffect({required this.options});
}

class ActionSheetProviderImpl extends BaseProvider<ActionSheetEffect> {
  const ActionSheetProviderImpl();

  @override
  void handleEffect(ActionSheetEffect effect) {
    final context = AppNavConfig.context;
    if (context != null) {
      CommonBottomSheet.show<void>(
        context: context,
        topRadius: 20.f,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: effect.options.where((o) => o.visible).map((option) {
                return ListTile(
                  leading: Icon(option.icon, color: option.color, size: 24.f),
                  title: CommonText(
                    option.label,
                    style: option.color != null ? TextStyle(color: option.color) : null,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    option.onTap();
                  },
                );
              }).toList(),
            ),
          );
        },
      );
    }
  }
}
