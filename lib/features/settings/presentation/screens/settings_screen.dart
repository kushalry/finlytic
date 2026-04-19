import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Appearance'),
          RadioListTile<ThemeMode>(
            value: ThemeMode.system,
            groupValue: mode,
            title: const Text('System default'),
            onChanged: (v) => ref
                .read(themeModeControllerProvider.notifier)
                .set(v!),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            groupValue: mode,
            title: const Text('Light'),
            onChanged: (v) => ref
                .read(themeModeControllerProvider.notifier)
                .set(v!),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: mode,
            title: const Text('Dark'),
            onChanged: (v) => ref
                .read(themeModeControllerProvider.notifier)
                .set(v!),
          ),
          const _SectionHeader('Data'),
          ListTile(
            leading: const Icon(Icons.label_outline),
            title: const Text('Categories'),
            subtitle: const Text('Add, edit, archive categories'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/settings/categories'),
          ),
          const _SectionHeader('About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Finlytic'),
            subtitle: Text('Version 0.1.0'),
          ),
        ],
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
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1,
        ),
      ),
    );
  }
}