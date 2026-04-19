import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
    required this.category,
    required this.onTap,
  });

  final TransactionEntity transaction;
  final Category? category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.kind == TransactionKind.expense;
    final amountColor = isExpense ? AppColors.expense : AppColors.income;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor:
            (isExpense ? AppColors.expense : AppColors.income).withOpacity(0.15),
        child: Icon(
          isExpense ? Icons.arrow_upward : Icons.arrow_downward,
          color: amountColor,
          size: 18,
        ),
      ),
      title: Text(category?.name ?? 'Uncategorized'),
      subtitle: Text(
        transaction.note?.isNotEmpty == true
            ? transaction.note!
            : _formatDate(transaction.occurredAt),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        CurrencyFormatter.formatSigned(transaction.amount, isExpense: isExpense),
        style: TextStyle(
          color: amountColor,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]}';
  }
}