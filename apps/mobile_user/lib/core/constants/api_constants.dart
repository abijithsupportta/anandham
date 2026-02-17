class ApiConstants {
  ApiConstants._();

  // Base URL
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.anandham.com/v1',
  );
  static const String stagingBaseUrl = 'https://staging-api.anandham.com/v1';

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String profile = '/user/profile';

  // Headers
  static const String contentType = 'application/json';
  static const String acceptHeader = 'Accept';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}
