import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'account_dao.g.dart';

@DriftAccessor(tables: [Accounts])
class AccountDao extends DatabaseAccessor<AppDatabase>
    with _$AccountDaoMixin {
  AccountDao(super.db);

  Stream<List<Account>> watchActive() =>
      (select(accounts)..where((a) => a.isArchived.equals(false))).watch();

  Future<List<Account>> getAllActive() =>
      (select(accounts)..where((a) => a.isArchived.equals(false))).get();

  Future<int> insertAccount(AccountsCompanion entry) =>
      into(accounts).insert(entry);

  Future<bool> updateAccount(AccountsCompanion entry) =>
      update(accounts).replace(entry);

  Future<void> archiveAccount(int id) =>
      (update(accounts)..where((a) => a.id.equals(id)))
          .write(const AccountsCompanion(isArchived: Value(true)));
}