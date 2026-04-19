import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class WatchTransactionsUseCase {
  final TransactionRepository _repository;

  const WatchTransactionsUseCase(this._repository);

  Stream<List<TransactionEntity>> call() => _repository.watchAll();
}