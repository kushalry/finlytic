import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/types/money.dart';
import '../../../transactions/data/providers/transaction_providers.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

part 'dashboard_providers.g.dart';

/// Holds the currently-selected month for the dashboard.
@Riverpod(keepAlive: true)
class SelectedMonth extends _$SelectedMonth {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void next() {
    final s = state;
    state = DateTime(s.year, s.month + 1);
  }

  void previous() {
    final s = state;
    state = DateTime(s.year, s.month - 1);
  }
}

/// Watches transactions for the currently-selected month.
@riverpod
Stream<List<TransactionEntity>> transactionsForSelectedMonth(
  TransactionsForSelectedMonthRef ref,
) {
  final month = ref.watch(selectedMonthProvider);
  final from = DateTime(month.year, month.month);
  final to = DateTime(month.year, month.month + 1);
  return ref
      .watch(watchTransactionsInRangeUseCaseProvider)
      .call(from, to);
}

/// Totals derived from the month's transactions.
class MonthSummary {
  final Money totalIncome;
  final Money totalExpense;
  final Money net;
  final int transactionCount;

  const MonthSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.net,
    required this.transactionCount,
  });
}

@riverpod
MonthSummary monthSummary(MonthSummaryRef ref) {
  final async = ref.watch(transactionsForSelectedMonthProvider);
  final list = async.valueOrNull ?? const <TransactionEntity>[];

  var income = 0;
  var expense = 0;
  for (final t in list) {
    switch (t.kind) {
      case TransactionKind.income:
        income += t.amount.minorUnits.abs();
      case TransactionKind.expense:
        expense += t.amount.minorUnits.abs();
      case TransactionKind.transfer:
        break;
    }
  }

  return MonthSummary(
    totalIncome: Money.fromMinor(income, 'INR'),
    totalExpense: Money.fromMinor(expense, 'INR'),
    net: Money.fromMinor(income - expense, 'INR'),
    transactionCount: list.length,
  );
}

/// Aggregates expenses by category for the selected month.
/// Returns a list of (category, totalMinor) sorted descending.
@riverpod
List<CategorySpend> expenseByCategory(ExpenseByCategoryRef ref) {
  final async = ref.watch(transactionsForSelectedMonthProvider);
  final list = async.valueOrNull ?? const <TransactionEntity>[];

  final totals = <int, int>{};
  for (final t in list) {
    if (t.kind != TransactionKind.expense) continue;
    if (t.categoryId == null) continue;
    totals[t.categoryId!] =
        (totals[t.categoryId!] ?? 0) + t.amount.minorUnits.abs();
  }

  final entries = totals.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return entries
      .map((e) => CategorySpend(categoryId: e.key, totalMinor: e.value))
      .toList();
}

class CategorySpend {
  final int categoryId;
  final int totalMinor;
  const CategorySpend({required this.categoryId, required this.totalMinor});
}

/// Watches all categories keyed by id for fast lookup from charts.
@riverpod
Stream<Map<int, Category>> categoriesById(CategoriesByIdRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.categoryDao
      .watchActive()
      .map((list) => {for (final c in list) c.id: c});
}