import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/database/tables.dart';

part 'category_providers.g.dart';

@riverpod
Stream<List<Category>> categoriesByType(
  CategoriesByTypeRef ref,
  CategoryType type,
) {
  final db = ref.watch(appDatabaseProvider);
  return db.categoryDao.watchByType(type);
}

@riverpod
Stream<List<Category>> allActiveCategories(AllActiveCategoriesRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.categoryDao.watchActive();
}