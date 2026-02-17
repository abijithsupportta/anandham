import 'package:equatable/equatable.dart';

/// Abstract class representing a failure in the application.
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Failure originating from the server.
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// Failure originating from local cache operations.
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Failure due to network connectivity issues.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
  });
}

/// Failure due to authentication issues.
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    super.message = 'Authentication failed. Please login again.',
    super.statusCode = 401,
  });
}

/// Failure due to authorization issues.
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    super.message = 'You do not have permission to perform this action.',
    super.statusCode = 403,
  });
}

/// Failure when a resource is not found.
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'The requested resource was not found.',
    super.statusCode = 404,
  });
}

/// Failure due to validation errors.
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({
    super.message = 'Validation failed.',
    this.errors,
    super.statusCode = 422,
  });

  @override
  List<Object?> get props => [message, statusCode, errors];
}

/// Unexpected or unknown failure.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred. Please try again.',
  });
}
