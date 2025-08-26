import 'package:coin_market_app/core/errors/exceptions.dart';
import 'package:coin_market_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:coin_market_app/features/home/data/models/exchange_model.dart';
import 'package:coin_market_app/features/home/data/repositories_impl/home_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_repository_impl_test.mocks.dart';

@GenerateMocks([HomeRemoteDataSource])
void main() {
  group('HomeRepositoryImpl', () {
    late HomeRepositoryImpl repository;
    late MockHomeRemoteDataSource mockRemoteDataSource;

    setUp(() {
      mockRemoteDataSource = MockHomeRemoteDataSource();
      repository = HomeRepositoryImpl(remoteDataSource: mockRemoteDataSource);
    });

    final tExchanges = [
      ExchangeModel(
        id: 1,
        name: 'Binance',
        slug: 'binance',
        numMarketPairs: 1000,
        fiats: ['USD', 'EUR'],
        trafficScore: 100.0,
        rank: 1,
        exchangeScore: 95.0,
        liquidityScore: 0.9,
        lastUpdated: DateTime(2025, 1, 1),
        quote: ExchangeQuoteModel(
          volume24h: 1000000.0,
          volume24hAdjusted: 1000000.0,
          volume7d: 7000000.0,
          volume30d: 30000000.0,
          percentChangeVolume24h: 0.05,
          percentChangeVolume7d: 0.1,
          percentChangeVolume30d: 0.2,
          effectiveLiquidity24h: 0.8,
          derivativeVolumeUsd: 500000.0,
          spotVolumeUsd: 500000.0,
        ),
      ),
      ExchangeModel(
        id: 2,
        name: 'Coinbase',
        slug: 'coinbase',
        numMarketPairs: 500,
        fiats: ['USD', 'GBP'],
        trafficScore: 80.0,
        rank: 2,
        exchangeScore: 90.0,
        liquidityScore: 0.8,
        lastUpdated: DateTime(2025, 1, 1),
        quote: ExchangeQuoteModel(
          volume24h: 500000.0,
          volume24hAdjusted: 500000.0,
          volume7d: 3500000.0,
          volume30d: 15000000.0,
          percentChangeVolume24h: 0.03,
          percentChangeVolume7d: 0.08,
          percentChangeVolume30d: 0.15,
          effectiveLiquidity24h: 0.7,
          derivativeVolumeUsd: 250000.0,
          spotVolumeUsd: 250000.0,
        ),
      ),
    ];

    group('getAllExchanges', () {
      test(
        'should return list of exchanges when remote data source is successful',
        () async {
          when(
            mockRemoteDataSource.getAllExchanges(),
          ).thenAnswer((_) async => tExchanges);
          final result = await repository.getAllExchanges();
          expect(result.isRight(), isTrue);
          final exchanges = result.fold((l) => null, (r) => r);
          expect(exchanges, isNotNull);
          expect(exchanges!.length, equals(2));
          expect(exchanges.first.id, equals(1));
          expect(exchanges.first.name, equals('Binance'));
          expect(exchanges.last.id, equals(2));
          expect(exchanges.last.name, equals('Coinbase'));
          verify(mockRemoteDataSource.getAllExchanges()).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return ServerFailure when remote data source fails',
        () async {
          when(
            mockRemoteDataSource.getAllExchanges(),
          ).thenThrow(ServerException(message: 'Server error'));
          final result = await repository.getAllExchanges();
          expect(result.isLeft(), isTrue);
          expect(
            result.fold((l) => l.message, (r) => ''),
            contains('Server error'),
          );
          verify(mockRemoteDataSource.getAllExchanges()).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return UnknownFailure when unexpected error occurs',
        () async {
          when(
            mockRemoteDataSource.getAllExchanges(),
          ).thenThrow(Exception('Unexpected error'));
          final result = await repository.getAllExchanges();
          expect(result.isLeft(), isTrue);
          expect(
            result.fold((l) => l.message, (r) => ''),
            contains('Unexpected error'),
          );
          verify(mockRemoteDataSource.getAllExchanges()).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test('should handle empty exchanges list', () async {
        when(
          mockRemoteDataSource.getAllExchanges(),
        ).thenAnswer((_) async => <ExchangeModel>[]);
        final result = await repository.getAllExchanges();
        expect(result.isRight(), isTrue);
        expect(result.fold((l) => null, (r) => r), isEmpty);
        verify(mockRemoteDataSource.getAllExchanges()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should handle single exchange', () async {
        final singleExchange = [tExchanges.first];
        when(
          mockRemoteDataSource.getAllExchanges(),
        ).thenAnswer((_) async => singleExchange);
        final result = await repository.getAllExchanges();
        expect(result.isRight(), isTrue);
        expect(result.fold((l) => null, (r) => r), hasLength(1));
        expect(
          result.fold((l) => null, (r) => r.first),
          equals(singleExchange.first.toEntity()),
        );
        verify(mockRemoteDataSource.getAllExchanges()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should handle large number of exchanges', () async {
        final largeExchanges = List.generate(
          100,
          (index) => ExchangeModel(
            id: index + 1,
            name: 'Exchange $index',
            slug: 'exchange-$index',
            numMarketPairs: 100 + index,
            fiats: ['USD'],
            trafficScore: 50.0 + index,
            rank: index + 1,
            exchangeScore: 80.0 + index,
            liquidityScore: 0.5 + (index * 0.01),
            lastUpdated: DateTime(2025, 1, 1),
            quote: ExchangeQuoteModel(
              volume24h: 100000.0,
              volume24hAdjusted: 100000.0,
              volume7d: 700000.0,
              volume30d: 3000000.0,
              percentChangeVolume24h: 0.05,
              percentChangeVolume7d: 0.1,
              percentChangeVolume30d: 0.2,
              effectiveLiquidity24h: 0.8,
              derivativeVolumeUsd: 50000.0,
              spotVolumeUsd: 50000.0,
            ),
          ),
        );
        when(
          mockRemoteDataSource.getAllExchanges(),
        ).thenAnswer((_) async => largeExchanges);
        final result = await repository.getAllExchanges();
        expect(result.isRight(), isTrue);
        expect(result.fold((l) => null, (r) => r), hasLength(100));
        verify(mockRemoteDataSource.getAllExchanges()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });
    });
  });
}
