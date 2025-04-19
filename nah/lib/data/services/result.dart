sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T data;

  Success(this.data);
}

class Failure<T> extends Result<T> {
  final Exception error;

  Failure(this.error);
}
// This class is sealed, a feature introduced in Dart 3.
// The `sealed` keyword restricts subclassing to the same file,
// improving maintainability and enforcing stricter design constraints.