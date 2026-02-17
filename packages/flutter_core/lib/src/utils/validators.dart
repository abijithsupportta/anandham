/// A collection of reusable form-field validators.
///
/// Each validator returns `null` on success or an error-message string.
class Validators {
  Validators._();

  /// Validates that the field is not empty.
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates a well-formed email address.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final regex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}'
      r'[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$',
    );
    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates minimum password strength.
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one digit';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  /// Confirms that two values match (e.g. password + confirm password).
  static String? confirmPassword(String? value, String? original) {
    if (value != original) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates a phone number (digits, optional leading +, 7-15 digits).
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final regex = RegExp(r'^\+?[0-9]{7,15}$');
    if (!regex.hasMatch(value.replaceAll(RegExp(r'[\s\-()]'), ''))) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  /// Validates minimum length.
  static String? minLength(
    String? value,
    int min, [
    String fieldName = 'This field',
  ]) {
    if (value != null && value.length < min) {
      return '$fieldName must be at least $min characters';
    }
    return null;
  }

  /// Validates maximum length.
  static String? maxLength(
    String? value,
    int max, [
    String fieldName = 'This field',
  ]) {
    if (value != null && value.length > max) {
      return '$fieldName must be at most $max characters';
    }
    return null;
  }

  /// Validates a URL.
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return 'Enter a valid URL';
    }
    return null;
  }

  /// Validates a numeric string.
  static String? numeric(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) return null; // optional
    if (double.tryParse(value) == null) {
      return '$fieldName must be a number';
    }
    return null;
  }
}
