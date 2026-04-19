import 'package:intl/intl.dart';

import '../types/money.dart';

class CurrencyFormatter {
  const CurrencyFormatter._();

  static String format(Money money) {
    final format = NumberFormat.currency(
      locale: _localeFor(money.currencyCode),
      symbol: _symbolFor(money.currencyCode),
      decimalDigits: 2,
    );
    return format.format(money.major);
  }

  static String formatSigned(Money money, {required bool isExpense}) {
    final sign = isExpense ? '-' : '+';
    return '$sign${format(money.abs())}';
  }

  static String _localeFor(String code) => switch (code) {
        'INR' => 'en_IN',
        'USD' => 'en_US',
        'EUR' => 'en_EU',
        'GBP' => 'en_GB',
        _ => 'en_US',
      };

  static String _symbolFor(String code) => switch (code) {
        'INR' => '₹',
        'USD' => '\$',
        'EUR' => '€',
        'GBP' => '£',
        _ => code,
      };
}