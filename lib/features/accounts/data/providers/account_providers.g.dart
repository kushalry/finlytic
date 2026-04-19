// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeAccountsHash() => r'03b66e5982b2d1d899d00e1957440ec492152cd7';

/// See also [activeAccounts].
@ProviderFor(activeAccounts)
final activeAccountsProvider =
    AutoDisposeStreamProvider<List<Account>>.internal(
  activeAccounts,
  name: r'activeAccountsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeAccountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveAccountsRef = AutoDisposeStreamProviderRef<List<Account>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
