import 'package:drift/native.dart';
import 'package:finlytic/core/database/app_database.dart';
import 'package:finlytic/core/database/tables.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('AppDatabase migrations & seed', () {
    test('seeds default categories on first create', () async {
      final all = await db.select(db.categories).get();
      expect(all.length, greaterThanOrEqualTo(6));
      expect(all.where((c) => c.type == CategoryType.income).length,
          greaterThanOrEqualTo(1));
      expect(all.where((c) => c.type == CategoryType.expense).length,
          greaterThanOrEqualTo(4));
    });
  });

  group('TransactionDao', () {
    test('insert and read back a transaction', () async {
      // Arrange: create an account first
      final accountId = await db.accountDao.insertAccount(
        AccountsCompanion.insert(
          name: 'Test Savings',
          type: AccountType.bank,
          colorHex: '#1E88E5',
          iconName: 'account_balance',
        ),
      );

      // Act: insert an expense
      await db.transactionDao.insertTransaction(
        TransactionsCompanion.insert(
          accountId: accountId,
          type: TransactionType.expense,
          amountMinor: 25000, // ₹250.00
          occurredAt: DateTime(2026, 4, 15),
          categoryId: const Value(2), // seeded "Food & Dining"
          note: const Value('Lunch'),
        ),
      );

      // Assert
      final rows = await db.select(db.transactions).get();
      expect(rows, hasLength(1));
      expect(rows.first.amountMinor, 25000);
      expect(rows.first.note, 'Lunch');
    });

    test('expenseByCategoryForMonth aggregates correctly', () async {
      final accountId = await db.accountDao.insertAccount(
        AccountsCompanion.insert(
          name: 'Test',
          type: AccountType.bank,
          colorHex: '#000000',
          iconName: 'x',
        ),
      );

      // Two expenses in Food category for April 2026
      for (final amount in [10000, 15000]) {
        await db.transactionDao.insertTransaction(
          TransactionsCompanion.insert(
            accountId: accountId,
            type: TransactionType.expense,
            amountMinor: amount,
            occurredAt: DateTime(2026, 4, 10),
            categoryId: const Value(2),
          ),
        );
      }

      // One expense in a different month — should NOT be in result
      await db.transactionDao.insertTransaction(
        TransactionsCompanion.insert(
          accountId: accountId,
          type: TransactionType.expense,
          amountMinor: 99999,
          occurredAt: DateTime(2026, 3, 10),
          categoryId: const Value(2),
        ),
      );

      final result =
          await db.transactionDao.expenseByCategoryForMonth(2026, 4);

      expect(result[2], 25000);
      expect(result.containsValue(99999), isFalse);
    });
  });
}