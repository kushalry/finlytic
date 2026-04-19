import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';

part 'account_providers.g.dart';

@riverpod
Stream<List<Account>> activeAccounts(ActiveAccountsRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.accountDao.watchActive();
}