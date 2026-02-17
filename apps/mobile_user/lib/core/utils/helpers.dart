import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Collection of utility helper functions.
class Helpers {
  Helpers._();

  /// Logs a message to the console in debug mode only.
  static void log(String message, {String tag = 'APP'}) {
    if (kDebugMode) {
      developer.log(message, name: tag);
    }
  }

  /// Formats a [DateTime] to a readable string.
  static String formatDate(DateTime date, {String pattern = 'dd MMM yyyy'}) {
    return DateFormat(pattern).format(date);
  }

  /// Formats a [DateTime] to a time string.
  static String formatTime(DateTime date, {String pattern = 'hh:mm a'}) {
    return DateFormat(pattern).format(date);
  }

  /// Formats a number to currency string.
  static String formatCurrency(double amount, {String symbol = '₹'}) {
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return formatter.format(amount);
  }

  /// Formats a large number with suffixes (K, M, B).
  static String formatCompactNumber(num number) {
    return NumberFormat.compact().format(number);
  }

  /// Debounces a function call by [milliseconds].
  static Function(T) debounce<T>(void Function(T) fn, Duration duration) {
    DateTime? lastCall;
    return (T args) {
      final now = DateTime.now();
      if (lastCall == null || now.difference(lastCall!) > duration) {
        lastCall = now;
        fn(args);
      }
    };
  }

  /// Returns a greeting based on the time of day.
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  /// Generates initials from a full name.
  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// Masks an email address for privacy display.
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return '$name@$domain';
    return '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}@$domain';
  }

  /// Masks a phone number for privacy display.
  static String maskPhone(String phone) {
    if (phone.length < 4) return phone;
    return '${'*' * (phone.length - 4)}${phone.substring(phone.length - 4)}';
  }
}
