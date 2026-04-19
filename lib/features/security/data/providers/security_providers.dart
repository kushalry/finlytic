import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/biometric_service.dart';
import '../services/security_prefs.dart';

part 'security_providers.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) =>
    SharedPreferences.getInstance();

@Riverpod(keepAlive: true)
Future<SecurityPrefs> securityPrefs(SecurityPrefsRef ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return SecurityPrefs(prefs);
}

@Riverpod(keepAlive: true)
BiometricService biometricService(BiometricServiceRef ref) => BiometricService();

/// Is lock enabled in user prefs? Simple boolean exposed reactively.
@riverpod
class LockEnabled extends _$LockEnabled {
  @override
  Future<bool> build() async {
    final prefs = await ref.watch(securityPrefsProvider.future);
    return prefs.isLockEnabled;
  }

  Future<void> set(bool value) async {
    final prefs = await ref.read(securityPrefsProvider.future);
    await prefs.setLockEnabled(value);
    ref.invalidateSelf();
  }
}

/// True once the user has passed biometric auth for this session.
/// Reset to false whenever the app is resumed from background.
@Riverpod(keepAlive: true)
class AuthGate extends _$AuthGate {
  @override
  bool build() => false;

  void markAuthenticated() => state = true;
  void lock() => state = false;
}