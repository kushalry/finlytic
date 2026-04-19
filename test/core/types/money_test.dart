import 'package:finlytic/core/types/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Money', () {
    test('fromMajor rounds correctly', () {
      expect(Money.fromMajor(12.345, 'INR').minorUnits, 1235);
      expect(Money.fromMajor(12.344, 'INR').minorUnits, 1234);
      expect(Money.fromMajor(0.1 + 0.2, 'INR').minorUnits, 30); // float trap
    });

    test('major returns correct double', () {
      expect(Money.fromMinor(123456, 'INR').major, 1234.56);
    });

    test('addition works across positive values', () {
      final a = Money.fromMinor(10000, 'INR');
      final b = Money.fromMinor(5000, 'INR');
      expect((a + b).minorUnits, 15000);
    });

    test('subtraction can go negative', () {
      final a = Money.fromMinor(1000, 'INR');
      final b = Money.fromMinor(5000, 'INR');
      expect((a - b).minorUnits, -4000);
      expect((a - b).isNegative, true);
    });

    test('throws when operating across currencies', () {
      final inr = Money.fromMinor(100, 'INR');
      final usd = Money.fromMinor(100, 'USD');
      expect(() => inr + usd, throwsA(isA<ArgumentError>()));
    });

    test('abs and negate', () {
      final neg = Money.fromMinor(-500, 'INR');
      expect(neg.abs().minorUnits, 500);
      expect(neg.negate().minorUnits, 500);
      expect(Money.fromMinor(500, 'INR').negate().minorUnits, -500);
    });
  });
}