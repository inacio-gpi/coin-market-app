import 'package:bloc_test/bloc_test.dart';
import 'package:coin_market_app/core/errors/failures.dart';
import 'package:coin_market_app/features/exchanges/domain/entities/exchange_asset.dart';
import 'package:coin_market_app/features/exchanges/domain/entities/exchange_info.dart';
import 'package:coin_market_app/features/exchanges/domain/usecases/get_exchange_assets.dart';
import 'package:coin_market_app/features/exchanges/domain/usecases/get_exchange_info.dart';
import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_bloc.dart';
import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_event.dart';
import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'exchange_bloc_test.mocks.dart';

@GenerateMocks([GetExchangeAssets, GetExchangeInfo])
void main() {
  group('ExchangeBloc', () {
    late ExchangeBloc exchangeBloc;
    late MockGetExchangeAssets mockGetExchangeAssets;
    late MockGetExchangeInfo mockGetExchangeInfo;

    setUp(() {
      mockGetExchangeAssets = MockGetExchangeAssets();
      mockGetExchangeInfo = MockGetExchangeInfo();
      exchangeBloc = ExchangeBloc(
        getExchangeAssets: mockGetExchangeAssets,
        getExchangeInfo: mockGetExchangeInfo,
      );
    });

    tearDown(() {
      exchangeBloc.close();
    });

    test('initial state should be ExchangeInitial', () {
      expect(exchangeBloc.state, equals(ExchangeInitial()));
    });

    group('LoadExchangeDetailsEvent', () {
      const exchangeId = 294;
      final mockExchangeInfo = ExchangeInfo(
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
        urls: const ExchangeUrls(
          website: ['https://example.com'],
          twitter: ['https://twitter.com/example'],
          blog: [],
          chat: ['https://t.me/example'],
          fee: ['https://example.com/fees'],
        ),
      );

      final mockExchangeAssets = [
        ExchangeAsset(
          walletAddress: '0x1234567890abcdef',
          balance: 100.0,
          platform: const Platform(
            cryptoId: 1,
            name: 'Ethereum',
            symbol: 'ETH',
          ),
          currency: const Currency(
            cryptoId: 1,
            name: 'Ethereum',
            symbol: 'ETH',
            priceUsd: 3000.0,
          ),
        ),
        ExchangeAsset(
          walletAddress: '0xfedcba0987654321',
          balance: 50.0,
          platform: const Platform(cryptoId: 2, name: 'Bitcoin', symbol: 'BTC'),
          currency: const Currency(
            cryptoId: 2,
            name: 'Bitcoin',
            symbol: 'BTC',
            priceUsd: 50000.0,
          ),
        ),
      ];

      blocTest<ExchangeBloc, ExchangeState>(
        'emits [ExchangeLoading, ExchangeDetailsLoaded] when LoadExchangeDetailsEvent is added and both use cases return success',
        build: () {
          when(
            mockGetExchangeInfo(exchangeId),
          ).thenAnswer((_) async => Right(mockExchangeInfo));
          when(
            mockGetExchangeAssets(exchangeId),
          ).thenAnswer((_) async => Right(mockExchangeAssets));
          return exchangeBloc;
        },
        act: (bloc) =>
            bloc.add(LoadExchangeDetailsEvent(exchangeId: exchangeId)),
        expect: () => [
          ExchangeLoading(),
          ExchangeDetailsLoaded(
            info: mockExchangeInfo,
            assets: mockExchangeAssets,
          ),
        ],
        verify: (_) {
          verify(mockGetExchangeInfo(exchangeId)).called(1);
          verify(mockGetExchangeAssets(exchangeId)).called(1);
        },
      );

      blocTest<ExchangeBloc, ExchangeState>(
        'emits [ExchangeLoading, ExchangeError] when GetExchangeInfo fails',
        build: () {
          when(mockGetExchangeInfo(exchangeId)).thenAnswer(
            (_) async => Left(ServerFailure(message: 'Server error')),
          );
          when(
            mockGetExchangeAssets(exchangeId),
          ).thenAnswer((_) async => Right(mockExchangeAssets));
          return exchangeBloc;
        },
        act: (bloc) =>
            bloc.add(LoadExchangeDetailsEvent(exchangeId: exchangeId)),
        expect: () => [
          ExchangeLoading(),
          const ExchangeError(message: 'Server error'),
        ],
        verify: (_) {
          verify(mockGetExchangeInfo(exchangeId)).called(1);
          verify(mockGetExchangeAssets(exchangeId)).called(1);
        },
      );

      blocTest<ExchangeBloc, ExchangeState>(
        'emits [ExchangeLoading, ExchangeError] when GetExchangeAssets fails',
        build: () {
          when(
            mockGetExchangeInfo(exchangeId),
          ).thenAnswer((_) async => Right(mockExchangeInfo));
          when(
            mockGetExchangeAssets(exchangeId),
          ).thenAnswer((_) async => Left(CacheFailure(message: 'Cache error')));
          return exchangeBloc;
        },
        act: (bloc) =>
            bloc.add(LoadExchangeDetailsEvent(exchangeId: exchangeId)),
        expect: () => [
          ExchangeLoading(),
          const ExchangeError(message: 'Cache error'),
        ],
        verify: (_) {
          verify(mockGetExchangeInfo(exchangeId)).called(1);
          verify(mockGetExchangeAssets(exchangeId)).called(1);
        },
      );

      blocTest<ExchangeBloc, ExchangeState>(
        'emits [ExchangeLoading, ExchangeError] when both use cases fail',
        build: () {
          when(mockGetExchangeInfo(exchangeId)).thenAnswer(
            (_) async => Left(ServerFailure(message: 'Server error')),
          );
          when(
            mockGetExchangeAssets(exchangeId),
          ).thenAnswer((_) async => Left(CacheFailure(message: 'Cache error')));
          return exchangeBloc;
        },
        act: (bloc) =>
            bloc.add(LoadExchangeDetailsEvent(exchangeId: exchangeId)),
        expect: () => [
          ExchangeLoading(),
          const ExchangeError(message: 'Server error'),
        ],
        verify: (_) {
          verify(mockGetExchangeInfo(exchangeId)).called(1);
          verify(mockGetExchangeAssets(exchangeId)).called(1);
        },
      );
    });

    group('RefreshExchangeAssetsEvent', () {
      const exchangeId = 294;
      final mockExchangeInfo = ExchangeInfo(
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
        urls: const ExchangeUrls(
          website: ['https://example.com'],
          twitter: ['https://twitter.com/example'],
          blog: [],
          chat: ['https://t.me/example'],
          fee: ['https://example.com/fees'],
        ),
      );

      final mockExchangeAssets = [
        ExchangeAsset(
          walletAddress: '0x1234567890abcdef',
          balance: 100.0,
          platform: const Platform(
            cryptoId: 1,
            name: 'Ethereum',
            symbol: 'ETH',
          ),
          currency: const Currency(
            cryptoId: 1,
            name: 'Ethereum',
            symbol: 'ETH',
            priceUsd: 3000.0,
          ),
        ),
      ];

      blocTest<ExchangeBloc, ExchangeState>(
        'emits [ExchangeDetailsLoaded] when RefreshExchangeAssetsEvent is added and use case returns success with current state as ExchangeDetailsLoaded',
        build: () {
          when(
            mockGetExchangeAssets(exchangeId),
          ).thenAnswer((_) async => Right(mockExchangeAssets));
          return exchangeBloc;
        },
        seed: () => ExchangeDetailsLoaded(info: mockExchangeInfo, assets: []),
        act: (bloc) =>
            bloc.add(RefreshExchangeAssetsEvent(exchangeId: exchangeId)),
        expect: () => [
          ExchangeDetailsLoaded(
            info: mockExchangeInfo,
            assets: mockExchangeAssets,
          ),
        ],
        verify: (_) {
          verify(mockGetExchangeAssets(exchangeId)).called(1);
        },
      );

      blocTest<ExchangeBloc, ExchangeState>(
        'emits [ExchangeError] when RefreshExchangeAssetsEvent is added and use case fails',
        build: () {
          when(mockGetExchangeAssets(exchangeId)).thenAnswer(
            (_) async => Left(ServerFailure(message: 'Server error')),
          );
          return exchangeBloc;
        },
        seed: () => ExchangeDetailsLoaded(info: mockExchangeInfo, assets: []),
        act: (bloc) =>
            bloc.add(RefreshExchangeAssetsEvent(exchangeId: exchangeId)),
        expect: () => [const ExchangeError(message: 'Server error')],
        verify: (_) {
          verify(mockGetExchangeAssets(exchangeId)).called(1);
        },
      );

      blocTest<ExchangeBloc, ExchangeState>(
        'emits [ExchangeError] when RefreshExchangeAssetsEvent is added but current state is not ExchangeDetailsLoaded',
        build: () {
          when(
            mockGetExchangeAssets(exchangeId),
          ).thenAnswer((_) async => Right(mockExchangeAssets));
          return exchangeBloc;
        },
        seed: () => ExchangeInitial(),
        act: (bloc) =>
            bloc.add(RefreshExchangeAssetsEvent(exchangeId: exchangeId)),
        expect: () => [
          const ExchangeError(message: 'No exchange info available'),
        ],
        verify: (_) {
          verify(mockGetExchangeAssets(exchangeId)).called(1);
        },
      );
    });
  });
}
