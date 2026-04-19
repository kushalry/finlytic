import '../../../../core/types/result.dart';
import '../repositories/transaction_repository.dart';

class DeleteTransactionUseCase {
  final TransactionRepository _repository;

  const DeleteTransactionUseCase(this._repository);

  Future<Result<void>> call(int id) => _repository.delete(id);
}