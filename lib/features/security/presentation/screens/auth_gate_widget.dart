import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/security_providers.dart';
import 'lock_screen.dart';

class AuthGateWidget extends ConsumerStatefulWidget {
  const AuthGateWidget({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AuthGateWidget> createState() => _AuthGateWidgetState();
}

class _AuthGateWidgetState extends ConsumerState<AuthGateWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Lock when the app goes to the background.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      ref.read(authGateProvider.notifier).lock();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lockEnabledAsync = ref.watch(lockEnabledProvider);
    final isAuthed = ref.watch(authGateProvider);

    return lockEnabledAsync.when(
      loading: () => const _Splash(),
      error: (_, __) => widget.child, // fail-open on pref read error
      data: (enabled) {
        if (!enabled || isAuthed) return widget.child;
        return const LockScreen();
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}