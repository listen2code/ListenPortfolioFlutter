import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

/// ============================================================================
/// Modern Color Picker Widget (Flutter 3.44.1 / Wide Gamut Compatible)
/// ============================================================================
///
/// This component provides interactive RGB channel sliders to customize the
/// application's accent color.
///
/// Flutter 3.44.1 Architectural Migration:
/// 1. **Wide Gamut Floating-Point Channels (`Color.r`, `Color.g`, `Color.b`)**:
///    Starting with Flutter 3.44+ (and Dart 3.12+), `Color.red`, `Color.green`,
///    and `Color.blue` (integer 0-255) are deprecated in favor of floating-point
///    channels (`r`, `g`, `b`, `a`) in range [0.0, 1.0] to support Display P3
///    and extended dynamic range gamuts.
/// 2. **`Color.withValues(alpha:)` vs `withOpacity()`**:
///    Replaced legacy `withOpacity(0.2)` with `withValues(alpha: 0.2)` to ensure
///    high-precision alpha blending without integer clamping artifacts.
class ColorPickerWidget extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerWidget({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Live color preview circle with wide-gamut border opacity
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: _selectedColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
        ),
        const SizedBox(height: 20),
        // Red Slider: Converts normalized float channel (0.0~1.0) to integer range (0~255)
        _buildRGBSlider('R', (_selectedColor.r * 255.0).round().clamp(0, 255), (val) {
          setState(() {
            _selectedColor = _selectedColor.withRed(val.toInt());
          });
          widget.onColorChanged(_selectedColor);
        }),
        // Green Slider
        _buildRGBSlider('G', (_selectedColor.g * 255.0).round().clamp(0, 255), (val) {
          setState(() {
            _selectedColor = _selectedColor.withGreen(val.toInt());
          });
          widget.onColorChanged(_selectedColor);
        }),
        // Blue Slider
        _buildRGBSlider('B', (_selectedColor.b * 255.0).round().clamp(0, 255), (val) {
          setState(() {
            _selectedColor = _selectedColor.withBlue(val.toInt());
          });
          widget.onColorChanged(_selectedColor);
        }),
      ],
    );
  }

  Widget _buildRGBSlider(String label, int value, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: CommonText(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 255,
            activeColor: label == 'R' ? Colors.red : (label == 'G' ? Colors.green : Colors.blue),
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 30, child: CommonText(value.toString())),
      ],
    );
  }
}
