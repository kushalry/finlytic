import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions, Categories, Accounts])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  /// Watches all transactions with their joined category and account,
  /// newest first. Returns a stream so UI auto-updates on writes.
  Stream<List<TransactionWithRefs>> watchAll() {
    final query = select(transactions).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      ),
      innerJoin(
        accounts,
        accounts.id.equalsExp(transactions.accountId),
      ),
    ])
      ..orderBy([OrderingTerm.desc(transactions.occurredAt)]);

    return query.watch().map(
          (rows) => rows
              .map((row) => TransactionWithRefs(
                    transaction: row.readTable(transactions),
                    category: row.readTableOrNull(categories),
                    account: row.readTable(accounts),
                  ))
              .toList(),
        );
  }

  /// Watches transactions within a date range. Used by dashboard and reports.
  Stream<List<TransactionWithRefs>> watchInRange(
    DateTime from,
    DateTime to,
  ) {
    final query = select(transactions).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      ),
      innerJoin(
        accounts,
        accounts.id.equalsExp(transactions.accountId),
      ),
    ])
      ..where(transactions.occurredAt.isBetweenValues(from, to))
      ..orderBy([OrderingTerm.desc(transactions.occurredAt)]);

    return query.watch().map(
          (rows) => rows
              .map((row) => TransactionWithRefs(
                    transaction: row.readTable(transactions),
                    category: row.readTableOrNull(categories),
                    account: row.readTable(accounts),
                  ))
              .toList(),
        );
  }

  Future<int> insertTransaction(TransactionsCompanion entry) =>
      into(transactions).insert(entry);

  Future<bool> updateTransaction(TransactionsCompanion entry) =>
      update(transactions).replace(entry);

  Future<int> deleteTransaction(int id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  /// Aggregates total expense per category for a given month.
  /// Returns a map of categoryId -> totalMinor.
  Future<Map<int, int>> expenseByCategoryForMonth(int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    final query = selectOnly(transactions)
      ..addColumns([transactions.categoryId, transactions.amountMinor.sum()])
      ..where(transactions.type.equalsValue(TransactionType.expense) &
          transactions.occurredAt.isBetweenValues(start, end))
      ..groupBy([transactions.categoryId]);

    final rows = await query.get();
    return {
      for (final row in rows)
        if (row.read(transactions.categoryId) != null)
          row.read(transactions.categoryId)!:
              row.read(transactions.amountMinor.sum()) ?? 0,
    };
  }
}

/// Aggregated view row — transaction plus its related category and account.
/// Modeled as plain Dart to keep the UI decoupled from Drift types.
class TransactionWithRefs {
  final Transaction transaction;
  final Category? category;
  final Account account;

  TransactionWithRefs({
    required this.transaction,
    required this.category,
    required this.account,
  });
}