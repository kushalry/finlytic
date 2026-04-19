import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth;

  BiometricService([LocalAuthentication? auth])
      : _auth = auth ?? LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      final available = await _auth.getAvailableBiometrics();

      if (kDebugMode) {
        debugPrint('[Biometric] isDeviceSupported: $supported');
        debugPrint('[Biometric] canCheckBiometrics: $canCheck');
        debugPrint('[Biometric] availableBiometrics: $available');
      }

      // Relaxed check: device-supported + at least one enrolled biometric.
      // Some Android skins (Funtouch/MIUI) report canCheckBiometrics=false
      // even when fingerprints work — so we don't gate on that.
      return supported && available.isNotEmpty;
    } catch (e, s) {
      if (kDebugMode) {
        debugPrint('[Biometric] isAvailable threw: $e\n$s');
      }
      return false;
    }
  }

  Future<bool> authenticate({String reason = 'Unlock Finlytic'}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e, s) {
      if (kDebugMode) {
        debugPrint('[Biometric] authenticate threw: $e\n$s');
      }
      return false;
    }
  }
}