import 'package:finlytic/core/errors/failure.dart';
import 'package:finlytic/core/types/money.dart';
import 'package:finlytic/core/types/result.dart';
import 'package:finlytic/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finlytic/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finlytic/features/transactions/domain/usecases/add_transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late _MockTransactionRepository repository;
  late AddTransactionUseCase useCase;

  setUpAll(() {
    registerFallbackValue(
      TransactionEntity(
        accountId: 0,
        kind: TransactionKind.expense,
        amount: Money.zero(),
        occurredAt: DateTime(2026),
      ),
    );
  });

  setUp(() {
    repository = _MockTransactionRepository();
    useCase = AddTransactionUseCase(repository);
  });

  TransactionEntity valid({
    Money? amount,
    TransactionKind kind = TransactionKind.expense,
    int? categoryId = 1,
    DateTime? occurredAt,
    String? note,
  }) =>
      TransactionEntity(
        accountId: 1,
        categoryId: categoryId,
        kind: kind,
        amount: amount ?? Money.fromMinor(10000, 'INR'),
        occurredAt: occurredAt ?? DateTime(2026, 4, 15),
        note: note,
      );

  group('AddTransactionUseCase', () {
    test('rejects zero amount', () async {
      final result = await useCase(valid(amount: Money.zero()));

      expect(result.isFailure, true);
      expect(
        result.failureOrNull,
        isA<ValidationFailure>().having(
          (f) => f.message,
          'message',
          contains('greater than zero'),
        ),
      );
      verifyNever(() => repository.add(any()));
    });

    test('rejects negative amount', () async {
      final result =
          await useCase(valid(amount: Money.fromMinor(-500, 'INR')));
      expect(result.isFailure, true);
    });

    test('rejects expense without category', () async {
      final result = await useCase(
        valid(kind: TransactionKind.expense, categoryId: null),
      );

      expect(result.isFailure, true);
      expect(
        (result.failureOrNull as ValidationFailure).message,
        contains('Category is required'),
      );
    });

    test('allows transfer without category', () async {
      final input = valid(kind: TransactionKind.transfer, categoryId: null);
      when(() => repository.add(any()))
          .thenAnswer((_) async => Result.success(input));

      final result = await useCase(input);

      expect(result.isSuccess, true);
      verify(() => repository.add(input)).called(1);
    });

    test('rejects note longer than 200 chars', () async {
      final result = await useCase(valid(note: 'x' * 201));
      expect(result.isFailure, true);
    });

    test('rejects far-future occurredAt', () async {
      final result = await useCase(
        valid(occurredAt: DateTime.now().add(const Duration(days: 30))),
      );
      expect(result.isFailure, true);
    });

    test('delegates valid input to repository', () async {
      final input = valid();
      when(() => repository.add(any()))
          .thenAnswer((_) async => Result.success(input.copyWith(id: 42)));

      final result = await useCase(input);

      expect(result.isSuccess, true);
      expect(result.dataOrNull?.id, 42);
      verify(() => repository.add(input)).called(1);
    });

    test('propagates repository failure', () async {
      when(() => repository.add(any())).thenAnswer(
        (_) async => const Result.failure(
          Failure.database(message: 'disk full'),
        ),
      );

      final result = await useCase(valid());

      expect(result.isFailure, true);
      expect(result.failureOrNull, isA<DatabaseFailure>());
    });
  });
}