import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

/// A friendly error state widget with an optional retry action.
///
/// ```dart
/// AppErrorWidget(
///   message: 'Something went wrong',
///   onRetry: () => ref.refresh(postsProvider),
/// )
/// ```
class AppErrorWidget extends StatelessWidget {
  /// Error description shown to the user.
  final String message;

  /// Optional detailed description (e.g. status code or technical info).
  final String? details;

  /// Icon displayed above the message.
  final IconData icon;

  /// Icon colour.
  final Color? iconColor;

  /// Icon size.
  final double iconSize;

  /// If non-null a "Retry" button is displayed.
  final VoidCallback? onRetry;

  /// Label for the retry button.
  final String retryLabel;

  /// When `true`, the widget wraps tightly instead of centering itself.
  final bool compact;

  const AppErrorWidget({
    super.key,
    this.message = 'Something went wrong',
    this.details,
    this.icon = Icons.error_outline_rounded,
    this.iconColor,
    this.iconSize = 56,
    this.onRetry,
    this.retryLabel = 'Retry',
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: iconColor ?? ColorConstants.error),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorConstants.textPrimary,
            ),
          ),
          if (details != null) ...[
            const SizedBox(height: 8),
            Text(
              details!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: ColorConstants.textSecondary,
              ),
            ),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(retryLabel),
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorConstants.primary,
                side: const BorderSide(color: ColorConstants.primary),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    if (compact) return content;

    return Center(child: content);
  }
}
