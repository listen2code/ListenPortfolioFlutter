import 'package:flutter/material.dart';

import '../uikit.dart';

/// Preset types for the empty view to quickly configure common scenarios.
enum EmptyType {
  empty, // Generic empty state
  search, // No search results
  error, // Network or server error
  security, // No permission
}

/// A professional empty state placeholder widget.
/// Used when a list is empty, search fails, or an error occurs.
class CommonEmptyView extends StatelessWidget {
  final EmptyType type;
  final String? title;
  final String? subtitle;
  final String? imagePath;
  final Widget? icon;
  final String? actionText;
  final VoidCallback? onAction;
  final bool useFullHeight;

  const CommonEmptyView({
    super.key,
    this.type = EmptyType.empty,
    this.title,
    this.subtitle,
    this.imagePath,
    this.icon,
    this.actionText,
    this.onAction,
    this.useFullHeight = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Image or Icon Section
        _buildIllustration(theme),
        const SizedBox(height: 24),

        // 2. Title Section
        CommonText(
          title ?? _getDefaultTitle(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // 3. Subtitle Section
        if (subtitle != null || _getDefaultSubtitle() != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: CommonText(
              subtitle ?? _getDefaultSubtitle()!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),

        // 4. Action Button Section
        if (onAction != null) ...[
          const SizedBox(height: 32),
          CommonButton(
            text: actionText ?? _getDefaultActionText(),
            onPressed: onAction,
            isFullWidth: false,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
        ],
      ],
    );

    if (useFullHeight) {
      return Center(child: content);
    }
    return content;
  }

  Widget _buildIllustration(ThemeData theme) {
    if (imagePath != null) {
      return CommonImage.asset(imagePath!, width: 160, height: 160);
    }

    if (icon != null) return icon!;

    // Default Material Icons based on type if no image is provided
    IconData defaultIcon;
    switch (type) {
      case EmptyType.search:
        defaultIcon = Icons.search_off_rounded;
        break;
      case EmptyType.error:
        defaultIcon = Icons.cloud_off_rounded;
        break;
      case EmptyType.security:
        defaultIcon = Icons.lock_outline_rounded;
        break;
      default:
        defaultIcon = Icons.inbox_rounded;
    }

    return Icon(defaultIcon, size: 80, color: theme.colorScheme.primary.withValues(alpha: 0.2));
  }

  String _getDefaultTitle() {
    switch (type) {
      case EmptyType.search:
        return UIKitConfig.getString(UIKitConfig.kNoResults);
      case EmptyType.error:
        return UIKitConfig.getString(UIKitConfig.kLoadFailed);
      case EmptyType.security:
        return UIKitConfig.getString(UIKitConfig.kAccessDenied);
      default:
        return UIKitConfig.getString(UIKitConfig.kNoData);
    }
  }

  String? _getDefaultSubtitle() {
    switch (type) {
      case EmptyType.search:
        return "We couldn't find what you're looking for.";
      case EmptyType.error:
        return "Something went wrong. Please check your connection.";
      default:
        return null;
    }
  }

  String _getDefaultActionText() {
    return type == EmptyType.error
        ? UIKitConfig.getString(UIKitConfig.kRetry)
        : UIKitConfig.getString(UIKitConfig.kOk);
  }
}
