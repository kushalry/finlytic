import 'package:drift/drift.dart';
import '../../../../core/database/daos/transaction_dao.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/database/tables.dart';

part 'budget_providers.g.dart';

@riverpod
Stream<List<Budget>> budgetsForMonth(
  BudgetsForMonthRef ref,
  int year,
  int month,
) {
  final db = ref.watch(appDatabaseProvider);
  return db.budgetDao.watchForMonth(year, month);
}

/// Holds the currently-selected month for the budgets screen.
@Riverpod(keepAlive: true)
class BudgetsMonth extends _$BudgetsMonth {
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

class BudgetProgress {
  final Budget budget;
  final Category category;
  final int spentMinor;
  final double percent;

  const BudgetProgress({
    required this.budget,
    required this.category,
    required this.spentMinor,
    required this.percent,
  });

  bool get isOverBudget => percent > 1.0;
  bool get isNearLimit => percent >= 0.8 && !isOverBudget;
  int get remainingMinor => budget.amountMinor - spentMinor;
}

/// Streams budget progress for the selected month. Combines three reactive
/// sources (budgets, transactions, categories) so the UI auto-updates whenever
/// any of them change.
@riverpod
Stream<List<BudgetProgress>> budgetProgressForSelectedMonth(
  BudgetProgressForSelectedMonthRef ref,
) {
  final month = ref.watch(budgetsMonthProvider);
  final db = ref.watch(appDatabaseProvider);

  final from = DateTime(month.year, month.month);
  final to = DateTime(month.year, month.month + 1);

  final budgets$ = db.budgetDao.watchForMonth(month.year, month.month);
  final transactions$ = db.transactionDao.watchInRange(from, to);
  final categories$ = db.categoryDao.watchActive();

  return Rx.combineLatest3<List<Budget>, List<TransactionWithRefs>,
      List<Category>, List<BudgetProgress>>(
    budgets$,
    transactions$,
    categories$,
    (budgets, txRows, categories) {
      if (budgets.isEmpty) return const [];

      // Aggregate expense spending per category for the month.
      final spending = <int, int>{};
      for (final row in txRows) {
        final t = row.transaction;
        if (t.type != TransactionType.expense) continue;
        if (t.categoryId == null) continue;
        final amt = t.amountMinor.abs();
        spending[t.categoryId!] = (spending[t.categoryId!] ?? 0) + amt;
      }

      final byId = {for (final c in categories) c.id: c};

      return budgets
          .map((b) {
            final cat = byId[b.categoryId];
            if (cat == null) return null;
            final spent = spending[b.categoryId] ?? 0;
            final pct = b.amountMinor == 0 ? 0.0 : spent / b.amountMinor;
            return BudgetProgress(
              budget: b,
              category: cat,
              spentMinor: spent,
              percent: pct,
            );
          })
          .whereType<BudgetProgress>()
          .toList()
        ..sort((a, b) => b.percent.compareTo(a.percent));
    },
  );
}