import 'package:intl/intl.dart';

/// Date & time formatting and helper utilities.
class AppDateUtils {
  AppDateUtils._();

  // ── Formatters ─────────────────────────────────────────────────────────

  static final DateFormat _dateShort = DateFormat('dd MMM yyyy');
  static final DateFormat _dateLong = DateFormat('dd MMMM yyyy');
  static final DateFormat _dateTime = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _time = DateFormat('hh:mm a');
  static final DateFormat _iso = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

  /// e.g. `17 Feb 2026`
  static String formatShort(DateTime date) => _dateShort.format(date);

  /// e.g. `17 February 2026`
  static String formatLong(DateTime date) => _dateLong.format(date);

  /// e.g. `17 Feb 2026, 03:30 PM`
  static String formatDateTime(DateTime date) => _dateTime.format(date);

  /// e.g. `03:30 PM`
  static String formatTime(DateTime date) => _time.format(date);

  /// ISO-8601 string.
  static String toIso(DateTime date) => _iso.format(date.toUtc());

  /// Parses an ISO-8601 string to a local [DateTime].
  static DateTime fromIso(String iso) => DateTime.parse(iso).toLocal();

  // ── Relative time ──────────────────────────────────────────────────────

  /// Returns a human-readable relative string like "2 hours ago" or "just now".
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return '$m ${m == 1 ? 'minute' : 'minutes'} ago';
    }
    if (diff.inHours < 24) {
      final h = diff.inHours;
      return '$h ${h == 1 ? 'hour' : 'hours'} ago';
    }
    if (diff.inDays < 7) {
      final d = diff.inDays;
      return '$d ${d == 1 ? 'day' : 'days'} ago';
    }
    if (diff.inDays < 30) {
      final w = (diff.inDays / 7).floor();
      return '$w ${w == 1 ? 'week' : 'weeks'} ago';
    }
    if (diff.inDays < 365) {
      final m = (diff.inDays / 30).floor();
      return '$m ${m == 1 ? 'month' : 'months'} ago';
    }
    final y = (diff.inDays / 365).floor();
    return '$y ${y == 1 ? 'year' : 'years'} ago';
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  /// Returns `true` if [date] is today.
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Returns `true` if [date] was yesterday.
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Returns the start of the day (midnight) for the given [date].
  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// Returns the end of the day (23:59:59.999) for the given [date].
  static DateTime endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  /// Returns age in years from a birth date.
  static int ageFromBirthDate(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
