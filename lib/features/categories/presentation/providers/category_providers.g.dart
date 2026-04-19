// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoriesByTypeHash() => r'98663766660eaabaa1ee7fa6d5ef23d8a5f24784';

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

/// See also [categoriesByType].
@ProviderFor(categoriesByType)
const categoriesByTypeProvider = CategoriesByTypeFamily();

/// See also [categoriesByType].
class CategoriesByTypeFamily extends Family<AsyncValue<List<Category>>> {
  /// See also [categoriesByType].
  const CategoriesByTypeFamily();

  /// See also [categoriesByType].
  CategoriesByTypeProvider call(
    CategoryType type,
  ) {
    return CategoriesByTypeProvider(
      type,
    );
  }

  @override
  CategoriesByTypeProvider getProviderOverride(
    covariant CategoriesByTypeProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'categoriesByTypeProvider';
}

/// See also [categoriesByType].
class CategoriesByTypeProvider
    extends AutoDisposeStreamProvider<List<Category>> {
  /// See also [categoriesByType].
  CategoriesByTypeProvider(
    CategoryType type,
  ) : this._internal(
          (ref) => categoriesByType(
            ref as CategoriesByTypeRef,
            type,
          ),
          from: categoriesByTypeProvider,
          name: r'categoriesByTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categoriesByTypeHash,
          dependencies: CategoriesByTypeFamily._dependencies,
          allTransitiveDependencies:
              CategoriesByTypeFamily._allTransitiveDependencies,
          type: type,
        );

  CategoriesByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final CategoryType type;

  @override
  Override overrideWith(
    Stream<List<Category>> Function(CategoriesByTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoriesByTypeProvider._internal(
        (ref) => create(ref as CategoriesByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Category>> createElement() {
    return _CategoriesByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoriesByTypeProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoriesByTypeRef on AutoDisposeStreamProviderRef<List<Category>> {
  /// The parameter `type` of this provider.
  CategoryType get type;
}

class _CategoriesByTypeProviderElement
    extends AutoDisposeStreamProviderElement<List<Category>>
    with CategoriesByTypeRef {
  _CategoriesByTypeProviderElement(super.provider);

  @override
  CategoryType get type => (origin as CategoriesByTypeProvider).type;
}

String _$allActiveCategoriesHash() =>
    r'f74e85b4558b894245ec77f9a728c8ff01576eea';

/// See also [allActiveCategories].
@ProviderFor(allActiveCategories)
final allActiveCategoriesProvider =
    AutoDisposeStreamProvider<List<Category>>.internal(
  allActiveCategories,
  name: r'allActiveCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allActiveCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllActiveCategoriesRef = AutoDisposeStreamProviderRef<List<Category>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
