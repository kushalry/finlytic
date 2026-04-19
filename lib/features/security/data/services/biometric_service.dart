import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth;

  BiometricService([LocalAuthentication? auth])
      : _auth = auth ?? LocalAuthentication();

  /// True if the device has biometric hardware that's enrolled.
  Future<bool> isAvailable() async {
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) return false;
      final canCheck = await _auth.canCheckBiometrics;
      if (!canCheck) return false;
      final available = await _auth.getAvailableBiometrics();
      return available.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Prompts the user. Returns true on success, false on cancel/failure.
  Future<bool> authenticate({String reason = 'Unlock Finlytic'}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,          // survives app backgrounding mid-auth
          biometricOnly: true,        // don't fall back to device PIN
          useErrorDialogs: true,      // show OS-native errors
        ),
      );
    } catch (_) {
      return false;
    }
  }
}