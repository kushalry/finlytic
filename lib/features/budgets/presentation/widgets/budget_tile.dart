import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/types/money.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/providers/budget_providers.dart';

class BudgetTile extends StatelessWidget {
  const BudgetTile({
    super.key,
    required this.progress,
    required this.onTap,
    required this.onDelete,
  });

  final BudgetProgress progress;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final statusColor = progress.isOverBudget
        ? AppColors.expense
        : progress.isNearLimit
            ? Colors.orange
            : AppColors.income;

    return Dismissible(
      key: ValueKey(progress.budget.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AppColors.expense,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor:
                        _parseColor(progress.category.colorHex).withOpacity(0.2),
                    child: Icon(
                      Icons.label,
                      size: 14,
                      color: _parseColor(progress.category.colorHex),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      progress.category.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    '${(progress.percent * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0,
                    end: progress.percent.clamp(0.0, 1.0),
                  ),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  builder: (_, value, __) => LinearProgressIndicator(
                    value: value,
                    minHeight: 8,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${CurrencyFormatter.format(Money.fromMinor(progress.spentMinor, "INR"))} '
                    'of ${CurrencyFormatter.format(Money.fromMinor(progress.budget.amountMinor, "INR"))}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    progress.isOverBudget
                        ? 'Over by ${CurrencyFormatter.format(Money.fromMinor(-progress.remainingMinor, "INR"))}'
                        : '${CurrencyFormatter.format(Money.fromMinor(progress.remainingMinor, "INR"))} left',
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }
}