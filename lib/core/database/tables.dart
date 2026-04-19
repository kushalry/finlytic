import 'package:drift/drift.dart';

/// Financial accounts owned by the user (bank, wallet, credit card, cash).
///
/// Amounts are stored as integers in minor units (paise/cents) to avoid
/// floating-point precision errors. A balance of ₹1,234.56 is stored as 123456.
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get type => textEnum<AccountType>()();
  IntColumn get openingBalanceMinor => integer().withDefault(const Constant(0))();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3).withDefault(const Constant('INR'))();
  TextColumn get colorHex => text().withLength(min: 7, max: 9)();
  TextColumn get iconName => text()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

enum AccountType { bank, creditCard, wallet, cash, investment }

/// User-defined categories for classifying transactions.
///
/// Categories are scoped by type — income categories only apply to income
/// transactions and vice-versa. This prevents nonsensical assignments like
/// a "Salary" category on an expense.
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get type => textEnum<CategoryType>()();
  TextColumn get colorHex => text().withLength(min: 7, max: 9)();
  TextColumn get iconName => text()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

enum CategoryType { income, expense }

/// Individual money movements. This is the core "fact" table of the app.
///
/// Transfers between accounts are modeled as a pair of linked rows —
/// a transfer-out (negative effect) and transfer-in (positive effect) —
/// joined by [transferGroupId]. Keeps querying by account-balance simple.
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(Accounts, #id)();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id)();
  TextColumn get type => textEnum<TransactionType>()();
  IntColumn get amountMinor => integer()();
  TextColumn get note => text().withLength(max: 200).nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get transferGroupId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

enum TransactionType { income, expense, transfer }

/// Monthly spending limits per category.
///
/// A budget is ₹X for category Y in month M. We re-create budget rows
/// each month rather than using a recurring model — simpler, and lets
/// users adjust month-by-month without affecting history.
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get amountMinor => integer()();
  IntColumn get year => integer()();
  IntColumn get month => integer()(); // 1-12
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {categoryId, year, month}, // One budget per category per month
      ];
}