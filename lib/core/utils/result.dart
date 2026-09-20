/// A simple success/failure result wrapper used throughout the services layer.
sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(String message, [Object? error]) = Failure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Object? error) failure,
  }) {
    final self = this;
    if (self is Success<T>) return success(self.data);
    if (self is Failure<T>) return failure(self.message, self.error);
    throw StateError('Unknown Result subtype');
  }
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.message, [this.error]);
  final String message;
  final Object? error;
}
