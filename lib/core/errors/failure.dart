import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Typed failures that flow through the use-case layer.
///
/// We prefer Either<Failure, T> over throwing exceptions because:
/// - Exceptions are invisible in type signatures
/// - Sealed failures force exhaustive handling at the UI layer
/// - Business errors (validation) and technical errors (DB down) stay distinct
@freezed
sealed class Failure with _$Failure {
  const factory Failure.validation({required String message}) =
      ValidationFailure;

  const factory Failure.notFound({required String entity, required Object id}) =
      NotFoundFailure;

  const factory Failure.database({required String message, Object? cause}) =
      DatabaseFailure;

  const factory Failure.unknown({required Object error, StackTrace? stack}) =
      UnknownFailure;
}