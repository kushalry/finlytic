import '../../../../core/errors/failure.dart';
import '../../../../core/types/result.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

/// Validates and persists a new transaction.
///
/// Rules enforced here (not in UI, not in DB):
/// - Amount must be positive (direction is carried by [TransactionKind])
/// - Expense/income must have a category
/// - Note length is capped at 200 chars
/// - occurredAt cannot be more than 1 day in the future
class AddTransactionUseCase {
  final TransactionRepository _repository;

  const AddTransactionUseCase(this._repository);

  Future<Result<TransactionEntity>> call(TransactionEntity input) async {
    final validation = _validate(input);
    if (validation != null) {
      return Result.failure(Failure.validation(message: validation));
    }
    return _repository.add(input);
  }

  String? _validate(TransactionEntity t) {
    if (t.amount.isZero || t.amount.isNegative) {
      return 'Amount must be greater than zero';
    }
    if (t.kind != TransactionKind.transfer && t.categoryId == null) {
      return 'Category is required for income and expenses';
    }
    if ((t.note?.length ?? 0) > 200) {
      return 'Note is too long (max 200 characters)';
    }
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    if (t.occurredAt.isAfter(tomorrow)) {
      return 'Transaction date cannot be in the future';
    }
    return null;
  }
}