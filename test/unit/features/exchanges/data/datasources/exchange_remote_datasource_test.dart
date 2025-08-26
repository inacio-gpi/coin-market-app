import 'dart:convert';

import 'package:coin_market_app/core/api/custom_http_client.dart';
import 'package:coin_market_app/core/api/http_client_adapter.dart';
import 'package:coin_market_app/core/errors/exceptions.dart';
import 'package:coin_market_app/features/exchanges/data/datasources/exchange_remote_datasource.dart';
import 'package:coin_market_app/features/exchanges/data/models/exchange_asset_model.dart';
import 'package:coin_market_app/features/exchanges/data/models/exchange_info_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'exchange_remote_datasource_test.mocks.dart';

@GenerateMocks([CustomHttpClient])
void main() {
  group('ExchangeRemoteDataSource', () {
    late ExchangeRemoteDataSourceImpl dataSource;
    late MockCustomHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockCustomHttpClient();
      dataSource = ExchangeRemoteDataSourceImpl(httpClient: mockHttpClient);
    });

    group('getExchangeInfo', () {
      const tExchangeId = 294;
      final tResponseData = {
        'status': {
          'timestamp': '2025-08-25T04:45:38.212Z',
          'error_code': 0,
          'error_message': null,
          'elapsed': 1,
          'credit_count': 1,
          'notice': null,
        },
        'data': {
          '294': {
            'id': 294,
            'name': 'Test Exchange',
            'slug': 'test-exchange',
            'logo': 'test-logo',
            'description': 'Test description',
            'date_launched': '2025-08-25T04:45:38.211Z',
            'notice': null,
            'countries': [],
            'fiats': ['USD', 'EUR'],
            'tags': null,
            'type': null,
            'maker_fee': 0.1,
            'taker_fee': 0.2,
            'weekly_visits': 1000,
            'spot_volume_usd': 1000000.0,
            'spot_volume_last_updated': '2025-08-25T04:45:38.211Z',
            'urls': {
              'website': ['https://test.com'],
              'twitter': ['https://twitter.com/test'],
              'blog': [],
              'chat': ['https://chat.test.com'],
              'fee': ['https://fee.test.com'],
            },
          },
        },
      };

      test(
        'should return ExchangeInfo when HTTP request is successful',
        () async {
          final mockResponse = HttpResponse(
            statusCode: 200,
            body: json.encode(tResponseData),
          );

          when(
            mockHttpClient.get(
              any,
              queryParameters: anyNamed('queryParameters'),
            ),
          ).thenAnswer((_) async => mockResponse);

          final result = await dataSource.getExchangeInfo(tExchangeId);

          expect(result, isA<ExchangeInfoModel>());
          expect(result.id, equals(294));
          expect(result.name, equals('Test Exchange'));
          expect(result.slug, equals('test-exchange'));
          expect(result.logo, equals('test-logo'));
          expect(result.description, equals('Test description'));
          expect(result.makerFee, equals(0.1));
          expect(result.takerFee, equals(0.2));
          expect(result.weeklyVisits, equals(1000));
          expect(result.spotVolumeUsd, equals(1000000.0));
          expect(result.urls.website, equals(['https://test.com']));
          expect(result.urls.twitter, equals(['https://twitter.com/test']));
          verify(
            mockHttpClient.get(
              any,
              queryParameters: anyNamed('queryParameters'),
            ),
          ).called(1);
        },
      );

      test('should handle empty response data', () async {
        final emptyResponse = {
          'status': {
            'timestamp': '2025-08-25T04:45:38.212Z',
            'error_code': 0,
            'error_message': null,
            'elapsed': 1,
            'credit_count': 1,
            'notice': null,
          },
          'data': {},
        };

        final mockResponse = HttpResponse(
          statusCode: 200,
          body: json.encode(emptyResponse),
        );

        when(
          mockHttpClient.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        expect(
          () => dataSource.getExchangeInfo(tExchangeId),
          throwsA(isA<ServerException>()),
        );
        verify(
          mockHttpClient.get(any, queryParameters: anyNamed('queryParameters')),
        ).called(1);
      });

      test('should handle different exchange ID', () async {
        const differentId = 123;
        final differentResponse = {
          'status': {
            'timestamp': '2025-08-25T04:45:38.212Z',
            'error_code': 0,
            'error_message': null,
            'elapsed': 1,
            'credit_count': 1,
            'notice': null,
          },
          'data': {
            '123': {
              'id': 123,
              'name': 'Different Exchange',
              'slug': 'different-exchange',
              'logo': 'different-logo',
              'description': 'Different description',
              'date_launched': '2025-08-25T04:45:38.211Z',
              'notice': null,
              'countries': [],
              'fiats': ['USD'],
              'tags': null,
              'type': null,
              'maker_fee': 0.05,
              'taker_fee': 0.15,
              'weekly_visits': 500,
              'spot_volume_usd': 500000.0,
              'spot_volume_last_updated': '2025-08-25T04:45:38.211Z',
              'urls': {
                'website': ['https://different.com'],
                'twitter': [],
                'blog': [],
                'chat': [],
                'fee': [],
              },
            },
          },
        };

        final mockResponse = HttpResponse(
          statusCode: 200,
          body: json.encode(differentResponse),
        );

        when(
          mockHttpClient.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        final result = await dataSource.getExchangeInfo(differentId);

        expect(result, isA<ExchangeInfoModel>());
        expect(result.id, equals(123));
        expect(result.name, equals('Different Exchange'));
        expect(result.makerFee, equals(0.05));
        expect(result.takerFee, equals(0.15));
        verify(
          mockHttpClient.get(any, queryParameters: anyNamed('queryParameters')),
        ).called(1);
      });
    });

    group('getExchangeAssets', () {
      const tExchangeId = 294;
      final tResponseData = <String, dynamic>{
        'status': {
          'timestamp': '2025-08-25T04:05:42.127Z',
          'error_code': 0,
          'error_message': null,
          'elapsed': 1,
          'credit_count': 1,
          'notice': null,
        },
        'data': [
          {
            'wallet_address': '0x1234567890abcdef',
            'balance': 100.5,
            'platform': {'crypto_id': 1, 'symbol': 'ETH', 'name': 'Ethereum'},
            'currency': {
              'crypto_id': 1,
              'price_usd': 3000.0,
              'symbol': 'ETH',
              'name': 'Ethereum',
            },
          },
          {
            'wallet_address': '0xabcdef1234567890',
            'balance': 50.25,
            'platform': {'crypto_id': 2, 'symbol': 'BTC', 'name': 'Bitcoin'},
            'currency': {
              'crypto_id': 2,
              'price_usd': 50000.0,
              'symbol': 'BTC',
              'name': 'Bitcoin',
            },
          },
        ],
      };

      test(
        'should return list of ExchangeAssets when HTTP request is successful',
        () async {
          final mockResponse = HttpResponse(
            statusCode: 200,
            body: json.encode(tResponseData),
          );

          when(
            mockHttpClient.get(
              any,
              queryParameters: anyNamed('queryParameters'),
            ),
          ).thenAnswer((_) async => mockResponse);

          final result = await dataSource.getExchangeAssets(tExchangeId);

          expect(result, isA<List<ExchangeAssetModel>>());
          expect(result.length, equals(2));

          final firstAsset = result.first;
          expect(firstAsset.walletAddress, equals('0x1234567890abcdef'));
          expect(firstAsset.balance, equals(100.5));
          expect(firstAsset.platform.symbol, equals('ETH'));
          expect(firstAsset.platform.name, equals('Ethereum'));
          expect(firstAsset.currency.symbol, equals('ETH'));
          expect(firstAsset.currency.priceUsd, equals(3000.0));

          final secondAsset = result.last;
          expect(secondAsset.walletAddress, equals('0xabcdef1234567890'));
          expect(secondAsset.balance, equals(50.25));
          expect(secondAsset.platform.symbol, equals('BTC'));
          expect(secondAsset.platform.name, equals('Bitcoin'));
          expect(secondAsset.currency.symbol, equals('BTC'));
          expect(secondAsset.currency.priceUsd, equals(50000.0));

          verify(
            mockHttpClient.get(
              any,
              queryParameters: anyNamed('queryParameters'),
            ),
          ).called(1);
        },
      );

      test('should handle empty assets list', () async {
        final emptyResponse = {
          'status': {
            'timestamp': '2025-08-25T04:05:42.127Z',
            'error_code': 0,
            'error_message': null,
            'elapsed': 1,
            'credit_count': 1,
            'notice': null,
          },
          'data': [],
        };

        final mockResponse = HttpResponse(
          statusCode: 200,
          body: json.encode(emptyResponse),
        );

        when(
          mockHttpClient.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        final result = await dataSource.getExchangeAssets(tExchangeId);

        expect(result, isA<List<ExchangeAssetModel>>());
        expect(result, isEmpty);
        verify(
          mockHttpClient.get(any, queryParameters: anyNamed('queryParameters')),
        ).called(1);
      });

      test('should handle single asset', () async {
        final singleAssetResponse = {
          'status': {
            'timestamp': '2025-08-25T04:05:42.127Z',
            'error_code': 0,
            'error_message': null,
            'elapsed': 1,
            'credit_count': 1,
            'notice': null,
          },
          'data': [(tResponseData['data'] as List)[0]],
        };

        final mockResponse = HttpResponse(
          statusCode: 200,
          body: json.encode(singleAssetResponse),
        );

        when(
          mockHttpClient.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        final result = await dataSource.getExchangeAssets(tExchangeId);

        expect(result, isA<List<ExchangeAssetModel>>());
        expect(result.length, equals(1));
        expect(result.first.walletAddress, equals('0x1234567890abcdef'));
        expect(result.first.platform.symbol, equals('ETH'));
        expect(result.first.currency.symbol, equals('ETH'));
        verify(
          mockHttpClient.get(any, queryParameters: anyNamed('queryParameters')),
        ).called(1);
      });

      test('should handle different exchange ID', () async {
        const differentId = 123;
        final differentResponse = {
          'status': {
            'timestamp': '2025-08-25T04:05:42.127Z',
            'error_code': 0,
            'error_message': null,
            'elapsed': 1,
            'credit_count': 1,
            'notice': null,
          },
          'data': [
            {
              'wallet_address': '0x9876543210fedcba',
              'balance': 75.0,
              'platform': {'crypto_id': 3, 'symbol': 'ADA', 'name': 'Cardano'},
              'currency': {
                'crypto_id': 3,
                'price_usd': 0.5,
                'symbol': 'ADA',
                'name': 'Cardano',
              },
            },
          ],
        };

        final mockResponse = HttpResponse(
          statusCode: 200,
          body: json.encode(differentResponse),
        );

        when(
          mockHttpClient.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        final result = await dataSource.getExchangeAssets(differentId);

        expect(result, isA<List<ExchangeAssetModel>>());
        expect(result.length, equals(1));
        expect(result.first.walletAddress, equals('0x9876543210fedcba'));
        expect(result.first.platform.symbol, equals('ADA'));
        expect(result.first.currency.symbol, equals('ADA'));
        verify(
          mockHttpClient.get(any, queryParameters: anyNamed('queryParameters')),
        ).called(1);
      });
    });
  });
}
