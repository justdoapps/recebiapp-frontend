sealed class Result<T> {
  const Result();
  const factory Result.ok(T value) = Ok._;
  const factory Result.error(Exception error) = Error._;
  static Result<void> okVoid() => const Result.ok(null);
  static Result<void> errorVoid() => Result.error(Exception(''));

  R fold<R>(R Function(Exception error) onError, R Function(T value) onOk) {
    return switch (this) {
      Ok(value: final value) => onOk(value),
      Error(error: final error) => onError(error),
    };
  }
}

final class Ok<T> extends Result<T> {
  const Ok._(this.value);
  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

final class Error<T> extends Result<T> {
  const Error._(this.error);
  final Exception error;

  @override
  String toString() => 'Result<$T>.error($error)';
}
