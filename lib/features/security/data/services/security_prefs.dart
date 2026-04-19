import 'package:shared_preferences/shared_preferences.dart';

class SecurityPrefs {
  static const _kLockEnabled = 'security.lock_enabled';

  final SharedPreferences _prefs;
  SecurityPrefs(this._prefs);

  bool get isLockEnabled => _prefs.getBool(_kLockEnabled) ?? false;

  Future<void> setLockEnabled(bool value) =>
      _prefs.setBool(_kLockEnabled, value);
}