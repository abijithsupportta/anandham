import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

/// The visual variant of an [AppButton].
enum AppButtonVariant { filled, outlined, text }

/// The predefined size of an [AppButton].
enum AppButtonSize { small, medium, large }

/// A highly customisable button used throughout the Anandham platform.
///
/// ```dart
/// AppButton(
///   label: 'Continue',
///   onPressed: () {},
///   variant: AppButtonVariant.filled,
///   isLoading: _submitting,
/// )
/// ```
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? color;
  final Color? textColor;
  final double? borderRadius;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.prefixIcon,
    this.suffixIcon,
    this.color,
    this.textColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? ColorConstants.primary;
    final radius = BorderRadius.circular(borderRadius ?? _radiusForSize);

    final child = _buildChild(effectiveColor);

    Widget button;

    switch (variant) {
      case AppButtonVariant.filled:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveColor,
            foregroundColor: textColor ?? ColorConstants.textOnPrimary,
            padding: _paddingForSize,
            shape: RoundedRectangleBorder(borderRadius: radius),
            minimumSize: Size(0, _heightForSize),
          ),
          child: child,
        );
      case AppButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? effectiveColor,
            side: BorderSide(color: effectiveColor),
            padding: _paddingForSize,
            shape: RoundedRectangleBorder(borderRadius: radius),
            minimumSize: Size(0, _heightForSize),
          ),
          child: child,
        );
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? effectiveColor,
            padding: _paddingForSize,
            shape: RoundedRectangleBorder(borderRadius: radius),
            minimumSize: Size(0, _heightForSize),
          ),
          child: child,
        );
    }

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  Widget _buildChild(Color effectiveColor) {
    if (isLoading) {
      return SizedBox(
        width: _loaderSize,
        height: _loaderSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == AppButtonVariant.filled
                ? ColorConstants.textOnPrimary
                : effectiveColor,
          ),
        ),
      );
    }

    final textWidget = Text(
      label,
      style: TextStyle(fontSize: _fontSizeForSize),
    );

    if (prefixIcon != null || suffixIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefixIcon != null) ...[
            Icon(prefixIcon, size: _iconSize),
            const SizedBox(width: 8),
          ],
          textWidget,
          if (suffixIcon != null) ...[
            const SizedBox(width: 8),
            Icon(suffixIcon, size: _iconSize),
          ],
        ],
      );
    }

    return textWidget;
  }

  // ── Size helpers ──────────────────────────────────────────────────────

  double get _heightForSize => switch (size) {
    AppButtonSize.small => 36,
    AppButtonSize.medium => 48,
    AppButtonSize.large => 56,
  };

  EdgeInsetsGeometry get _paddingForSize => switch (size) {
    AppButtonSize.small => const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 6,
    ),
    AppButtonSize.medium => const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 12,
    ),
    AppButtonSize.large => const EdgeInsets.symmetric(
      horizontal: 28,
      vertical: 16,
    ),
  };

  double get _fontSizeForSize => switch (size) {
    AppButtonSize.small => 13,
    AppButtonSize.medium => 15,
    AppButtonSize.large => 17,
  };

  double get _radiusForSize => switch (size) {
    AppButtonSize.small => 8,
    AppButtonSize.medium => 12,
    AppButtonSize.large => 16,
  };

  double get _iconSize => switch (size) {
    AppButtonSize.small => 16,
    AppButtonSize.medium => 20,
    AppButtonSize.large => 24,
  };

  double get _loaderSize => switch (size) {
    AppButtonSize.small => 16,
    AppButtonSize.medium => 20,
    AppButtonSize.large => 24,
  };
}
