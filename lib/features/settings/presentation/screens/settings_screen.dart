import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.label_outline),
            title: const Text('Categories'),
            subtitle: const Text('Add, edit, archive categories'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/settings/categories'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('Finlytic v0.1.0'),
          ),
        ],
      ),
    );
  }
}