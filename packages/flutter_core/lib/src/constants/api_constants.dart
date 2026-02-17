/// Shared API-related constants used across all Anandham apps.
class ApiConstants {
  ApiConstants._();

  // ── Base URLs ──────────────────────────────────────────────────────────
  static const String productionBaseUrl = 'https://api.anandham.com/v1';
  static const String stagingBaseUrl = 'https://staging-api.anandham.com/v1';
  static const String developmentBaseUrl = 'http://localhost:3000/v1';

  // ── Timeouts (milliseconds) ────────────────────────────────────────────
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // ── Headers ────────────────────────────────────────────────────────────
  static const String contentType = 'application/json';
  static const String acceptHeader = 'application/json';
  static const String authorizationPrefix = 'Bearer';

  // ── Endpoints ──────────────────────────────────────────────────────────
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String logoutEndpoint = '/auth/logout';
  static const String profileEndpoint = '/users/me';
  static const String usersEndpoint = '/users';

  // ── Pagination defaults ────────────────────────────────────────────────
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
