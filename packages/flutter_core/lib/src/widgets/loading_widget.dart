import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

/// A centered loading indicator with an optional message.
///
/// ```dart
/// // Full-screen loader
/// const LoadingWidget()
///
/// // Inline with a message
/// const LoadingWidget(message: 'Fetching posts…', compact: true)
/// ```
class LoadingWidget extends StatelessWidget {
  /// Optional description shown below the spinner.
  final String? message;

  /// When `true` the widget wraps tightly around its content instead of
  /// expanding to fill available space.
  final bool compact;

  /// Spinner colour — defaults to [ColorConstants.primary].
  final Color? color;

  /// Spinner diameter.
  final double size;

  /// Stroke width of the [CircularProgressIndicator].
  final double strokeWidth;

  const LoadingWidget({
    super.key,
    this.message,
    this.compact = false,
    this.color,
    this.size = 36,
    this.strokeWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? ColorConstants.primary,
        ),
      ),
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator,
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: const TextStyle(
              fontSize: 14,
              color: ColorConstants.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (compact) return content;

    return Center(child: content);
  }
}
