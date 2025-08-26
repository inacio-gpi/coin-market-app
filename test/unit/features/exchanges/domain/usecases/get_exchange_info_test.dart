import 'package:coin_market_app/core/errors/failures.dart';
import 'package:coin_market_app/features/exchanges/domain/entities/exchange_info.dart';
import 'package:coin_market_app/features/exchanges/domain/repositories/exchange_repository.dart';
import 'package:coin_market_app/features/exchanges/domain/usecases/get_exchange_info.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_exchange_info_test.mocks.dart';

@GenerateMocks([ExchangeRepository])
void main() {
  group('GetExchangeInfo', () {
    late GetExchangeInfo usecase;
    late MockExchangeRepository mockExchangeRepository;

    setUp(() {
      mockExchangeRepository = MockExchangeRepository();
      usecase = GetExchangeInfo(mockExchangeRepository);
    });

    const tExchangeId = 294;
    final tExchangeInfo = ExchangeInfo(
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

    test('should get exchange info from the repository', () async {
      // arrange
      when(
        mockExchangeRepository.getExchangeInfo(tExchangeId),
      ).thenAnswer((_) async => Right(tExchangeInfo));

      // act
      final result = await usecase(tExchangeId);

      // assert
      expect(result, equals(Right(tExchangeInfo)));
      verify(mockExchangeRepository.getExchangeInfo(tExchangeId));
      verifyNoMoreInteractions(mockExchangeRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // arrange
      final failure = ServerFailure(message: 'Server error occurred');
      when(
        mockExchangeRepository.getExchangeInfo(tExchangeId),
      ).thenAnswer((_) async => Left(failure));

      // act
      final result = await usecase(tExchangeId);

      // assert
      expect(result, equals(Left(failure)));
      verify(mockExchangeRepository.getExchangeInfo(tExchangeId));
      verifyNoMoreInteractions(mockExchangeRepository);
    });

    test(
      'should return CacheFailure when repository fails with cache error',
      () async {
        // arrange
        final failure = CacheFailure(message: 'Cache error occurred');
        when(
          mockExchangeRepository.getExchangeInfo(tExchangeId),
        ).thenAnswer((_) async => Left(failure));

        // act
        final result = await usecase(tExchangeId);

        // assert
        expect(result, equals(Left(failure)));
        verify(mockExchangeRepository.getExchangeInfo(tExchangeId));
        verifyNoMoreInteractions(mockExchangeRepository);
      },
    );

    test(
      'should return UnknownFailure when repository fails with unknown error',
      () async {
        // arrange
        final failure = UnknownFailure(message: 'Unknown error occurred');
        when(
          mockExchangeRepository.getExchangeInfo(tExchangeId),
        ).thenAnswer((_) async => Left(failure));

        // act
        final result = await usecase(tExchangeId);

        // assert
        expect(result, equals(Left(failure)));
        verify(mockExchangeRepository.getExchangeInfo(tExchangeId));
        verifyNoMoreInteractions(mockExchangeRepository);
      },
    );

    test('should handle different exchange IDs', () async {
      // arrange
      const differentId = 295;
      final differentInfo = ExchangeInfo(
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
        urls: const ExchangeUrls(
          website: ['https://another.com'],
          twitter: ['https://twitter.com/another'],
          blog: ['https://blog.another.com'],
          chat: ['https://t.me/another'],
          fee: ['https://another.com/fees'],
        ),
      );

      when(
        mockExchangeRepository.getExchangeInfo(differentId),
      ).thenAnswer((_) async => Right(differentInfo));

      // act
      final result = await usecase(differentId);

      // assert
      expect(result, equals(Right(differentInfo)));
      verify(mockExchangeRepository.getExchangeInfo(differentId));
      verifyNoMoreInteractions(mockExchangeRepository);
    });

    test('should handle zero exchange ID', () async {
      // arrange
      const zeroId = 0;
      when(
        mockExchangeRepository.getExchangeInfo(zeroId),
      ).thenAnswer((_) async => Left(ServerFailure(message: 'Invalid ID')));

      // act
      final result = await usecase(zeroId);

      // assert
      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l.message, (r) => ''), equals('Invalid ID'));
      verify(mockExchangeRepository.getExchangeInfo(zeroId));
      verifyNoMoreInteractions(mockExchangeRepository);
    });

    test('should handle negative exchange ID', () async {
      // arrange
      const negativeId = -1;
      when(
        mockExchangeRepository.getExchangeInfo(negativeId),
      ).thenAnswer((_) async => Left(ServerFailure(message: 'Invalid ID')));

      // act
      final result = await usecase(negativeId);

      // assert
      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l.message, (r) => ''), equals('Invalid ID'));
      verify(mockExchangeRepository.getExchangeInfo(negativeId));
      verifyNoMoreInteractions(mockExchangeRepository);
    });

    test('should handle very large exchange ID', () async {
      // arrange
      const largeId = 999999;
      when(mockExchangeRepository.getExchangeInfo(largeId)).thenAnswer(
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
      verify(mockExchangeRepository.getExchangeInfo(largeId));
      verifyNoMoreInteractions(mockExchangeRepository);
    });
  });
}
