import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/dashboard_providers.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/summary_cards.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final summary = ref.watch(monthSummaryProvider);
    final spends = ref.watch(expenseByCategoryProvider);
    final categoriesAsync = ref.watch(categoriesByIdProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MonthSwitcher(
            month: selectedMonth,
            onPrev: () =>
                ref.read(selectedMonthProvider.notifier).previous(),
            onNext: () => ref.read(selectedMonthProvider.notifier).next(),
          ),
          const SizedBox(height: 16),
          SummaryCards(
            income: summary.totalIncome,
            expense: summary.totalExpense,
            net: summary.net,
          ),
          const SizedBox(height: 24),
          Text(
            'Spending by category',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          categoriesAsync.when(
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Error: $e'),
            data: (categoriesById) => CategoryPieChart(
              spends: spends,
              categoriesById: categoriesById,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '${summary.transactionCount} transactions this month',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthSwitcher extends StatelessWidget {
  const _MonthSwitcher({
    required this.month,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: onPrev,
        ),
        const SizedBox(width: 8),
        Text(
          '${names[month.month - 1]} ${month.year}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: onNext,
        ),
      ],
    );
  }
}