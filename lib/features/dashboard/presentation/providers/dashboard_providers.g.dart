// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsForSelectedMonthHash() =>
    r'2119499e280900ae36e80eeea224cf0965e95c44';

/// Watches transactions for the currently-selected month.
///
/// Copied from [transactionsForSelectedMonth].
@ProviderFor(transactionsForSelectedMonth)
final transactionsForSelectedMonthProvider =
    AutoDisposeStreamProvider<List<TransactionEntity>>.internal(
  transactionsForSelectedMonth,
  name: r'transactionsForSelectedMonthProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionsForSelectedMonthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionsForSelectedMonthRef
    = AutoDisposeStreamProviderRef<List<TransactionEntity>>;
String _$monthSummaryHash() => r'0c7ccb6ca1e3e4a09521377ecc30083e1183eab6';

/// See also [monthSummary].
@ProviderFor(monthSummary)
final monthSummaryProvider = AutoDisposeProvider<MonthSummary>.internal(
  monthSummary,
  name: r'monthSummaryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$monthSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthSummaryRef = AutoDisposeProviderRef<MonthSummary>;
String _$expenseByCategoryHash() => r'922bb3643845a457f4380ff627c6a9e7bc5ee90a';

/// Aggregates expenses by category for the selected month.
/// Returns a list of (category, totalMinor) sorted descending.
///
/// Copied from [expenseByCategory].
@ProviderFor(expenseByCategory)
final expenseByCategoryProvider =
    AutoDisposeProvider<List<CategorySpend>>.internal(
  expenseByCategory,
  name: r'expenseByCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseByCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpenseByCategoryRef = AutoDisposeProviderRef<List<CategorySpend>>;
String _$categoriesByIdHash() => r'911a883767bdbebbe29ab323da616e47eaab996e';

/// Watches all categories keyed by id for fast lookup from charts.
///
/// Copied from [categoriesById].
@ProviderFor(categoriesById)
final categoriesByIdProvider =
    AutoDisposeStreamProvider<Map<int, Category>>.internal(
  categoriesById,
  name: r'categoriesByIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$categoriesByIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoriesByIdRef = AutoDisposeStreamProviderRef<Map<int, Category>>;
String _$selectedMonthHash() => r'039161d643b8dc7e7b231996811a4e1a21ab7a05';

/// Holds the currently-selected month for the dashboard.
///
/// Copied from [SelectedMonth].
@ProviderFor(SelectedMonth)
final selectedMonthProvider =
    NotifierProvider<SelectedMonth, DateTime>.internal(
  SelectedMonth.new,
  name: r'selectedMonthProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedMonthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedMonth = Notifier<DateTime>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
