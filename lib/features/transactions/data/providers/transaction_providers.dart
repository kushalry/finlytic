import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_provider.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/update_transaction.dart';
import '../../domain/usecases/watch_transactions.dart';
import '../../domain/usecases/watch_transactions_in_range.dart';
import '../repositories/transaction_repository_impl.dart';

part 'transaction_providers.g.dart';

@Riverpod(keepAlive: true)
TransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  return TransactionRepositoryImpl(ref.watch(appDatabaseProvider));
}

@riverpod
AddTransactionUseCase addTransactionUseCase(AddTransactionUseCaseRef ref) =>
    AddTransactionUseCase(ref.watch(transactionRepositoryProvider));

@riverpod
UpdateTransactionUseCase updateTransactionUseCase(
        UpdateTransactionUseCaseRef ref) =>
    UpdateTransactionUseCase(ref.watch(transactionRepositoryProvider));

@riverpod
DeleteTransactionUseCase deleteTransactionUseCase(
        DeleteTransactionUseCaseRef ref) =>
    DeleteTransactionUseCase(ref.watch(transactionRepositoryProvider));

@riverpod
WatchTransactionsUseCase watchTransactionsUseCase(
        WatchTransactionsUseCaseRef ref) =>
    WatchTransactionsUseCase(ref.watch(transactionRepositoryProvider));

@riverpod
WatchTransactionsInRangeUseCase watchTransactionsInRangeUseCase(
        WatchTransactionsInRangeUseCaseRef ref) =>
    WatchTransactionsInRangeUseCase(ref.watch(transactionRepositoryProvider));