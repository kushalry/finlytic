import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/theme_provider.dart';
import '../../../security/data/providers/security_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeControllerProvider);
    final lockEnabledAsync = ref.watch(lockEnabledProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Security'),
          lockEnabledAsync.when(
            loading: () => const ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('App lock'),
              trailing: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (e, _) => ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('App lock'),
              subtitle: Text('Error: $e'),
            ),
            data: (enabled) => SwitchListTile(
              secondary: const Icon(Icons.lock_outline),
              title: const Text('App lock'),
              subtitle: const Text(
                'Require biometric auth to open Finlytic',
              ),
              value: enabled,
              onChanged: (value) async {
                if (value) {
                  final service = ref.read(biometricServiceProvider);
                  final available = await service.isAvailable();
                  if (!available) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Biometrics not available on this device',
                          ),
                        ),
                      );
                    }
                    return;
                  }
                  final ok = await service.authenticate(
                    reason: 'Enable app lock',
                  );
                  if (!ok) return;
                }
                await ref
                    .read(lockEnabledProvider.notifier)
                    .set(value);
              },
            ),
          ),
          const _SectionHeader('Appearance'),
          RadioListTile<ThemeMode>(
            value: ThemeMode.system,
            groupValue: mode,
            title: const Text('System default'),
            onChanged: (v) =>
                ref.read(themeModeControllerProvider.notifier).set(v!),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            groupValue: mode,
            title: const Text('Light'),
            onChanged: (v) =>
                ref.read(themeModeControllerProvider.notifier).set(v!),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: mode,
            title: const Text('Dark'),
            onChanged: (v) =>
                ref.read(themeModeControllerProvider.notifier).set(v!),
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