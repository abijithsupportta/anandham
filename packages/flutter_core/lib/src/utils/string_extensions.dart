/// Handy extension methods on [String].
extension StringExtensions on String {
  /// Capitalises the first letter: `'hello' → 'Hello'`.
  String get capitalised =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Title-cases every word: `'hello world' → 'Hello World'`.
  String get titleCase => split(' ').map((w) => w.capitalised).join(' ');

  /// Truncates to [maxLength] and appends an ellipsis if needed.
  String truncate(int maxLength, {String ellipsis = '…'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  /// Returns `true` if the string is a valid email address.
  bool get isValidEmail => RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  ).hasMatch(this);

  /// Returns `true` if the string contains only digits.
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);

  /// Returns the string with all whitespace removed.
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Returns initials from a full name: `'John Doe' → 'JD'`.
  String get initials {
    final parts = trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// Converts a snake_case string to camelCase.
  String get snakeToCamel {
    final parts = split('_');
    if (parts.length <= 1) return this;
    return parts.first + parts.skip(1).map((p) => p.capitalised).join();
  }

  /// Converts a camelCase string to snake_case.
  String get camelToSnake =>
      replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

  /// Returns `null` if the string is empty, otherwise returns the string.
  String? get nullIfEmpty => isEmpty ? null : this;
}

/// Extension on nullable strings.
extension NullableStringExtensions on String? {
  /// Returns `true` if the string is `null` or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns `true` if the string is not null and not empty.
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Returns the string or a fallback value.
  String orDefault([String defaultValue = '']) => this ?? defaultValue;
}
