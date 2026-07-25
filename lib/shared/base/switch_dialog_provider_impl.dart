import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

class SwitchDialogOption {
  final String label;
  final String? subtitle;
  final dynamic value;
  final bool isSelected;

  const SwitchDialogOption({required this.label, this.subtitle, required this.value, required this.isSelected});
}

class SwitchDialogEffect extends BaseEffect {
  final String title;
  final List<SwitchDialogOption> options;
  final bool showConfirmButton;
  final void Function(dynamic value) onChanged;

  SwitchDialogEffect({
    required this.title,
    required this.options,
    this.showConfirmButton = true,
    required this.onChanged,
  });
}

class SwitchDialogProviderImpl extends BaseProvider<SwitchDialogEffect> {
  const SwitchDialogProviderImpl();

  @override
  void handleEffect(SwitchDialogEffect effect) {
    final context = AppNavConfig.context;
    if (context != null) {
      CommonDialog.showSwitchDialog(
        title: effect.title,
        actions: effect.showConfirmButton ? null : [],
        items: effect.options.map((option) {
          return DialogSwitchItem(
            label: option.label,
            subtitle: option.subtitle,
            value: option.isSelected,
            onChanged: (_) async {
              effect.onChanged(option.value);
            },
          );
        }).toList(),
      );
    }
  }
}
