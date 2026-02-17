import 'package:flutter/material.dart';

/// Extension on [String] for common string operations.
extension StringExtension on String {
  /// Capitalizes the first letter of the string.
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Capitalizes the first letter of each word.
  String get titleCase => split(' ').map((word) => word.capitalize).join(' ');

  /// Returns true if the string is a valid email.
  bool get isValidEmail => RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  ).hasMatch(this);

  /// Returns true if the string is a valid phone number.
  bool get isValidPhone => RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(this);

  /// Returns true if the string is a valid URL.
  bool get isValidUrl => Uri.tryParse(this)?.hasAbsolutePath ?? false;

  /// Truncates the string to [maxLength] and appends ellipsis.
  String truncate(int maxLength) =>
      length <= maxLength ? this : '${substring(0, maxLength)}...';
}

/// Extension on [BuildContext] for easy access to theme and media query.
extension ContextExtension on BuildContext {
  /// Returns the current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Returns the current [TextTheme].
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Returns the current [ColorScheme].
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Returns the current [MediaQueryData].
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns the screen width.
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Returns the screen height.
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Returns the bottom padding (safe area).
  double get bottomPadding => MediaQuery.of(this).padding.bottom;

  /// Returns the top padding (safe area / status bar).
  double get topPadding => MediaQuery.of(this).padding.top;

  /// Shows a snackbar with the given message.
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Extension on [DateTime] for date formatting.
extension DateTimeExtension on DateTime {
  /// Returns a formatted date string (dd/MM/yyyy).
  String get formattedDate =>
      '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';

  /// Returns a formatted time string (HH:mm).
  String get formattedTime =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  /// Returns a relative time string (e.g., "2 hours ago").
  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()} years ago';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} months ago';
    if (diff.inDays > 0) return '${diff.inDays} days ago';
    if (diff.inHours > 0) return '${diff.inHours} hours ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes} minutes ago';
    return 'Just now';
  }
}

/// Extension on [num] for spacing widgets.
extension NumExtension on num {
  /// Returns a [SizedBox] with the given height.
  SizedBox get verticalSpace => SizedBox(height: toDouble());

  /// Returns a [SizedBox] with the given width.
  SizedBox get horizontalSpace => SizedBox(width: toDouble());
}
