/// Base class for all API-related exceptions.
sealed class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const ApiException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => '$runtimeType($statusCode): $message';
}

/// Thrown when the server returns a 400 Bad Request.
class BadRequestException extends ApiException {
  final Map<String, dynamic>? validationErrors;

  const BadRequestException({
    super.message = 'Bad request',
    super.statusCode = 400,
    super.originalError,
    this.validationErrors,
  });
}

/// Thrown when the server returns a 401 Unauthorized.
class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    super.message = 'Unauthorized – please log in again',
    super.statusCode = 401,
    super.originalError,
  });
}

/// Thrown when the server returns a 403 Forbidden.
class ForbiddenException extends ApiException {
  const ForbiddenException({
    super.message = 'You do not have permission to perform this action',
    super.statusCode = 403,
    super.originalError,
  });
}

/// Thrown when the server returns a 404 Not Found.
class NotFoundException extends ApiException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.statusCode = 404,
    super.originalError,
  });
}

/// Thrown when the server returns a 409 Conflict.
class ConflictException extends ApiException {
  const ConflictException({
    super.message = 'Conflict – resource already exists',
    super.statusCode = 409,
    super.originalError,
  });
}

/// Thrown when the server returns a 422 Unprocessable Entity.
class UnprocessableEntityException extends ApiException {
  final Map<String, dynamic>? validationErrors;

  const UnprocessableEntityException({
    super.message = 'Validation failed',
    super.statusCode = 422,
    super.originalError,
    this.validationErrors,
  });
}

/// Thrown when the server returns a 429 Too Many Requests.
class TooManyRequestsException extends ApiException {
  final int? retryAfterSeconds;

  const TooManyRequestsException({
    super.message = 'Too many requests – please try again later',
    super.statusCode = 429,
    super.originalError,
    this.retryAfterSeconds,
  });
}

/// Thrown when the server returns 5xx.
class ServerException extends ApiException {
  const ServerException({
    super.message = 'Internal server error',
    super.statusCode = 500,
    super.originalError,
  });
}

/// Thrown when the request times out.
class TimeoutException extends ApiException {
  const TimeoutException({
    super.message = 'Request timed out – check your connection',
    super.statusCode,
    super.originalError,
  });
}

/// Thrown when there is no internet connectivity.
class NoInternetException extends ApiException {
  const NoInternetException({
    super.message = 'No internet connection',
    super.statusCode,
    super.originalError,
  });
}

/// Catch-all for unexpected errors.
class UnknownApiException extends ApiException {
  const UnknownApiException({
    super.message = 'An unexpected error occurred',
    super.statusCode,
    super.originalError,
  });
}
