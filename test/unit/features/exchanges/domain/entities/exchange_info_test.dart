import 'package:coin_market_app/features/exchanges/domain/entities/exchange_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExchangeInfo', () {
    late ExchangeInfo exchangeInfo;
    late ExchangeUrls urls;

    setUp(() {
      urls = const ExchangeUrls(
        website: ['https://example.com'],
        twitter: ['https://twitter.com/example'],
        blog: [],
        chat: ['https://t.me/example'],
        fee: ['https://example.com/fees'],
      );

      exchangeInfo = ExchangeInfo(
        id: 294,
        name: 'Example Exchange',
        slug: 'example-exchange',
        logo: 'https://example.com/logo.png',
        description: 'A great cryptocurrency exchange',
        dateLaunched: DateTime(2020, 1, 1),
        notice: null,
        countries: ['US', 'EU'],
        fiats: ['USD', 'EUR'],
        tags: ['spot', 'futures'],
        type: 'centralized',
        makerFee: 0.1,
        takerFee: 0.2,
        weeklyVisits: 10000,
        spotVolumeUsd: 1000000.0,
        spotVolumeLastUpdated: DateTime(2025, 1, 1),
        urls: urls,
      );
    });

    test('should create ExchangeInfo instance', () {
      expect(exchangeInfo, isA<ExchangeInfo>());
    });

    test('should have correct properties', () {
      expect(exchangeInfo.id, equals(294));
      expect(exchangeInfo.name, equals('Example Exchange'));
      expect(exchangeInfo.slug, equals('example-exchange'));
      expect(exchangeInfo.logo, equals('https://example.com/logo.png'));
      expect(
        exchangeInfo.description,
        equals('A great cryptocurrency exchange'),
      );
      expect(exchangeInfo.dateLaunched, equals(DateTime(2020, 1, 1)));
      expect(exchangeInfo.notice, isNull);
      expect(exchangeInfo.countries, equals(['US', 'EU']));
      expect(exchangeInfo.fiats, equals(['USD', 'EUR']));
      expect(exchangeInfo.tags, equals(['spot', 'futures']));
      expect(exchangeInfo.type, equals('centralized'));
      expect(exchangeInfo.makerFee, equals(0.1));
      expect(exchangeInfo.takerFee, equals(0.2));
      expect(exchangeInfo.weeklyVisits, equals(10000));
      expect(exchangeInfo.spotVolumeUsd, equals(1000000.0));
      expect(exchangeInfo.spotVolumeLastUpdated, equals(DateTime(2025, 1, 1)));
      expect(exchangeInfo.urls, equals(urls));
    });

    test('should be equal when properties are the same', () {
      final exchangeInfo2 = ExchangeInfo(
        id: 294,
        name: 'Example Exchange',
        slug: 'example-exchange',
        logo: 'https://example.com/logo.png',
        description: 'A great cryptocurrency exchange',
        dateLaunched: DateTime(2020, 1, 1),
        notice: null,
        countries: ['US', 'EU'],
        fiats: ['USD', 'EUR'],
        tags: ['spot', 'futures'],
        type: 'centralized',
        makerFee: 0.1,
        takerFee: 0.2,
        weeklyVisits: 10000,
        spotVolumeUsd: 1000000.0,
        spotVolumeLastUpdated: DateTime(2025, 1, 1),
        urls: urls,
      );

      expect(exchangeInfo, equals(exchangeInfo2));
    });

    test('should not be equal when properties are different', () {
      final exchangeInfo2 = ExchangeInfo(
        id: 295,
        name: 'Another Exchange',
        slug: 'another-exchange',
        logo: 'https://another.com/logo.png',
        description: 'Another cryptocurrency exchange',
        dateLaunched: DateTime(2021, 1, 1),
        notice: 'Important notice',
        countries: ['UK'],
        fiats: ['GBP'],
        tags: ['spot'],
        type: 'decentralized',
        makerFee: 0.05,
        takerFee: 0.15,
        weeklyVisits: 5000,
        spotVolumeUsd: 500000.0,
        spotVolumeLastUpdated: DateTime(2025, 1, 1),
        urls: urls,
      );

      expect(exchangeInfo, isNot(equals(exchangeInfo2)));
    });

    test('should handle null values correctly', () {
      final exchangeInfoWithNulls = ExchangeInfo(
        id: 294,
        name: 'Example Exchange',
        slug: 'example-exchange',
        logo: '',
        description: '',
        dateLaunched: DateTime(2020, 1, 1),
        notice: null,
        countries: [],
        fiats: [],
        tags: null,
        type: null,
        makerFee: 0.1,
        takerFee: 0.2,
        weeklyVisits: 10000,
        spotVolumeUsd: 1000000.0,
        spotVolumeLastUpdated: DateTime(2025, 1, 1),
        urls: urls,
      );

      expect(exchangeInfoWithNulls.logo, isEmpty);
      expect(exchangeInfoWithNulls.description, isEmpty);
      expect(exchangeInfoWithNulls.notice, isNull);
      expect(exchangeInfoWithNulls.countries, isEmpty);
      expect(exchangeInfoWithNulls.fiats, isEmpty);
      expect(exchangeInfoWithNulls.tags, isNull);
      expect(exchangeInfoWithNulls.type, isNull);
    });

    test('should have correct hash code', () {
      final exchangeInfo2 = ExchangeInfo(
        id: 294,
        name: 'Example Exchange',
        slug: 'example-exchange',
        logo: 'https://example.com/logo.png',
        description: 'A great cryptocurrency exchange',
        dateLaunched: DateTime(2020, 1, 1),
        notice: null,
        countries: ['US', 'EU'],
        fiats: ['USD', 'EUR'],
        tags: ['spot', 'futures'],
        type: 'centralized',
        makerFee: 0.1,
        takerFee: 0.2,
        weeklyVisits: 10000,
        spotVolumeUsd: 1000000.0,
        spotVolumeLastUpdated: DateTime(2025, 1, 1),
        urls: urls,
      );

      expect(exchangeInfo.hashCode, equals(exchangeInfo2.hashCode));
    });

    test('should have correct string representation', () {
      final expectedString =
          'ExchangeInfo(294, Example Exchange, example-exchange, https://example.com/logo.png, A great cryptocurrency exchange, 2020-01-01 00:00:00.000, null, [US, EU], [USD, EUR], [spot, futures], centralized, 0.1, 0.2, 10000, 1000000.0, 2025-01-01 00:00:00.000, ExchangeUrls([https://example.com], [https://twitter.com/example], [], [https://t.me/example], [https://example.com/fees]))';

      expect(exchangeInfo.toString(), equals(expectedString));
    });
  });

  group('ExchangeUrls', () {
    late ExchangeUrls urls;

    setUp(() {
      urls = const ExchangeUrls(
        website: ['https://example.com'],
        twitter: ['https://twitter.com/example'],
        blog: [],
        chat: ['https://t.me/example'],
        fee: ['https://example.com/fees'],
      );
    });

    test('should create ExchangeUrls instance', () {
      expect(urls, isA<ExchangeUrls>());
    });

    test('should have correct properties', () {
      expect(urls.website, equals(['https://example.com']));
      expect(urls.twitter, equals(['https://twitter.com/example']));
      expect(urls.blog, isEmpty);
      expect(urls.chat, equals(['https://t.me/example']));
      expect(urls.fee, equals(['https://example.com/fees']));
    });

    test('should be equal when properties are the same', () {
      final urls2 = const ExchangeUrls(
        website: ['https://example.com'],
        twitter: ['https://twitter.com/example'],
        blog: [],
        chat: ['https://t.me/example'],
        fee: ['https://example.com/fees'],
      );

      expect(urls, equals(urls2));
    });

    test('should not be equal when properties are different', () {
      final urls2 = const ExchangeUrls(
        website: ['https://another.com'],
        twitter: ['https://twitter.com/another'],
        blog: ['https://blog.another.com'],
        chat: ['https://t.me/another'],
        fee: ['https://another.com/fees'],
      );

      expect(urls, isNot(equals(urls2)));
    });

    test('should handle empty lists correctly', () {
      final emptyUrls = const ExchangeUrls(
        website: [],
        twitter: [],
        blog: [],
        chat: [],
        fee: [],
      );

      expect(emptyUrls.website, isEmpty);
      expect(emptyUrls.twitter, isEmpty);
      expect(emptyUrls.blog, isEmpty);
      expect(emptyUrls.chat, isEmpty);
      expect(emptyUrls.fee, isEmpty);
    });

    test('should have correct hash code', () {
      final urls2 = const ExchangeUrls(
        website: ['https://example.com'],
        twitter: ['https://twitter.com/example'],
        blog: [],
        chat: ['https://t.me/example'],
        fee: ['https://example.com/fees'],
      );

      expect(urls.hashCode, equals(urls2.hashCode));
    });

    test('should have correct string representation', () {
      final expectedString =
          'ExchangeUrls([https://example.com], [https://twitter.com/example], [], [https://t.me/example], [https://example.com/fees])';

      expect(urls.toString(), equals(expectedString));
    });
  });
}
