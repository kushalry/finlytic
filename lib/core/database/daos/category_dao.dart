import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Stream<List<Category>> watchActive() =>
      (select(categories)..where((c) => c.isArchived.equals(false))).watch();

  Stream<List<Category>> watchByType(CategoryType type) =>
      (select(categories)
            ..where((c) =>
                c.isArchived.equals(false) & c.type.equalsValue(type)))
          .watch();

  Future<int> insertCategory(CategoriesCompanion entry) =>
      into(categories).insert(entry);

  Future<void> archiveCategory(int id) =>
      (update(categories)..where((c) => c.id.equals(id)))
          .write(const CategoriesCompanion(isArchived: Value(true)));
}