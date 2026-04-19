import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/database/tables.dart' as tables;
import '../../../categories/presentation/providers/category_providers.dart';
import '../../data/providers/budget_providers.dart';
import '../widgets/budget_tile.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(budgetsMonthProvider);
    final progressAsync = ref.watch(budgetProgressForSelectedMonthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddBudgetSheet(context, ref, month),
        icon: const Icon(Icons.add),
        label: const Text('New budget'),
      ),
      body: Column(
        children: [
          _MonthSwitcher(
            month: month,
            onPrev: () =>
                ref.read(budgetsMonthProvider.notifier).previous(),
            onNext: () => ref.read(budgetsMonthProvider.notifier).next(),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: progressAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (progresses) {
                if (progresses.isEmpty) return const _EmptyState();
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 96, top: 4),
                  itemCount: progresses.length,
                  itemBuilder: (_, i) => BudgetTile(
                    progress: progresses[i],
                    onTap: () {},
                    onDelete: () async {
                      final db = ref.read(appDatabaseProvider);
                      await db.budgetDao
                          .deleteBudget(progresses[i].budget.id);
                      // invalidate to refresh the future provider
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBudgetSheet(
    BuildContext context,
    WidgetRef ref,
    DateTime month,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _AddBudgetSheet(month: month),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.pie_chart_outline,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 12),
          const Text(
            'No budgets for this month',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Set spending limits to stay on track',
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
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
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrev,
          ),
          const SizedBox(width: 8),
          Text(
            '${names[month.month - 1]} ${month.year}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class _AddBudgetSheet extends ConsumerStatefulWidget {
  const _AddBudgetSheet({required this.month});
  final DateTime month;

  @override
  ConsumerState<_AddBudgetSheet> createState() => _AddBudgetSheetState();
}

class _AddBudgetSheetState extends ConsumerState<_AddBudgetSheet> {
  final _amountController = TextEditingController();
  int? _categoryId;
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _err('Enter a valid amount');
      return;
    }
    if (_categoryId == null) {
      _err('Pick a category');
      return;
    }

    setState(() => _saving = true);
    final db = ref.read(appDatabaseProvider);
    await db.budgetDao.upsertBudget(
      BudgetsCompanion.insert(
        categoryId: _categoryId!,
        amountMinor: (amount * 100).round(),
        year: widget.month.year,
        month: widget.month.month,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _err(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final expenseCats = ref
        .watch(categoriesByTypeProvider(tables.CategoryType.expense))
        .valueOrNull ??
        const <Category>[];

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New budget',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: _categoryId,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: expenseCats
                .map((c) =>
                    DropdownMenuItem(value: c.id, child: Text(c.name)))
                .toList(),
            onChanged: (v) => setState(() => _categoryId = v),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Monthly limit',
              prefixText: '₹ ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}