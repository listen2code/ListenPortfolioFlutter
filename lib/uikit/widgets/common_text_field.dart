import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Predefined styles for common input scenarios
enum TextFieldType { text, password, email, number }

/// A reusable text input component based on TextFormField.
/// Supports password toggling, input limiting, and centralized styling.
class CommonTextField extends StatefulWidget {
  /// Controls the text being edited
  final TextEditingController? controller;

  /// Text that suggests what sort of input the field accepts
  final String? hintText;

  /// Text that describes the input field (floats when focused)
  final String? labelText;

  /// Text that appears below the field when validation fails
  final String? errorText;

  /// The logical type of the field (affects keyboard and obscure logic)
  final TextFieldType type;

  /// Icon to display at the beginning of the text field
  final IconData? prefixIcon;

  /// Callback when the text value changes
  final ValueChanged<String>? onChanged;

  /// Function to validate the input text
  final FormFieldValidator<String>? validator;

  /// The type of action button to show on the keyboard
  final TextInputAction? textInputAction;

  /// Maximum number of characters allowed
  final int? maxLength;

  /// If true, restricts input to numeric characters only
  final bool isDigitsOnly;

  /// Manually override the keyboard layout (e.g., phone, url)
  final TextInputType? keyboardType;

  /// The color to use for icons and focus. If null, uses the theme's primary color or icon color.
  final Color? accentColor;

  // New properties
  final int? maxLines;
  final int minLines;
  final bool showClearIcon;

  const CommonTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.type = TextFieldType.text,
    this.prefixIcon,
    this.onChanged,
    this.validator,
    this.textInputAction,
    this.maxLength,
    this.isDigitsOnly = false,
    this.keyboardType,
    this.accentColor,
    this.maxLines = 1,
    this.minLines = 1,
    this.showClearIcon = false,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _obscureText = true;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.showClearIcon) {
      _controller.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Resolve the most appropriate color:
    // 1. Manually passed accentColor
    // 2. Icon theme color (which usually holds our original accentColor)
    // 3. Primary color from ColorScheme
    final effectiveAccentColor = widget.accentColor ?? theme.iconTheme.color ?? theme.colorScheme.primary;

    final isPassword = widget.type == TextFieldType.password;

    return TextFormField(
      controller: _controller,
      onChanged: widget.onChanged,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      obscureText: isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType ?? _getKeyboardType(),
      maxLength: widget.maxLength,
      maxLines: isPassword ? 1 : widget.maxLines,
      // Password must be single line
      minLines: widget.minLines,
      inputFormatters: [if (widget.isDigitsOnly) FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        errorText: widget.errorText,
        // The color is now automatically picked up from inputDecorationTheme
        // if not explicitly styled here. Using effectiveAccentColor for manual Icons.
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, color: effectiveAccentColor) : null,
        suffixIcon: _buildSuffixIcon(effectiveAccentColor),
      ),
    );
  }

  Widget? _buildSuffixIcon(Color color) {
    if (widget.type == TextFieldType.password) {
      return IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: color),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      );
    }

    if (widget.showClearIcon && _controller.text.isNotEmpty) {
      return IconButton(
        icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
        onPressed: () {
          _controller.clear();
          widget.onChanged?.call('');
        },
      );
    }

    return null;
  }

  // Resolve default keyboard layout based on field type
  TextInputType _getKeyboardType() {
    if (widget.maxLines != null && widget.maxLines! > 1) return TextInputType.multiline;
    switch (widget.type) {
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.password:
        return TextInputType.visiblePassword;
      case TextFieldType.number:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
}
