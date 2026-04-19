import '../errors/failure.dart';

/// A value that is either a success (with data T) or a failure.
/// Used as the return type of every use case, so callers must handle both paths.
///
/// Hand-written as a sealed class (rather than Freezed) because it's small
/// and we want our own [map] / [fold] methods without name collisions.
sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = Err<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Err<T>;

  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        Err() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success() => null,
        Err(:final failure) => failure,
      };

  /// Transform success value, propagate failure unchanged.
  Result<R> map<R>(R Function(T) mapper) => switch (this) {
        Success(:final data) => Result.success(mapper(data)),
        Err(:final failure) => Result.failure(failure),
      };

  /// Fold into a single value by providing handlers for both paths.
  R fold<R>({
    required R Function(T) onSuccess,
    required R Function(Failure) onFailure,
  }) =>
      switch (this) {
        Success(:final data) => onSuccess(data),
        Err(:final failure) => onFailure(failure),
      };
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> && other.data == data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

final class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Err<T> && other.failure == failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Err($failure)';
}