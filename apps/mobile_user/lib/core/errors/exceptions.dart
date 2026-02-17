/// Base exception class for the application.
class AppException implements Exception {
  final String message;
  final int? statusCode;
  final String? prefix;

  const AppException({required this.message, this.statusCode, this.prefix});

  @override
  String toString() => '${prefix ?? 'Exception'}: $message';
}

/// Exception thrown when there is a server error.
class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode})
    : super(prefix: 'ServerException');
}

/// Exception thrown when there is a cache/local storage error.
class CacheException extends AppException {
  const CacheException({required super.message})
    : super(prefix: 'CacheException');
}

/// Exception thrown when there is no internet connection.
class NetworkException extends AppException {
  const NetworkException({super.message = 'No internet connection'})
    : super(prefix: 'NetworkException');
}

/// Exception thrown when authentication fails.
class AuthenticationException extends AppException {
  const AuthenticationException({
    super.message = 'Authentication failed',
    super.statusCode = 401,
  }) : super(prefix: 'AuthenticationException');
}

/// Exception thrown when authorization fails.
class AuthorizationException extends AppException {
  const AuthorizationException({
    super.message = 'You do not have permission to perform this action',
    super.statusCode = 403,
  }) : super(prefix: 'AuthorizationException');
}

/// Exception thrown when a requested resource is not found.
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.statusCode = 404,
  }) : super(prefix: 'NotFoundException');
}

/// Exception thrown when request times out.
class TimeoutException extends AppException {
  const TimeoutException({super.message = 'Request timed out'})
    : super(prefix: 'TimeoutException');
}

/// Exception thrown for validation errors.
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  const ValidationException({
    super.message = 'Validation failed',
    this.errors,
    super.statusCode = 422,
  }) : super(prefix: 'ValidationException');
}
