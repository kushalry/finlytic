import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/database/tables.dart';
import '../providers/category_providers.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(allActiveCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (categories) {
          final income =
              categories.where((c) => c.type == CategoryType.income).toList();
          final expense =
              categories.where((c) => c.type == CategoryType.expense).toList();

          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              const _SectionHeader('Income'),
              ...income.map((c) => _CategoryTile(category: c)),
              const _SectionHeader('Expense'),
              ...expense.map((c) => _CategoryTile(category: c)),
            ],
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    CategoryType type = CategoryType.expense;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('New category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              SegmentedButton<CategoryType>(
                segments: const [
                  ButtonSegment(
                    value: CategoryType.expense,
                    label: Text('Expense'),
                  ),
                  ButtonSegment(
                    value: CategoryType.income,
                    label: Text('Income'),
                  ),
                ],
                selected: {type},
                onSelectionChanged: (s) => setState(() => type = s.first),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                final db = ref.read(appDatabaseProvider);
                await db.categoryDao.insertCategory(
                  CategoriesCompanion.insert(
                    name: name,
                    type: type,
                    colorHex: type == CategoryType.income
                        ? '#2E7D32'
                        : '#E65100',
                    iconName: 'label',
                  ),
                );
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _CategoryTile extends ConsumerWidget {
  const _CategoryTile({required this.category});
  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _parseColor(category.colorHex).withOpacity(0.2),
        child: Icon(Icons.label, color: _parseColor(category.colorHex)),
      ),
      title: Text(category.name),
      trailing: IconButton(
        icon: const Icon(Icons.archive_outlined),
        onPressed: () async {
          final db = ref.read(appDatabaseProvider);
          await db.categoryDao.archiveCategory(category.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Archived "${category.name}"')),
            );
          }
        },
      ),
    );
  }

  Color _parseColor(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }
}