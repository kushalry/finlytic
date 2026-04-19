import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:finlytic/core/database/app_database.dart';
import 'package:finlytic/core/database/tables.dart' as tables;
import 'package:finlytic/core/errors/failure.dart';
import 'package:finlytic/core/types/money.dart';
import 'package:finlytic/core/types/result.dart';
import 'package:finlytic/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:finlytic/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late TransactionRepositoryImpl repo;
  late int accountId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = TransactionRepositoryImpl(db);

    accountId = await db.accountDao.insertAccount(
      AccountsCompanion.insert(
        name: 'Test',
        type: tables.AccountType.bank,
        colorHex: '#000000',
        iconName: 'x',
      ),
    );
  });

  tearDown(() => db.close());

  TransactionEntity newExpense({int amountMinor = 10000, int? id}) =>
      TransactionEntity(
        id: id,
        accountId: accountId,
        categoryId: 2,
        kind: TransactionKind.expense,
        amount: Money.fromMinor(amountMinor, 'INR'),
        occurredAt: DateTime(2026, 4, 15),
      );

  test('add returns success with generated id', () async {
    final result = await repo.add(newExpense());
    expect(result.isSuccess, true);
    expect(result.dataOrNull?.id, isNotNull);
  });

  test('getById returns notFound for unknown id', () async {
    final result = await repo.getById(9999);
    expect(result.isFailure, true);
    expect(result.failureOrNull, isA<NotFoundFailure>());
  });

  test('update mutates persisted row', () async {
    final added = (await repo.add(newExpense())).dataOrNull!;
    final updated = added.copyWith(note: 'changed');

    final result = await repo.update(updated);
    expect(result.isSuccess, true);

    final reread = (await repo.getById(added.id!)).dataOrNull!;
    expect(reread.note, 'changed');
  });

  test('delete removes row', () async {
    final added = (await repo.add(newExpense())).dataOrNull!;
    final result = await repo.delete(added.id!);
    expect(result.isSuccess, true);

    final reread = await repo.getById(added.id!);
    expect(reread.isFailure, true);
  });

  test('watchAll emits updated list on insert', () async {
    final stream = repo.watchAll();
    final emissions = <List<TransactionEntity>>[];
    final sub = stream.listen(emissions.add);

    await Future.delayed(const Duration(milliseconds: 50));
    await repo.add(newExpense());
    await Future.delayed(const Duration(milliseconds: 50));
    await repo.add(newExpense(amountMinor: 20000));
    await Future.delayed(const Duration(milliseconds: 50));

    await sub.cancel();

    expect(emissions.last.length, 2);
  });
}