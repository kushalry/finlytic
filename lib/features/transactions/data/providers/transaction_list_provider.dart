import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/transaction_providers.dart';
import '../../domain/entities/transaction_entity.dart';

part 'transaction_list_provider.g.dart';

@riverpod
Stream<List<TransactionEntity>> transactionList(TransactionListRef ref) {
  return ref.watch(watchTransactionsUseCaseProvider).call();
}