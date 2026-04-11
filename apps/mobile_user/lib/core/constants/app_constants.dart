class AppConstants {
  AppConstants._();

  static const String appName = 'Anandham User';
  static const String appVersion = '5.0.0';
  static const int appBuildNumber = 9;

  /// Offline content publication generation (must match bundled / synced schema expectations).
  static const int publicationVersion = 5;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  static const String onboardingKey = 'onboarding_complete';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Animation Durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 400;
  static const int longAnimationDuration = 600;

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
}
