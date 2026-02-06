import '../error/failures.dart';

/// Result type for repository operations
/// Represents either a success with value T or a failure
sealed class Result<T> {
  const Result();

  /// Creates a successful result with a value
  factory Result.success(T value) = Success<T>;

  /// Creates a failed result with a Failure
  factory Result.failure(Failure failure) = Failed<T>;

  /// Returns true if this is a success result
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a failure result
  bool get isFailure => this is Failed<T>;

  /// Executes one of two functions depending on the result type
  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T value) onSuccess,
  ) {
    return switch (this) {
      Success(value: final value) => onSuccess(value),
      Failed(failure: final failure) => onFailure(failure),
    };
  }

  /// Transforms the success value if present
  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success(value: final value) => Result.success(transform(value)),
      Failed(failure: final failure) => Result.failure(failure),
    };
  }

  /// Returns the value if success, otherwise throws
  T getOrThrow() {
    return switch (this) {
      Success(value: final value) => value,
      Failed(failure: final failure) =>
        throw Exception('Result is a failure: ${failure.message}'),
    };
  }

  /// Returns the value if success, otherwise returns the default value
  T getOrElse(T defaultValue) {
    return switch (this) {
      Success(value: final value) => value,
      Failed() => defaultValue,
    };
  }

  /// Returns the failure if failed, otherwise null
  Failure? get failureOrNull {
    return switch (this) {
      Success() => null,
      Failed(failure: final failure) => failure,
    };
  }

  /// Returns the value if success, otherwise null
  T? get valueOrNull {
    return switch (this) {
      Success(value: final value) => value,
      Failed() => null,
    };
  }
}

/// Represents a successful result with a value
final class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);

  @override
  String toString() => 'Success($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Represents a failed result with a Failure
final class Failed<T> extends Result<T> {
  final Failure failure;

  const Failed(this.failure);

  @override
  String toString() => 'Failed($failure)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failed &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}
