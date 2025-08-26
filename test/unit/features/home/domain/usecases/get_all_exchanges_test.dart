import 'package:coin_market_app/core/errors/failures.dart';
import 'package:coin_market_app/features/home/domain/entities/exchange.dart';
import 'package:coin_market_app/features/home/domain/repositories/home_repository.dart';
import 'package:coin_market_app/features/home/domain/usecases/get_all_exchanges.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_all_exchanges_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  group('GetAllExchanges', () {
    late GetAllExchanges usecase;
    late MockHomeRepository mockHomeRepository;

    setUp(() {
      mockHomeRepository = MockHomeRepository();
      usecase = GetAllExchanges(mockHomeRepository);
    });

    final tExchanges = [
      Exchange(
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
        quote: const ExchangeQuote(
          volume24h: 1000000.0,
          volume24hAdjusted: 1000000.0,
          volume7d: 7000000.0,
          volume30d: 30000000.0,
          percentChangeVolume24h: 0.05,
          percentChangeVolume7d: 0.10,
          percentChangeVolume30d: 0.20,
          effectiveLiquidity24h: 0.8,
          derivativeVolumeUsd: 500000.0,
          spotVolumeUsd: 500000.0,
        ),
      ),
      Exchange(
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
        quote: const ExchangeQuote(
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

    test('should get all exchanges from the repository', () async {
      // arrange
      when(
        mockHomeRepository.getAllExchanges(),
      ).thenAnswer((_) async => Right(tExchanges));

      // act
      final result = await usecase(null);

      // assert
      expect(result, equals(Right(tExchanges)));
      verify(mockHomeRepository.getAllExchanges());
      verifyNoMoreInteractions(mockHomeRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // arrange
      final failure = ServerFailure(message: 'Server error occurred');
      when(
        mockHomeRepository.getAllExchanges(),
      ).thenAnswer((_) async => Left(failure));

      // act
      final result = await usecase(null);

      // assert
      expect(result, equals(Left(failure)));
      verify(mockHomeRepository.getAllExchanges());
      verifyNoMoreInteractions(mockHomeRepository);
    });

    test(
      'should return CacheFailure when repository fails with cache error',
      () async {
        // arrange
        final failure = CacheFailure(message: 'Cache error occurred');
        when(
          mockHomeRepository.getAllExchanges(),
        ).thenAnswer((_) async => Left(failure));

        // act
        final result = await usecase(null);

        // assert
        expect(result, equals(Left(failure)));
        verify(mockHomeRepository.getAllExchanges());
        verifyNoMoreInteractions(mockHomeRepository);
      },
    );

    test(
      'should return UnknownFailure when repository fails with unknown error',
      () async {
        // arrange
        final failure = UnknownFailure(message: 'Unknown error occurred');
        when(
          mockHomeRepository.getAllExchanges(),
        ).thenAnswer((_) async => Left(failure));

        // act
        final result = await usecase(null);

        // assert
        expect(result, equals(Left(failure)));
        verify(mockHomeRepository.getAllExchanges());
        verifyNoMoreInteractions(mockHomeRepository);
      },
    );

    test('should handle empty exchanges list', () async {
      // arrange
      when(
        mockHomeRepository.getAllExchanges(),
      ).thenAnswer((_) async => Right([]));

      // act
      final result = await usecase(null);

      // assert
      expect(result.isRight(), isTrue);
      expect(result.fold((l) => null, (r) => r), isEmpty);
      verify(mockHomeRepository.getAllExchanges());
      verifyNoMoreInteractions(mockHomeRepository);
    });
  });
}
