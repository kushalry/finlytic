import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/types/result.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../mappers/transaction_mapper.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final AppDatabase _db;
  final TransactionMapper _mapper;

  TransactionRepositoryImpl(this._db, [this._mapper = const TransactionMapper()]);

  @override
  Stream<List<TransactionEntity>> watchAll() {
    return _db.transactionDao.watchAll().map(
          (rows) => rows.map((r) => _mapper.toEntity(r.transaction)).toList(),
        );
  }

  @override
  Stream<List<TransactionEntity>> watchInRange(DateTime from, DateTime to) {
    return _db.transactionDao.watchInRange(from, to).map(
          (rows) => rows.map((r) => _mapper.toEntity(r.transaction)).toList(),
        );
  }

  @override
  Future<Result<TransactionEntity>> getById(int id) async {
    try {
      final row = await (_db.select(_db.transactions)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      if (row == null) {
        return Result.failure(Failure.notFound(entity: 'Transaction', id: id));
      }
      return Result.success(_mapper.toEntity(row));
    } catch (e, s) {
      return Result.failure(Failure.unknown(error: e, stack: s));
    }
  }

  @override
  Future<Result<TransactionEntity>> add(TransactionEntity transaction) async {
    try {
      final id = await _db.transactionDao
          .insertTransaction(_mapper.toCompanion(transaction));
      return Result.success(transaction.copyWith(id: id));
    } catch (e, s) {
      return Result.failure(Failure.database(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<TransactionEntity>> update(TransactionEntity transaction) async {
    try {
      final ok = await _db.transactionDao
          .updateTransaction(_mapper.toCompanion(transaction));
      if (!ok) {
        return Result.failure(
          Failure.notFound(entity: 'Transaction', id: transaction.id!),
        );
      }
      return Result.success(transaction);
    } catch (e, s) {
      return Result.failure(Failure.database(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<void>> delete(int id) async {
    try {
      final rows = await _db.transactionDao.deleteTransaction(id);
      if (rows == 0) {
        return Result.failure(Failure.notFound(entity: 'Transaction', id: id));
      }
      return const Result.success(null);
    } catch (e, s) {
      return Result.failure(Failure.database(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<Map<int, int>>> expenseByCategoryForMonth(
    int year,
    int month,
  ) async {
    try {
      final data = await _db.transactionDao
          .expenseByCategoryForMonth(year, month);
      return Result.success(data);
    } catch (e, s) {
      return Result.failure(Failure.database(message: e.toString(), cause: e));
    }
  }
}