/// App-wide constants shared across all Anandham applications.
class AppConstants {
  AppConstants._();

  // ── App info ───────────────────────────────────────────────────────────
  static const String appName = 'Anandham';
  static const String appTagline = 'Discover joy in every story';
  static const String supportEmail = 'support@anandham.com';
  static const String privacyPolicyUrl = 'https://anandham.com/privacy';
  static const String termsOfServiceUrl = 'https://anandham.com/terms';

  // ── Storage keys ───────────────────────────────────────────────────────
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String themePreferenceKey = 'theme_preference';
  static const String localePreferenceKey = 'locale_preference';

  // ── Validation ─────────────────────────────────────────────────────────
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 64;
  static const int maxUsernameLength = 30;
  static const int otpLength = 6;
  static const int otpExpirySeconds = 300;

  // ── Animation durations (milliseconds) ─────────────────────────────────
  static const int shortAnimation = 200;
  static const int mediumAnimation = 350;
  static const int longAnimation = 500;

  // ── Image / file limits ────────────────────────────────────────────────
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const int maxFileSizeBytes = 25 * 1024 * 1024; // 25 MB
  static const List<String> allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];

  // ── Asset paths ────────────────────────────────────────────────────────
  static const String _assetPrefix = 'packages/anandham_core/assets';
  static const String logo = '$_assetPrefix/images/anandham_logo.png';
}
