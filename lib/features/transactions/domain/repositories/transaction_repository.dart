import '../../../../core/errors/failure.dart';
import '../../../../core/types/result.dart';
import '../entities/transaction_entity.dart';

/// Contract for transaction persistence. The domain layer depends on this
/// interface; the data layer provides the implementation (Drift-backed).
///
/// This separation lets us:
/// - Test use cases with a fake repository
/// - Swap storage backends without changing business logic
/// - Keep domain code free of any Flutter/DB imports
abstract interface class TransactionRepository {
  /// Watches all transactions, newest first. Emits a new list on any change.
  Stream<List<TransactionEntity>> watchAll();

  /// Watches transactions within [from, to). End is exclusive.
  Stream<List<TransactionEntity>> watchInRange(DateTime from, DateTime to);

  Future<Result<TransactionEntity>> getById(int id);

  Future<Result<TransactionEntity>> add(TransactionEntity transaction);

  Future<Result<TransactionEntity>> update(TransactionEntity transaction);

  Future<Result<void>> delete(int id);

  /// Sum of expenses grouped by categoryId for the given month.
  /// Returned as a map: categoryId -> total minor units.
  Future<Result<Map<int, int>>> expenseByCategoryForMonth(int year, int month);
}