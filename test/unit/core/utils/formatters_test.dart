import 'package:coin_market_app/core/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Formatters', () {
    group('formatNumber', () {
      test('should format small numbers correctly', () {
        expect(Formatters.formatNumber(123), equals('123'));
        expect(Formatters.formatNumber(999), equals('999'));
      });

      test('should format thousands correctly', () {
        expect(Formatters.formatNumber(1500), equals('1.5K'));
        expect(Formatters.formatNumber(25000), equals('25K'));
        expect(Formatters.formatNumber(999999), equals('1M'));
      });

      test('should format millions correctly', () {
        expect(Formatters.formatNumber(1000000), equals('1M'));
        expect(Formatters.formatNumber(1500000), equals('1.5M'));
        expect(Formatters.formatNumber(25000000), equals('25M'));
      });

      test('should format billions correctly', () {
        expect(Formatters.formatNumber(1000000000), equals('1B'));
        expect(Formatters.formatNumber(1500000000), equals('1.5B'));
      });

      test('should format decimal numbers correctly', () {
        expect(Formatters.formatNumber(1.5), equals('1.5'));
        expect(Formatters.formatNumber(1.25), equals('1.25'));
      });

      test('should format zero correctly', () {
        expect(Formatters.formatNumber(0), equals('0'));
      });

      test('should format negative numbers correctly', () {
        expect(Formatters.formatNumber(-1500), equals('-1.5K'));
        expect(Formatters.formatNumber(-1000000), equals('-1M'));
      });
    });

    group('formatDate', () {
      test('should format date correctly', () {
        final date = DateTime(2025, 8, 25);
        expect(Formatters.formatDate(date), equals('Aug 25, 2025'));
      });

      test('should format date with single digit day and month', () {
        final date = DateTime(2025, 1, 5);
        expect(Formatters.formatDate(date), equals('Jan 05, 2025'));
      });

      test('should format date with different years', () {
        final date2024 = DateTime(2024, 12, 31);
        final date2026 = DateTime(2026, 1, 1);

        expect(Formatters.formatDate(date2024), equals('Dec 31, 2024'));
        expect(Formatters.formatDate(date2026), equals('Jan 01, 2026'));
      });

      test('should return empty string for null date', () {
        expect(Formatters.formatDate(null), equals(''));
      });
    });

    group('formatTime', () {
      test('should format time correctly', () {
        final date = DateTime(2025, 8, 25, 14, 30);
        expect(Formatters.formatTime(date), equals('14:30'));
      });

      test('should format time with leading zeros', () {
        final date = DateTime(2025, 8, 25, 9, 5);
        expect(Formatters.formatTime(date), equals('09:05'));
      });

      test('should format midnight correctly', () {
        final date = DateTime(2025, 8, 25, 0, 0);
        expect(Formatters.formatTime(date), equals('00:00'));
      });

      test('should format end of day correctly', () {
        final date = DateTime(2025, 8, 25, 23, 59);
        expect(Formatters.formatTime(date), equals('23:59'));
      });

      test('should return empty string for null date', () {
        expect(Formatters.formatTime(null), equals(''));
      });
    });

    group('formatDateTime', () {
      test('should format date and time correctly', () {
        final date = DateTime(2025, 8, 25, 14, 30);
        expect(Formatters.formatDateTime(date), equals('Aug 25, 2025 14:30'));
      });

      test('should format date and time with leading zeros', () {
        final date = DateTime(2025, 1, 5, 9, 5);
        expect(Formatters.formatDateTime(date), equals('Jan 05, 2025 09:05'));
      });

      test('should format midnight correctly', () {
        final date = DateTime(2025, 8, 25, 0, 0);
        expect(Formatters.formatDateTime(date), equals('Aug 25, 2025 00:00'));
      });

      test('should return empty string for null date', () {
        expect(Formatters.formatDateTime(null), equals(''));
      });
    });

    group('formatCurrency', () {
      test('should format currency with default decimal places', () {
        expect(Formatters.formatCurrency(123.456), equals('\$123.46'));
        expect(Formatters.formatCurrency(1000.0), equals('\$1,000.00'));
      });

      test('should format currency with large numbers correctly', () {
        expect(Formatters.formatCurrency(1234567.89), equals('\$1,234,567.89'));
        expect(
          Formatters.formatCurrency(999999999.99),
          equals('\$999,999,999.99'),
        );
      });

      test('should format zero correctly', () {
        expect(Formatters.formatCurrency(0), equals('\$0.00'));
      });

      test('should format negative numbers correctly', () {
        expect(Formatters.formatCurrency(-123.45), equals('-\$123.45'));
        expect(Formatters.formatCurrency(-1000.0), equals('-\$1,000.00'));
      });

      test('should handle null values', () {
        expect(Formatters.formatCurrency(null), equals('\$0.00'));
      });

      test('should handle very small decimal numbers', () {
        expect(Formatters.formatCurrency(0.001), equals('\$0.00'));
        expect(Formatters.formatCurrency(0.0001), equals('\$0.00'));
      });
    });
  });
}
