// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$budgetsForMonthHash() => r'abe04ea84efc87a345de7b168a22bc571a79f029';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [budgetsForMonth].
@ProviderFor(budgetsForMonth)
const budgetsForMonthProvider = BudgetsForMonthFamily();

/// See also [budgetsForMonth].
class BudgetsForMonthFamily extends Family<AsyncValue<List<Budget>>> {
  /// See also [budgetsForMonth].
  const BudgetsForMonthFamily();

  /// See also [budgetsForMonth].
  BudgetsForMonthProvider call(
    int year,
    int month,
  ) {
    return BudgetsForMonthProvider(
      year,
      month,
    );
  }

  @override
  BudgetsForMonthProvider getProviderOverride(
    covariant BudgetsForMonthProvider provider,
  ) {
    return call(
      provider.year,
      provider.month,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'budgetsForMonthProvider';
}

/// See also [budgetsForMonth].
class BudgetsForMonthProvider extends AutoDisposeStreamProvider<List<Budget>> {
  /// See also [budgetsForMonth].
  BudgetsForMonthProvider(
    int year,
    int month,
  ) : this._internal(
          (ref) => budgetsForMonth(
            ref as BudgetsForMonthRef,
            year,
            month,
          ),
          from: budgetsForMonthProvider,
          name: r'budgetsForMonthProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$budgetsForMonthHash,
          dependencies: BudgetsForMonthFamily._dependencies,
          allTransitiveDependencies:
              BudgetsForMonthFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  BudgetsForMonthProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  Override overrideWith(
    Stream<List<Budget>> Function(BudgetsForMonthRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BudgetsForMonthProvider._internal(
        (ref) => create(ref as BudgetsForMonthRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Budget>> createElement() {
    return _BudgetsForMonthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BudgetsForMonthProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BudgetsForMonthRef on AutoDisposeStreamProviderRef<List<Budget>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _BudgetsForMonthProviderElement
    extends AutoDisposeStreamProviderElement<List<Budget>>
    with BudgetsForMonthRef {
  _BudgetsForMonthProviderElement(super.provider);

  @override
  int get year => (origin as BudgetsForMonthProvider).year;
  @override
  int get month => (origin as BudgetsForMonthProvider).month;
}

String _$budgetProgressForSelectedMonthHash() =>
    r'701f024bf425e54fb4f63154469413119938938c';

/// Streams budget progress for the selected month. Combines three reactive
/// sources (budgets, transactions, categories) so the UI auto-updates whenever
/// any of them change.
///
/// Copied from [budgetProgressForSelectedMonth].
@ProviderFor(budgetProgressForSelectedMonth)
final budgetProgressForSelectedMonthProvider =
    AutoDisposeStreamProvider<List<BudgetProgress>>.internal(
  budgetProgressForSelectedMonth,
  name: r'budgetProgressForSelectedMonthProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetProgressForSelectedMonthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetProgressForSelectedMonthRef
    = AutoDisposeStreamProviderRef<List<BudgetProgress>>;
String _$budgetsMonthHash() => r'e0f48a0728345abef43e4f93ed992810b6fda496';

/// Holds the currently-selected month for the budgets screen.
///
/// Copied from [BudgetsMonth].
@ProviderFor(BudgetsMonth)
final budgetsMonthProvider = NotifierProvider<BudgetsMonth, DateTime>.internal(
  BudgetsMonth.new,
  name: r'budgetsMonthProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$budgetsMonthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BudgetsMonth = Notifier<DateTime>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
