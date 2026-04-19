// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'25eceea0052302f519f44a896409ba30ede45562';

/// See also [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = FutureProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = FutureProviderRef<SharedPreferences>;
String _$securityPrefsHash() => r'58ef0674326ca0fd220d456edaae34bdf50d5315';

/// See also [securityPrefs].
@ProviderFor(securityPrefs)
final securityPrefsProvider = FutureProvider<SecurityPrefs>.internal(
  securityPrefs,
  name: r'securityPrefsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$securityPrefsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SecurityPrefsRef = FutureProviderRef<SecurityPrefs>;
String _$biometricServiceHash() => r'6ae0b2394993f9985372fe6fa65fdea59aed395a';

/// See also [biometricService].
@ProviderFor(biometricService)
final biometricServiceProvider = Provider<BiometricService>.internal(
  biometricService,
  name: r'biometricServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$biometricServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BiometricServiceRef = ProviderRef<BiometricService>;
String _$lockEnabledHash() => r'87856f356ab760e71398c8cf9ebe094653a0a657';

/// Is lock enabled in user prefs? Simple boolean exposed reactively.
///
/// Copied from [LockEnabled].
@ProviderFor(LockEnabled)
final lockEnabledProvider =
    AutoDisposeAsyncNotifierProvider<LockEnabled, bool>.internal(
  LockEnabled.new,
  name: r'lockEnabledProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$lockEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LockEnabled = AutoDisposeAsyncNotifier<bool>;
String _$authGateHash() => r'5087757eb72184fa1ff7d2f859a93122cb89e5be';

/// True once the user has passed biometric auth for this session.
/// Reset to false whenever the app is resumed from background.
///
/// Copied from [AuthGate].
@ProviderFor(AuthGate)
final authGateProvider = NotifierProvider<AuthGate, bool>.internal(
  AuthGate.new,
  name: r'authGateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authGateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthGate = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
