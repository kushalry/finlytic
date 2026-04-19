import 'package:freezed_annotation/freezed_annotation.dart';

part 'money.freezed.dart';

/// A monetary amount with an explicit currency. Stores value in minor units
/// (paise, cents) as an integer to avoid floating-point rounding errors.
///
/// Example: Money.fromMinor(123456, 'INR') represents ₹1,234.56.
@freezed
class Money with _$Money {
  const Money._();

  const factory Money({
    required int minorUnits,
    required String currencyCode,
  }) = _Money;

  /// Create from a major-unit double. Rounds to nearest minor unit.
  /// Use this ONLY at boundaries (user input), never internally.
  factory Money.fromMajor(double major, String currencyCode) =>
      Money(minorUnits: (major * 100).round(), currencyCode: currencyCode);

  factory Money.fromMinor(int minor, String currencyCode) =>
      Money(minorUnits: minor, currencyCode: currencyCode);

  factory Money.zero([String currencyCode = 'INR']) =>
      Money(minorUnits: 0, currencyCode: currencyCode);

  double get major => minorUnits / 100.0;

  bool get isNegative => minorUnits < 0;
  bool get isZero => minorUnits == 0;
  bool get isPositive => minorUnits > 0;

  Money operator +(Money other) {
    _assertSameCurrency(other);
    return copyWith(minorUnits: minorUnits + other.minorUnits);
  }

  Money operator -(Money other) {
    _assertSameCurrency(other);
    return copyWith(minorUnits: minorUnits - other.minorUnits);
  }

  Money abs() => copyWith(minorUnits: minorUnits.abs());
  Money negate() => copyWith(minorUnits: -minorUnits);

  void _assertSameCurrency(Money other) {
    if (currencyCode != other.currencyCode) {
      throw ArgumentError(
        'Cannot operate on different currencies: '
        '$currencyCode vs ${other.currencyCode}',
      );
    }
  }
}