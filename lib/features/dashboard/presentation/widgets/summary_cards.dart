import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/types/money.dart';
import '../../../../core/utils/currency_formatter.dart';

class SummaryCards extends StatelessWidget {
  const SummaryCards({
    super.key,
    required this.income,
    required this.expense,
    required this.net,
  });

  final Money income;
  final Money expense;
  final Money net;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Card(
            label: 'Income',
            amount: CurrencyFormatter.format(income),
            color: AppColors.income,
            icon: Icons.arrow_downward,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Card(
            label: 'Expense',
            amount: CurrencyFormatter.format(expense),
            color: AppColors.expense,
            icon: Icons.arrow_upward,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Card(
            label: 'Net',
            amount: CurrencyFormatter.format(net.abs()),
            color: net.isNegative ? AppColors.expense : AppColors.income,
            icon: net.isNegative ? Icons.trending_down : Icons.trending_up,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String label;
  final String amount;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}