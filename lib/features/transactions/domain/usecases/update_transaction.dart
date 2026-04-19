import '../../../../core/errors/failure.dart';
import '../../../../core/types/result.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class UpdateTransactionUseCase {
  final TransactionRepository _repository;

  const UpdateTransactionUseCase(this._repository);

  Future<Result<TransactionEntity>> call(TransactionEntity input) async {
    if (!input.isPersisted) {
      return const Result.failure(
        Failure.validation(message: 'Cannot update a transaction without an id'),
      );
    }
    if (input.amount.isZero || input.amount.isNegative) {
      return const Result.failure(
        Failure.validation(message: 'Amount must be greater than zero'),
      );
    }
    return _repository.update(input);
  }
}