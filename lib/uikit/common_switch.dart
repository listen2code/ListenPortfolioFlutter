import 'package:flutter/cupertino.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';

/// A common switch component that provides a consistent look and feel across the app.
/// It wraps the [CupertinoSwitch] for a clean, modern aesthetic while respecting the app's theme.
class CommonSwitch extends StatelessWidget {
  /// Whether this switch is on or off.
  final bool value;

  /// Called when the user toggles the switch on or off.
  final ValueChanged<bool>? onChanged;

  /// The color to use for the track when this switch is on. Defaults to [context.accentColor].
  final Color? activeTrackColor;

  /// The color to use for the track when the switch is off.
  final Color? inactiveTrackColor;

  /// The scale factor for the switch size. Defaults to 0.8 to fit better in dense lists.
  final double scale;

  const CommonSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.scale = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    // Using Transform.scale to allow fine-grained control over the switch's visual weight.
    // Alignment is set to centerRight to align well when used as a trailing widget in ListTiles.
    return Transform.scale(
      scale: scale.f,
      alignment: Alignment.centerRight,
      child: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: activeTrackColor ?? context.accentColor,
        inactiveTrackColor: inactiveTrackColor ?? context.theme.dividerColor.withValues(alpha: 0.1),
      ),
    );
  }
}
