import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/tables.dart' as tables;
import '../../../../core/types/money.dart';
import '../../domain/entities/transaction_entity.dart';

/// Converts between Drift rows and domain entities.
class TransactionMapper {
  const TransactionMapper();

  TransactionEntity toEntity(db.Transaction row, {String currencyCode = 'INR'}) {
    return TransactionEntity(
      id: row.id,
      accountId: row.accountId,
      categoryId: row.categoryId,
      kind: _kindFromDb(row.type),
      amount: Money.fromMinor(row.amountMinor.abs(), currencyCode),
      note: row.note,
      occurredAt: row.occurredAt,
      transferGroupId: row.transferGroupId,
    );
  }

  db.TransactionsCompanion toCompanion(TransactionEntity entity) {
    return db.TransactionsCompanion(
      id: entity.id == null ? const Value.absent() : Value(entity.id!),
      accountId: Value(entity.accountId),
      categoryId: Value(entity.categoryId),
      type: Value(_kindToDb(entity.kind)),
      amountMinor: Value(entity.signedAmountMinor),
      note: Value(entity.note),
      occurredAt: Value(entity.occurredAt),
      transferGroupId: Value(entity.transferGroupId),
      updatedAt: Value(DateTime.now()),
    );
  }

  TransactionKind _kindFromDb(tables.TransactionType t) => switch (t) {
        tables.TransactionType.income => TransactionKind.income,
        tables.TransactionType.expense => TransactionKind.expense,
        tables.TransactionType.transfer => TransactionKind.transfer,
      };

  tables.TransactionType _kindToDb(TransactionKind k) => switch (k) {
        TransactionKind.income => tables.TransactionType.income,
        TransactionKind.expense => tables.TransactionType.expense,
        TransactionKind.transfer => tables.TransactionType.transfer,
      };
}