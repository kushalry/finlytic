import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/app_database.dart';
import '../../../categories/data/providers/category_providers.dart';
import '../../data/providers/transaction_list_provider.dart';
import '../widgets/transaction_tile.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionListProvider);
    final categoriesAsync = ref.watch(allActiveCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/transactions/new'),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: transactionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (transactions) {
          if (transactions.isEmpty) return const _EmptyState();
          final categories = categoriesAsync.valueOrNull ?? const <Category>[];
          final categoryById = {for (final c in categories) c.id: c};

          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 96, top: 8),
            itemCount: transactions.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, indent: 72, endIndent: 16),
            itemBuilder: (context, i) {
              final t = transactions[i];
              return TransactionTile(
                transaction: t,
                category: t.categoryId != null
                    ? categoryById[t.categoryId!]
                    : null,
                onTap: () => context.push('/transactions/edit/${t.id}'),
              );
            },
          );
        },
      ),
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
            Icons.receipt_long,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 12),
          const Text(
            'No transactions yet',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap Add to record your first one',
            style: TextStyle(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}