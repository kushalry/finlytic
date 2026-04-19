import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class WatchTransactionsInRangeUseCase {
  final TransactionRepository _repository;

  const WatchTransactionsInRangeUseCase(this._repository);

  Stream<List<TransactionEntity>> call(DateTime from, DateTime to) =>
      _repository.watchInRange(from, to);
}