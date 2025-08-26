import 'package:bloc_test/bloc_test.dart';
import 'package:coin_market_app/core/errors/failures.dart';
import 'package:coin_market_app/features/home/domain/entities/exchange.dart';
import 'package:coin_market_app/features/home/domain/usecases/get_all_exchanges.dart';
import 'package:coin_market_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:coin_market_app/features/home/presentation/bloc/home_event.dart';
import 'package:coin_market_app/features/home/presentation/bloc/home_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_bloc_test.mocks.dart';

@GenerateMocks([GetAllExchanges])
void main() {
  group('HomeBloc', () {
    late HomeBloc homeBloc;
    late MockGetAllExchanges mockGetAllExchanges;

    setUp(() {
      mockGetAllExchanges = MockGetAllExchanges();
      homeBloc = HomeBloc(getAllExchanges: mockGetAllExchanges);
    });

    tearDown(() {
      homeBloc.close();
    });

    test('initial state should be HomeInitial', () {
      expect(homeBloc.state, equals(HomeInitial()));
    });

    group('GetAllExchangesEvent', () {
      final mockExchanges = [
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

      blocTest<HomeBloc, HomeState>(
        'emits [HomeLoading, ExchangesLoaded] when GetAllExchangesEvent is added and use case returns success',
        build: () {
          when(
            mockGetAllExchanges(null),
          ).thenAnswer((_) async => Right(mockExchanges));
          return homeBloc;
        },
        act: (bloc) => bloc.add(GetAllExchangesEvent()),
        expect: () => [
          HomeLoading(),
          ExchangesLoaded(exchanges: mockExchanges),
        ],
        verify: (_) {
          verify(mockGetAllExchanges(null)).called(1);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'emits [HomeLoading, HomeError] when GetAllExchangesEvent is added and use case returns failure',
        build: () {
          when(mockGetAllExchanges(null)).thenAnswer(
            (_) async => Left(ServerFailure(message: 'Server error occurred')),
          );
          return homeBloc;
        },
        act: (bloc) => bloc.add(GetAllExchangesEvent()),
        expect: () => [
          HomeLoading(),
          const HomeError(message: 'Server error occurred'),
        ],
        verify: (_) {
          verify(mockGetAllExchanges(null)).called(1);
        },
      );
    });

    test('should handle multiple events correctly', () async {
      final mockExchanges = [
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
      ];

      when(
        mockGetAllExchanges(null),
      ).thenAnswer((_) async => Right(mockExchanges));

      // Add multiple events
      homeBloc.add(GetAllExchangesEvent());
      homeBloc.add(GetAllExchangesEvent());

      await expectLater(
        homeBloc.stream,
        emitsInOrder([
          HomeLoading(),
          ExchangesLoaded(exchanges: mockExchanges),
          HomeLoading(),
          ExchangesLoaded(exchanges: mockExchanges),
        ]),
      );

      verify(mockGetAllExchanges(null)).called(2);
    });
  });
}
