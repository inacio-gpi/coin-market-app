import 'dart:convert';

import 'package:coin_market_app/core/api/custom_http_client.dart';
import 'package:coin_market_app/core/api/http_client_adapter.dart';
import 'package:coin_market_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:coin_market_app/features/home/data/models/exchange_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_remote_datasource_test.mocks.dart';

@GenerateMocks([CustomHttpClient])
void main() {
  group('HomeRemoteDataSource', () {
    late HomeRemoteDataSourceImpl dataSource;
    late MockCustomHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockCustomHttpClient();
      dataSource = HomeRemoteDataSourceImpl(httpClient: mockHttpClient);
    });

    group('getAllExchanges', () {
      final tResponseData = {
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
            'id': 1,
            'name': 'Binance',
            'slug': 'binance',
            'num_market_pairs': 1000,
            'fiats': ['USD', 'EUR'],
            'traffic_score': 100.0,
            'rank': 1,
            'exchange_score': 95.0,
            'liquidity_score': 0.9,
            'last_updated': '2025-01-01T00:00:00.000Z',
            'quote': {
              'USD': {
                'volume_24h': 1000000.0,
                'volume_24h_adjusted': 1000000.0,
                'volume_7d': 7000000.0,
                'volume_30d': 30000000.0,
                'percent_change_volume_24h': 0.05,
                'percent_change_volume_7d': 0.1,
                'percent_change_volume_30d': 0.2,
                'effective_liquidity_24h': 0.8,
                'derivative_volume_usd': 500000.0,
                'spot_volume_usd': 500000.0,
              },
            },
          },
          {
            'id': 2,
            'name': 'Coinbase',
            'slug': 'coinbase',
            'num_market_pairs': 500,
            'fiats': ['USD', 'GBP'],
            'traffic_score': 80.0,
            'rank': 2,
            'exchange_score': 90.0,
            'liquidity_score': 0.8,
            'last_updated': '2025-01-01T00:00:00.000Z',
            'quote': {
              'USD': {
                'volume_24h': 500000.0,
                'volume_24h_adjusted': 500000.0,
                'volume_7d': 3500000.0,
                'volume_30d': 15000000.0,
                'percent_change_volume_24h': 0.03,
                'percent_change_volume_7d': 0.08,
                'percent_change_volume_30d': 0.15,
                'effective_liquidity_24h': 0.7,
                'derivative_volume_usd': 250000.0,
                'spot_volume_usd': 250000.0,
              },
            },
          },
        ],
      };

      test(
        'should return list of exchanges when HTTP request is successful',
        () async {
          final mockResponse = HttpResponse(
            statusCode: 200,
            body: json.encode(tResponseData),
          );

          when(mockHttpClient.get(any)).thenAnswer((_) async => mockResponse);

          final result = await dataSource.getAllExchanges();

          expect(result, isA<List<ExchangeModel>>());
          expect(result.length, equals(2));

          final binance = result.first;
          expect(binance.id, equals(1));
          expect(binance.name, equals('Binance'));
          expect(binance.slug, equals('binance'));
          expect(binance.numMarketPairs, equals(1000));
          expect(binance.fiats, equals(['USD', 'EUR']));
          expect(binance.trafficScore, equals(100.0));
          expect(binance.rank, equals(1));
          expect(binance.exchangeScore, equals(95.0));
          expect(binance.liquidityScore, equals(0.9));
          expect(binance.quote.volume24h, equals(1000000.0));
          expect(binance.quote.spotVolumeUsd, equals(500000.0));

          final coinbase = result.last;
          expect(coinbase.id, equals(2));
          expect(coinbase.name, equals('Coinbase'));
          expect(coinbase.slug, equals('coinbase'));
          expect(coinbase.numMarketPairs, equals(500));
          expect(coinbase.fiats, equals(['USD', 'GBP']));
          expect(coinbase.trafficScore, equals(80.0));
          expect(coinbase.rank, equals(2));
          expect(coinbase.exchangeScore, equals(90.0));
          expect(coinbase.liquidityScore, equals(0.8));
          expect(coinbase.quote.volume24h, equals(500000.0));
          expect(coinbase.quote.spotVolumeUsd, equals(250000.0));

          verify(mockHttpClient.get(any)).called(1);
        },
      );

      test('should handle empty exchanges list', () async {
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

        when(mockHttpClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await dataSource.getAllExchanges();

        expect(result, isA<List<ExchangeModel>>());
        expect(result, isEmpty);
        verify(mockHttpClient.get(any)).called(1);
      });

      test('should handle single exchange', () async {
        final singleExchangeResponse = {
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
          body: json.encode(singleExchangeResponse),
        );

        when(mockHttpClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await dataSource.getAllExchanges();

        expect(result, isA<List<ExchangeModel>>());
        expect(result.length, equals(1));
        expect(result.first.name, equals('Binance'));
        expect(result.first.slug, equals('binance'));
        verify(mockHttpClient.get(any)).called(1);
      });

      test('should handle large number of exchanges', () async {
        final largeExchangesData = {
          'status': {
            'timestamp': '2025-08-25T04:05:42.127Z',
            'error_code': 0,
            'error_message': null,
            'elapsed': 1,
            'credit_count': 1,
            'notice': null,
          },
          'data': List.generate(
            100,
            (index) => {
              'id': index + 1,
              'name': 'Exchange $index',
              'slug': 'exchange-$index',
              'num_market_pairs': 100 + index,
              'fiats': ['USD'],
              'traffic_score': 50.0 + index,
              'rank': index + 1,
              'exchange_score': 80.0 + index,
              'liquidity_score': 0.5 + (index * 0.01),
              'last_updated': '2025-01-01T00:00:00.000Z',
              'quote': {
                'USD': {
                  'volume_24h': 100000.0,
                  'volume_24h_adjusted': 100000.0,
                  'volume_7d': 700000.0,
                  'volume_30d': 3000000.0,
                  'percent_change_volume_24h': 0.05,
                  'percent_change_volume_7d': 0.1,
                  'percent_change_volume_30d': 0.2,
                  'effective_liquidity_24h': 0.8,
                  'derivative_volume_usd': 50000.0,
                  'spot_volume_usd': 50000.0,
                },
              },
            },
          ),
        };

        final mockResponse = HttpResponse(
          statusCode: 200,
          body: json.encode(largeExchangesData),
        );

        when(mockHttpClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await dataSource.getAllExchanges();

        expect(result, isA<List<ExchangeModel>>());
        expect(result.length, equals(100));
        expect(result.first.name, equals('Exchange 0'));
        expect(result.last.name, equals('Exchange 99'));
        verify(mockHttpClient.get(any)).called(1);
      });

      test('should handle exchanges with null exchange_score', () async {
        final responseWithNullScore = {
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
              'id': 3,
              'name': 'Test Exchange',
              'slug': 'test-exchange',
              'num_market_pairs': 300,
              'fiats': ['USD'],
              'traffic_score': 60.0,
              'rank': 3,
              'exchange_score': null,
              'liquidity_score': 0.6,
              'last_updated': '2025-01-01T00:00:00.000Z',
              'quote': {
                'USD': {
                  'volume_24h': 300000.0,
                  'volume_24h_adjusted': 300000.0,
                  'volume_7d': 2100000.0,
                  'volume_30d': 9000000.0,
                  'percent_change_volume_24h': 0.02,
                  'percent_change_volume_7d': 0.06,
                  'percent_change_volume_30d': 0.12,
                  'effective_liquidity_24h': 0.6,
                  'derivative_volume_usd': 150000.0,
                  'spot_volume_usd': 150000.0,
                },
              },
            },
          ],
        };

        final mockResponse = HttpResponse(
          statusCode: 200,
          body: json.encode(responseWithNullScore),
        );

        when(mockHttpClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await dataSource.getAllExchanges();

        expect(result, isA<List<ExchangeModel>>());
        expect(result.length, equals(1));
        expect(result.first.exchangeScore, isNull);
        expect(result.first.name, equals('Test Exchange'));
        verify(mockHttpClient.get(any)).called(1);
      });

      test('should handle exchanges with different fiat currencies', () async {
        final responseWithDifferentFiats = {
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
              'id': 4,
              'name': 'Multi Fiat Exchange',
              'slug': 'multi-fiat-exchange',
              'num_market_pairs': 800,
              'fiats': ['USD', 'EUR', 'GBP', 'JPY'],
              'traffic_score': 85.0,
              'rank': 4,
              'exchange_score': 88.0,
              'liquidity_score': 0.85,
              'last_updated': '2025-01-01T00:00:00.000Z',
              'quote': {
                'USD': {
                  'volume_24h': 800000.0,
                  'volume_24h_adjusted': 800000.0,
                  'volume_7d': 5600000.0,
                  'volume_30d': 24000000.0,
                  'percent_change_volume_24h': 0.04,
                  'percent_change_volume_7d': 0.09,
                  'percent_change_volume_30d': 0.18,
                  'effective_liquidity_24h': 0.75,
                  'derivative_volume_usd': 400000.0,
                  'spot_volume_usd': 400000.0,
                },
              },
            },
          ],
        };

        final mockResponse = HttpResponse(
          statusCode: 200,
          body: json.encode(responseWithDifferentFiats),
        );

        when(mockHttpClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await dataSource.getAllExchanges();

        expect(result, isA<List<ExchangeModel>>());
        expect(result.length, equals(1));
        expect(result.first.fiats, equals(['USD', 'EUR', 'GBP', 'JPY']));
        expect(result.first.name, equals('Multi Fiat Exchange'));
        verify(mockHttpClient.get(any)).called(1);
      });
    });
  });
}
