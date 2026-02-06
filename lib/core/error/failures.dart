import 'package:equatable/equatable.dart';

/// Base class for all failures in the domain layer
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Failure when the server is unreachable or network is down
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred'])
      : super(message);
}

/// Failure when the server returns an error response
class ServerFailure extends Failure {
  const ServerFailure(String message, {String? code}) : super(message, code: code);
}

/// Failure when authentication fails
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([String message = 'Authentication failed'])
      : super(message);
}

/// Failure when authorization fails (e.g., 403 Forbidden)
class AuthorizationFailure extends Failure {
  const AuthorizationFailure([String message = 'Not authorized'])
      : super(message);
}

/// Failure when a resource is not found (e.g., 404)
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Resource not found'])
      : super(message);
}

/// Failure when local storage operations fail
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache operation failed'])
      : super(message);
}

/// Failure when validation fails
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

/// Failure for unknown errors
class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'An unknown error occurred'])
      : super(message);
}
