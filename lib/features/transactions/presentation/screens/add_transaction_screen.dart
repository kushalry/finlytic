import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables.dart' as tables;
import '../../../../core/types/money.dart';
import '../../../accounts/data/providers/account_providers.dart';
import '../../../categories/data/providers/category_providers.dart';
import '../../data/providers/transaction_providers.dart';
import '../../domain/entities/transaction_entity.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  TransactionKind _kind = TransactionKind.expense;
  int? _selectedAccountId;
  int? _selectedCategoryId;
  DateTime _occurredAt = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  tables.CategoryType get _neededCategoryType =>
      _kind == TransactionKind.income
          ? tables.CategoryType.income
          : tables.CategoryType.expense;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAccountId == null) {
      _showError('Please select an account');
      return;
    }
    if (_kind != TransactionKind.transfer && _selectedCategoryId == null) {
      _showError('Please select a category');
      return;
    }

    setState(() => _saving = true);

    final amount = Money.fromMajor(
      double.parse(_amountController.text),
      'INR',
    );

    final entity = TransactionEntity(
      accountId: _selectedAccountId!,
      categoryId: _selectedCategoryId,
      kind: _kind,
      amount: amount,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      occurredAt: _occurredAt,
    );

    final useCase = ref.read(addTransactionUseCaseProvider);
    final result = await useCase(entity);

    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      onSuccess: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction saved')),
        );
        context.pop();
      },
      onFailure: (failure) => _showError(failure.toString()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(activeAccountsProvider);
    final categoriesAsync =
        ref.watch(categoriesByTypeProvider(_neededCategoryType));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add transaction'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _submit,
            child: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<TransactionKind>(
              segments: const [
                ButtonSegment(
                  value: TransactionKind.expense,
                  label: Text('Expense'),
                  icon: Icon(Icons.arrow_upward),
                ),
                ButtonSegment(
                  value: TransactionKind.income,
                  label: Text('Income'),
                  icon: Icon(Icons.arrow_downward),
                ),
              ],
              selected: {_kind},
              onSelectionChanged: (s) {
                setState(() {
                  _kind = s.first;
                  _selectedCategoryId = null;
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter an amount';
                final parsed = double.tryParse(v);
                if (parsed == null) return 'Invalid number';
                if (parsed <= 0) return 'Must be greater than zero';
                return null;
              },
            ),
            const SizedBox(height: 16),
            accountsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Accounts error: $e'),
              data: (accounts) => DropdownButtonFormField<int>(
                value: _selectedAccountId,
                decoration: const InputDecoration(
                  labelText: 'Account',
                  border: OutlineInputBorder(),
                ),
                items: accounts
                    .map((a) => DropdownMenuItem(
                          value: a.id,
                          child: Text(a.name),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedAccountId = v),
              ),
            ),
            const SizedBox(height: 16),
            categoriesAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Categories error: $e'),
              data: (categories) => DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategoryId = v),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                border: OutlineInputBorder(),
              ),
              maxLength: 200,
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(
                '${_occurredAt.day}/${_occurredAt.month}/${_occurredAt.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _occurredAt,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 1)),
                );
                if (picked != null) setState(() => _occurredAt = picked);
              },
            ),
          ],
        ),
      ),
    );
  }
}