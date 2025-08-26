import 'package:coin_market_app/features/exchanges/domain/entities/exchange_asset.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExchangeAsset', () {
    late ExchangeAsset exchangeAsset;
    late Platform platform;
    late Currency currency;

    setUp(() {
      platform = const Platform(cryptoId: 1, name: 'Ethereum', symbol: 'ETH');

      currency = const Currency(
        cryptoId: 1,
        name: 'Ethereum',
        symbol: 'ETH',
        priceUsd: 3000.0,
      );

      exchangeAsset = ExchangeAsset(
        walletAddress: '0x1234567890abcdef',
        balance: 100.0,
        platform: platform,
        currency: currency,
      );
    });

    test('should create ExchangeAsset instance', () {
      expect(exchangeAsset, isA<ExchangeAsset>());
    });

    test('should have correct properties', () {
      expect(exchangeAsset.walletAddress, equals('0x1234567890abcdef'));
      expect(exchangeAsset.balance, equals(100.0));
      expect(exchangeAsset.platform, equals(platform));
      expect(exchangeAsset.currency, equals(currency));
    });

    test('should be equal when properties are the same', () {
      final exchangeAsset2 = ExchangeAsset(
        walletAddress: '0x1234567890abcdef',
        balance: 100.0,
        platform: platform,
        currency: currency,
      );

      expect(exchangeAsset, equals(exchangeAsset2));
    });

    test('should not be equal when properties are different', () {
      final exchangeAsset2 = ExchangeAsset(
        walletAddress: '0xfedcba0987654321',
        balance: 200.0,
        platform: platform,
        currency: currency,
      );

      expect(exchangeAsset, isNot(equals(exchangeAsset2)));
    });

    test('should have correct hash code', () {
      final exchangeAsset2 = ExchangeAsset(
        walletAddress: '0x1234567890abcdef',
        balance: 100.0,
        platform: platform,
        currency: currency,
      );

      expect(exchangeAsset.hashCode, equals(exchangeAsset2.hashCode));
    });

    test('should have correct string representation', () {
      final expectedString =
          'ExchangeAsset(0x1234567890abcdef, 100.0, Platform(1, ETH, Ethereum), Currency(1, 3000.0, ETH, Ethereum))';

      expect(exchangeAsset.toString(), equals(expectedString));
    });
  });

  group('Platform', () {
    late Platform platform;

    setUp(() {
      platform = const Platform(cryptoId: 1, name: 'Ethereum', symbol: 'ETH');
    });

    test('should create Platform instance', () {
      expect(platform, isA<Platform>());
    });

    test('should have correct properties', () {
      expect(platform.cryptoId, equals(1));
      expect(platform.name, equals('Ethereum'));
      expect(platform.symbol, equals('ETH'));
    });

    test('should be equal when properties are the same', () {
      final platform2 = const Platform(
        cryptoId: 1,
        name: 'Ethereum',
        symbol: 'ETH',
      );

      expect(platform, equals(platform2));
    });

    test('should not be equal when properties are different', () {
      final platform2 = const Platform(
        cryptoId: 2,
        name: 'Bitcoin',
        symbol: 'BTC',
      );

      expect(platform, isNot(equals(platform2)));
    });

    test('should have correct hash code', () {
      final platform2 = const Platform(
        cryptoId: 1,
        name: 'Ethereum',
        symbol: 'ETH',
      );

      expect(platform.hashCode, equals(platform2.hashCode));
    });

    test('should have correct string representation', () {
      final expectedString = 'Platform(1, ETH, Ethereum)';

      expect(platform.toString(), equals(expectedString));
    });
  });

  group('Currency', () {
    late Currency currency;

    setUp(() {
      currency = const Currency(
        cryptoId: 1,
        name: 'Ethereum',
        symbol: 'ETH',
        priceUsd: 3000.0,
      );
    });

    test('should create Currency instance', () {
      expect(currency, isA<Currency>());
    });

    test('should have correct properties', () {
      expect(currency.cryptoId, equals(1));
      expect(currency.name, equals('Ethereum'));
      expect(currency.symbol, equals('ETH'));
      expect(currency.priceUsd, equals(3000.0));
    });

    test('should be equal when properties are the same', () {
      final currency2 = const Currency(
        cryptoId: 1,
        name: 'Ethereum',
        symbol: 'ETH',
        priceUsd: 3000.0,
      );

      expect(currency, equals(currency2));
    });

    test('should not be equal when properties are different', () {
      final currency2 = const Currency(
        cryptoId: 2,
        name: 'Bitcoin',
        symbol: 'BTC',
        priceUsd: 50000.0,
      );

      expect(currency, isNot(equals(currency2)));
    });

    test('should have correct hash code', () {
      final currency2 = const Currency(
        cryptoId: 1,
        name: 'Ethereum',
        symbol: 'ETH',
        priceUsd: 3000.0,
      );

      expect(currency.hashCode, equals(currency2.hashCode));
    });

    test('should have correct string representation', () {
      final expectedString = 'Currency(1, 3000.0, ETH, Ethereum)';

      expect(currency.toString(), equals(expectedString));
    });
  });
}
