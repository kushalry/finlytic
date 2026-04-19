import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/types/money.dart';

part 'transaction_entity.freezed.dart';

enum TransactionKind { income, expense, transfer }

/// A money movement recorded by the user. This is the business-layer entity —
/// it knows nothing about databases or Flutter. Pure data + invariants.
@freezed
class TransactionEntity with _$TransactionEntity {
  const TransactionEntity._();

  const factory TransactionEntity({
    /// Null for not-yet-persisted transactions.
    int? id,
    required int accountId,
    int? categoryId,
    required TransactionKind kind,
    required Money amount,
    String? note,
    required DateTime occurredAt,

    /// Shared UUID linking the two rows of a transfer (out + in).
    String? transferGroupId,
  }) = _TransactionEntity;

  /// Expense transactions negatively affect account balance; income positively.
  /// Transfers are neutral in aggregate but move value between accounts.
  int get signedAmountMinor => switch (kind) {
        TransactionKind.income => amount.minorUnits.abs(),
        TransactionKind.expense => -amount.minorUnits.abs(),
        TransactionKind.transfer => amount.minorUnits, // sign is caller's decision
      };

  bool get isPersisted => id != null;
}