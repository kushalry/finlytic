import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'budget_dao.g.dart';

@DriftAccessor(tables: [Budgets])
class BudgetDao extends DatabaseAccessor<AppDatabase>
    with _$BudgetDaoMixin {
  BudgetDao(super.db);

  Stream<List<Budget>> watchForMonth(int year, int month) =>
      (select(budgets)
            ..where((b) => b.year.equals(year) & b.month.equals(month)))
          .watch();

  Future<int> upsertBudget(BudgetsCompanion entry) =>
      into(budgets).insertOnConflictUpdate(entry);

  Future<int> deleteBudget(int id) =>
      (delete(budgets)..where((b) => b.id.equals(id))).go();
}