import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static String formatCurrency(double? value) {
    if (value == null) return '\$0.00';
    return _currencyFormat.format(value);
  }

  static String formatNumber(double? value, {int decimalPlaces = 2}) {
    if (value == null) return '0';

    final formatter = NumberFormat.decimalPattern('en_US');
    formatter.minimumFractionDigits = decimalPlaces;
    formatter.maximumFractionDigits = decimalPlaces;
    return formatter.format(value);
  }
}
