import 'package:coin_market_app/core/errors/exceptions.dart';
import 'package:coin_market_app/features/exchanges/data/datasources/exchange_local_datasource.dart';
import 'package:coin_market_app/features/exchanges/data/datasources/exchange_remote_datasource.dart';
import 'package:coin_market_app/features/exchanges/data/models/exchange_asset_model.dart';
import 'package:coin_market_app/features/exchanges/data/models/exchange_info_model.dart';
import 'package:coin_market_app/features/exchanges/data/repositories_impl/exchange_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'exchange_repository_impl_test.mocks.dart';

@GenerateMocks([ExchangeRemoteDataSource, ExchangeLocalDataSource])
void main() {
  group('ExchangeRepositoryImpl', () {
    late ExchangeRepositoryImpl repository;
    late MockExchangeRemoteDataSource mockRemoteDataSource;
    late MockExchangeLocalDataSource mockLocalDataSource;

    setUp(() {
      mockRemoteDataSource = MockExchangeRemoteDataSource();
      mockLocalDataSource = MockExchangeLocalDataSource();
      repository = ExchangeRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
      );
    });

    const tExchangeId = 294;
    final tExchangeInfo = ExchangeInfoModel(
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
      urls: const ExchangeUrlsModel(
        website: ['https://example.com'],
        twitter: ['https://twitter.com/example'],
        blog: [],
        chat: ['https://t.me/example'],
        fee: ['https://example.com/fees'],
      ),
    );

    final tExchangeAssets = [
      ExchangeAssetModel(
        walletAddress: '0x1234567890abcdef',
        balance: 100.0,
        platform: const PlatformModel(
          cryptoId: 1,
          name: 'Ethereum',
          symbol: 'ETH',
        ),
        currency: const CurrencyModel(
          cryptoId: 1,
          name: 'Ethereum',
          symbol: 'ETH',
          priceUsd: 3000.0,
        ),
      ),
      ExchangeAssetModel(
        walletAddress: '0xfedcba0987654321',
        balance: 50.0,
        platform: const PlatformModel(
          cryptoId: 2,
          name: 'Bitcoin',
          symbol: 'BTC',
        ),
        currency: const CurrencyModel(
          cryptoId: 2,
          name: 'Bitcoin',
          symbol: 'BTC',
          priceUsd: 50000.0,
        ),
      ),
    ];

    group('getExchangeInfo', () {
      test(
        'should return ExchangeInfo when remote data source is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getExchangeInfo(tExchangeId),
          ).thenAnswer((_) async => tExchangeInfo);

          // act
          final result = await repository.getExchangeInfo(tExchangeId);

          // assert
          expect(result, equals(Right(tExchangeInfo)));
          verify(mockRemoteDataSource.getExchangeInfo(tExchangeId));
          verifyNoMoreInteractions(mockRemoteDataSource);
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );

      test(
        'should return ServerFailure when remote data source fails',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getExchangeInfo(tExchangeId),
          ).thenThrow(ServerException(message: 'Server error'));

          // act
          final result = await repository.getExchangeInfo(tExchangeId);

          // assert
          expect(result.isLeft(), isTrue);
          expect(
            result.fold((l) => l.message, (r) => ''),
            contains('Server error'),
          );
          verify(mockRemoteDataSource.getExchangeInfo(tExchangeId));
          verifyNoMoreInteractions(mockRemoteDataSource);
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );

      test(
        'should return ServerFailure when remote data source throws unexpected error',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getExchangeInfo(tExchangeId),
          ).thenThrow(Exception('Unexpected error'));

          // act
          final result = await repository.getExchangeInfo(tExchangeId);

          // assert
          expect(result.isLeft(), isTrue);
          expect(
            result.fold((l) => l.message, (r) => ''),
            contains('Unexpected error'),
          );
          verify(mockRemoteDataSource.getExchangeInfo(tExchangeId));
          verifyNoMoreInteractions(mockRemoteDataSource);
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );

      test('should handle different exchange IDs', () async {
        // arrange
        const differentId = 295;
        final differentInfo = ExchangeInfoModel(
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
          urls: const ExchangeUrlsModel(
            website: ['https://another.com'],
            twitter: ['https://twitter.com/another'],
            blog: ['https://blog.another.com'],
            chat: ['https://t.me/another'],
            fee: ['https://another.com/fees'],
          ),
        );

        when(
          mockRemoteDataSource.getExchangeInfo(differentId),
        ).thenAnswer((_) async => differentInfo);

        // act
        final result = await repository.getExchangeInfo(differentId);

        // assert
        expect(result, equals(Right(differentInfo)));
        verify(mockRemoteDataSource.getExchangeInfo(differentId));
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });
    });

    group('getExchangeAssets', () {
      test(
        'should return ExchangeAssets when remote data source is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getExchangeAssets(tExchangeId),
          ).thenAnswer((_) async => tExchangeAssets);

          // act
          final result = await repository.getExchangeAssets(tExchangeId);

          // assert
          expect(result.isRight(), isTrue);
          expect(result.fold((l) => null, (r) => r), equals(tExchangeAssets));
          verify(mockRemoteDataSource.getExchangeAssets(tExchangeId));
          verify(
            mockLocalDataSource.cacheExchangeAssets(
              tExchangeId,
              tExchangeAssets,
            ),
          );
          verifyNoMoreInteractions(mockRemoteDataSource);
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );

      test(
        'should return ServerFailure when remote data source fails',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getExchangeAssets(tExchangeId),
          ).thenThrow(ServerException(message: 'Server error'));

          // act
          final result = await repository.getExchangeAssets(tExchangeId);

          // assert
          expect(result.isLeft(), isTrue);
          expect(
            result.fold((l) => l.message, (r) => ''),
            contains('Server error'),
          );
          verify(mockRemoteDataSource.getExchangeAssets(tExchangeId));
          verifyNoMoreInteractions(mockRemoteDataSource);
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );

      test(
        'should return ServerFailure when remote data source throws unexpected error',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getExchangeAssets(tExchangeId),
          ).thenThrow(Exception('Unexpected error'));

          // act
          final result = await repository.getExchangeAssets(tExchangeId);

          // assert
          expect(result.isLeft(), isTrue);
          expect(
            result.fold((l) => l.message, (r) => ''),
            contains('Unexpected error'),
          );
          verify(mockRemoteDataSource.getExchangeAssets(tExchangeId));
          verifyNoMoreInteractions(mockRemoteDataSource);
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );

      test('should handle empty assets list', () async {
        // arrange
        when(
          mockRemoteDataSource.getExchangeAssets(tExchangeId),
        ).thenAnswer((_) async => []);

        // act
        final result = await repository.getExchangeAssets(tExchangeId);

        // assert
        expect(result.isRight(), isTrue);
        expect(result.fold((l) => null, (r) => r), isEmpty);
        verify(mockRemoteDataSource.getExchangeAssets(tExchangeId));
        verify(mockLocalDataSource.cacheExchangeAssets(tExchangeId, []));
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('should handle different exchange IDs', () async {
        // arrange
        const differentId = 295;
        final differentAssets = [
          ExchangeAssetModel(
            walletAddress: '0x1111111111111111',
            balance: 25.0,
            platform: const PlatformModel(
              cryptoId: 3,
              name: 'Cardano',
              symbol: 'ADA',
            ),
            currency: const CurrencyModel(
              cryptoId: 3,
              name: 'Cardano',
              symbol: 'ADA',
              priceUsd: 1.0,
            ),
          ),
        ];

        when(
          mockRemoteDataSource.getExchangeAssets(differentId),
        ).thenAnswer((_) async => differentAssets);

        // act
        final result = await repository.getExchangeAssets(differentId);

        // assert
        expect(result.isRight(), isTrue);
        expect(result.fold((l) => null, (r) => r), equals(differentAssets));
        verify(mockRemoteDataSource.getExchangeAssets(differentId));
        verify(
          mockLocalDataSource.cacheExchangeAssets(differentId, differentAssets),
        );
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });
    });
  });
}
