import 'package:coin_market_app/core/errors/failures.dart';
import 'package:coin_market_app/features/exchanges/domain/entities/exchange_asset.dart';
import 'package:coin_market_app/features/exchanges/domain/repositories/exchange_repository.dart';
import 'package:coin_market_app/features/exchanges/domain/usecases/get_exchange_assets.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_exchange_assets_test.mocks.dart';

@GenerateMocks([ExchangeRepository])
void main() {
  group('GetExchangeAssets', () {
    late GetExchangeAssets usecase;
    late MockExchangeRepository mockExchangeRepository;

    setUp(() {
      mockExchangeRepository = MockExchangeRepository();
      usecase = GetExchangeAssets(mockExchangeRepository);
    });

    const tExchangeId = 294;
    final tExchangeAssets = [
      ExchangeAsset(
        walletAddress: '0x1234567890abcdef',
        balance: 100.0,
        platform: const Platform(cryptoId: 1, name: 'Ethereum', symbol: 'ETH'),
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

    test('should get exchange assets from the repository', () async {
      // arrange
      when(
        mockExchangeRepository.getExchangeAssets(tExchangeId),
      ).thenAnswer((_) async => Right(tExchangeAssets));

      // act
      final result = await usecase(tExchangeId);

      // assert
      expect(result, equals(Right(tExchangeAssets)));
      verify(mockExchangeRepository.getExchangeAssets(tExchangeId));
      verifyNoMoreInteractions(mockExchangeRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // arrange
      final failure = ServerFailure(message: 'Server error occurred');
      when(
        mockExchangeRepository.getExchangeAssets(tExchangeId),
      ).thenAnswer((_) async => Left(failure));

      // act
      final result = await usecase(tExchangeId);

      // assert
      expect(result, equals(Left(failure)));
      verify(mockExchangeRepository.getExchangeAssets(tExchangeId));
      verifyNoMoreInteractions(mockExchangeRepository);
    });

    test(
      'should return CacheFailure when repository fails with cache error',
      () async {
        // arrange
        final failure = CacheFailure(message: 'Cache error occurred');
        when(
          mockExchangeRepository.getExchangeAssets(tExchangeId),
        ).thenAnswer((_) async => Left(failure));

        // act
        final result = await usecase(tExchangeId);

        // assert
        expect(result, equals(Left(failure)));
        verify(mockExchangeRepository.getExchangeAssets(tExchangeId));
        verifyNoMoreInteractions(mockExchangeRepository);
      },
    );

    test(
      'should return UnknownFailure when repository fails with unknown error',
      () async {
        // arrange
        final failure = UnknownFailure(message: 'Unknown error occurred');
        when(
          mockExchangeRepository.getExchangeAssets(tExchangeId),
        ).thenAnswer((_) async => Left(failure));

        // act
        final result = await usecase(tExchangeId);

        // assert
        expect(result, equals(Left(failure)));
        verify(mockExchangeRepository.getExchangeAssets(tExchangeId));
        verifyNoMoreInteractions(mockExchangeRepository);
      },
    );

    test('should handle empty assets list', () async {
      // arrange
      when(
        mockExchangeRepository.getExchangeAssets(tExchangeId),
      ).thenAnswer((_) async => Right([]));

      // act
      final result = await usecase(tExchangeId);

      // assert
      expect(result.isRight(), isTrue);
      expect(result.fold((l) => null, (r) => r), isEmpty);
      verify(mockExchangeRepository.getExchangeAssets(tExchangeId));
      verifyNoMoreInteractions(mockExchangeRepository);
    });

    test('should handle different exchange IDs', () async {
      // arrange
      const differentId = 295;
      final differentAssets = [
        ExchangeAsset(
          walletAddress: '0x1111111111111111',
          balance: 25.0,
          platform: const Platform(cryptoId: 3, name: 'Cardano', symbol: 'ADA'),
          currency: const Currency(
            cryptoId: 3,
            name: 'Cardano',
            symbol: 'ADA',
            priceUsd: 1.0,
          ),
        ),
      ];

      when(
        mockExchangeRepository.getExchangeAssets(differentId),
      ).thenAnswer((_) async => Right(differentAssets));

      // act
      final result = await usecase(differentId);

      // assert
      expect(result, equals(Right(differentAssets)));
      verify(mockExchangeRepository.getExchangeAssets(differentId));
      verifyNoMoreInteractions(mockExchangeRepository);
    });

    test('should handle zero exchange ID', () async {
      // arrange
      const zeroId = 0;
      when(
        mockExchangeRepository.getExchangeAssets(zeroId),
      ).thenAnswer((_) async => Left(ServerFailure(message: 'Invalid ID')));

      // act
      final result = await usecase(zeroId);

      // assert
      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l.message, (r) => ''), equals('Invalid ID'));
      verify(mockExchangeRepository.getExchangeAssets(zeroId));
      verifyNoMoreInteractions(mockExchangeRepository);
    });

    test('should handle negative exchange ID', () async {
      // arrange
      const negativeId = -1;
      when(
        mockExchangeRepository.getExchangeAssets(negativeId),
      ).thenAnswer((_) async => Left(ServerFailure(message: 'Invalid ID')));

      // act
      final result = await usecase(negativeId);

      // assert
      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l.message, (r) => ''), equals('Invalid ID'));
      verify(mockExchangeRepository.getExchangeAssets(negativeId));
      verifyNoMoreInteractions(mockExchangeRepository);
    });

    test('should handle very large exchange ID', () async {
      // arrange
      const largeId = 999999;
      when(mockExchangeRepository.getExchangeAssets(largeId)).thenAnswer(
        (_) async => Left(ServerFailure(message: 'Exchange not found')),
      );

      // act
      final result = await usecase(largeId);

      // assert
      expect(result.isLeft(), isTrue);
      expect(
        result.fold((l) => l.message, (r) => ''),
        equals('Exchange not found'),
      );
      verify(mockExchangeRepository.getExchangeAssets(largeId));
      verifyNoMoreInteractions(mockExchangeRepository);
    });

    test('should handle single asset', () async {
      // arrange
      final singleAsset = [
        ExchangeAsset(
          walletAddress: '0x9999999999999999',
          balance: 1000.0,
          platform: const Platform(cryptoId: 4, name: 'Solana', symbol: 'SOL'),
          currency: const Currency(
            cryptoId: 4,
            name: 'Solana',
            symbol: 'SOL',
            priceUsd: 100.0,
          ),
        ),
      ];

      when(
        mockExchangeRepository.getExchangeAssets(tExchangeId),
      ).thenAnswer((_) async => Right(singleAsset));

      // act
      final result = await usecase(tExchangeId);

      // assert
      expect(result, equals(Right(singleAsset)));
      expect(result.fold((l) => null, (r) => r)?.length, equals(1));
      verify(mockExchangeRepository.getExchangeAssets(tExchangeId));
      verifyNoMoreInteractions(mockExchangeRepository);
    });
  });
}
