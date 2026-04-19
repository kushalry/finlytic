import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'daos/account_dao.dart';
import 'daos/budget_dao.dart';
import 'daos/category_dao.dart';
import 'daos/transaction_dao.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Accounts, Categories, Transactions, Budgets],
daos: [AccountDao, CategoryDao, TransactionDao, BudgetDao],)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Optional constructor for tests — pass an in-memory executor.
  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedDefaults();
        },
        onUpgrade: (m, from, to) async {
          // Future migrations go here as schema evolves.
        },
      );

  /// Seeds sensible default categories on first launch so the app is usable
  /// immediately. Users can archive these or add their own.
  Future<void> _seedDefaults() async {
    await batch((b) {
      b.insertAll(accounts, [
        AccountsCompanion.insert(
          name: 'Cash',
          type: AccountType.cash,
          colorHex: '#558B2F',
          iconName: 'payments',
        ),
        AccountsCompanion.insert(
          name: 'Savings',
          type: AccountType.bank,
          colorHex: '#1565C0',
          iconName: 'account_balance',
        ),
      ]);
      b.insertAll(categories, [
        CategoriesCompanion.insert(
          name: 'Salary',
          type: CategoryType.income,
          colorHex: '#2E7D32',
          iconName: 'work',
        ),
        CategoriesCompanion.insert(
          name: 'Food & Dining',
          type: CategoryType.expense,
          colorHex: '#E65100',
          iconName: 'restaurant',
        ),
        CategoriesCompanion.insert(
          name: 'Groceries',
          type: CategoryType.expense,
          colorHex: '#558B2F',
          iconName: 'shopping_cart',
        ),
        CategoriesCompanion.insert(
          name: 'Transport',
          type: CategoryType.expense,
          colorHex: '#1565C0',
          iconName: 'directions_car',
        ),
        CategoriesCompanion.insert(
          name: 'Rent',
          type: CategoryType.expense,
          colorHex: '#4527A0',
          iconName: 'home',
        ),
        CategoriesCompanion.insert(
          name: 'Entertainment',
          type: CategoryType.expense,
          colorHex: '#C2185B',
          iconName: 'movie',
        ),
      ]);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'finlytic.sqlite'));

    // Workaround for some Android devices where temp directory isn't writable.
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}