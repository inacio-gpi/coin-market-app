import 'package:coin_market_app/features/exchanges/data/datasources/exchange_local_datasource.dart';
import 'package:coin_market_app/features/exchanges/data/models/exchange_asset_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'exchange_local_datasource_test.mocks.dart';

@GenerateMocks([ExchangeLocalDataSource])
void main() {
  group('ExchangeLocalDataSource', () {
    late MockExchangeLocalDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockExchangeLocalDataSource();
    });

    group('cacheExchangeAssets', () {
      const tExchangeId = 294;
      final tExchangeAssets = [
        ExchangeAssetModel(
          walletAddress: '0x1234567890abcdef',
          balance: 100.5,
          platform: PlatformModel(cryptoId: 1, symbol: 'ETH', name: 'Ethereum'),
          currency: CurrencyModel(
            cryptoId: 1,
            priceUsd: 3000.0,
            symbol: 'ETH',
            name: 'Ethereum',
          ),
        ),
        ExchangeAssetModel(
          walletAddress: '0xabcdef1234567890',
          balance: 50.25,
          platform: PlatformModel(cryptoId: 2, symbol: 'BTC', name: 'Bitcoin'),
          currency: CurrencyModel(
            cryptoId: 2,
            priceUsd: 50000.0,
            symbol: 'BTC',
            name: 'Bitcoin',
          ),
        ),
      ];

      test('should cache exchange assets successfully', () async {
        when(
          mockDataSource.cacheExchangeAssets(tExchangeId, tExchangeAssets),
        ).thenAnswer((_) async {});
        when(
          mockDataSource.getCachedExchangeAssets(tExchangeId),
        ).thenAnswer((_) async => tExchangeAssets);

        await mockDataSource.cacheExchangeAssets(tExchangeId, tExchangeAssets);

        final cachedAssets = await mockDataSource.getCachedExchangeAssets(
          tExchangeId,
        );
        expect(cachedAssets, isNotNull);
        expect(cachedAssets!.length, equals(2));
        expect(cachedAssets.first.walletAddress, equals('0x1234567890abcdef'));
        expect(cachedAssets.last.walletAddress, equals('0xabcdef1234567890'));

        verify(
          mockDataSource.cacheExchangeAssets(tExchangeId, tExchangeAssets),
        ).called(1);
        verify(mockDataSource.getCachedExchangeAssets(tExchangeId)).called(1);
      });

      test('should handle caching empty list', () async {
        when(
          mockDataSource.cacheExchangeAssets(tExchangeId, []),
        ).thenAnswer((_) async {});
        when(
          mockDataSource.getCachedExchangeAssets(tExchangeId),
        ).thenAnswer((_) async => <ExchangeAssetModel>[]);

        await mockDataSource.cacheExchangeAssets(tExchangeId, []);

        final cachedAssets = await mockDataSource.getCachedExchangeAssets(
          tExchangeId,
        );
        expect(cachedAssets, isNotNull);
        expect(cachedAssets, isEmpty);

        verify(mockDataSource.cacheExchangeAssets(tExchangeId, [])).called(1);
        verify(mockDataSource.getCachedExchangeAssets(tExchangeId)).called(1);
      });

      test('should handle caching single asset', () async {
        final singleAsset = [tExchangeAssets.first];
        when(
          mockDataSource.cacheExchangeAssets(tExchangeId, singleAsset),
        ).thenAnswer((_) async {});
        when(
          mockDataSource.getCachedExchangeAssets(tExchangeId),
        ).thenAnswer((_) async => singleAsset);

        await mockDataSource.cacheExchangeAssets(tExchangeId, singleAsset);

        final cachedAssets = await mockDataSource.getCachedExchangeAssets(
          tExchangeId,
        );
        expect(cachedAssets, isNotNull);
        expect(cachedAssets!.length, equals(1));
        expect(cachedAssets.first.walletAddress, equals('0x1234567890abcdef'));

        verify(
          mockDataSource.cacheExchangeAssets(tExchangeId, singleAsset),
        ).called(1);
        verify(mockDataSource.getCachedExchangeAssets(tExchangeId)).called(1);
      });

      test('should handle caching for different exchange IDs', () async {
        const differentId = 123;
        final differentAssets = [
          ExchangeAssetModel(
            walletAddress: '0x9876543210fedcba',
            balance: 75.0,
            platform: PlatformModel(
              cryptoId: 3,
              symbol: 'ADA',
              name: 'Cardano',
            ),
            currency: CurrencyModel(
              cryptoId: 3,
              priceUsd: 0.5,
              symbol: 'ADA',
              name: 'Cardano',
            ),
          ),
        ];

        when(
          mockDataSource.cacheExchangeAssets(tExchangeId, tExchangeAssets),
        ).thenAnswer((_) async {});
        when(
          mockDataSource.cacheExchangeAssets(differentId, differentAssets),
        ).thenAnswer((_) async {});
        when(
          mockDataSource.getCachedExchangeAssets(tExchangeId),
        ).thenAnswer((_) async => tExchangeAssets);
        when(
          mockDataSource.getCachedExchangeAssets(differentId),
        ).thenAnswer((_) async => differentAssets);

        await mockDataSource.cacheExchangeAssets(tExchangeId, tExchangeAssets);
        await mockDataSource.cacheExchangeAssets(differentId, differentAssets);

        final firstCached = await mockDataSource.getCachedExchangeAssets(
          tExchangeId,
        );
        final secondCached = await mockDataSource.getCachedExchangeAssets(
          differentId,
        );

        expect(firstCached, isNotNull);
        expect(firstCached!.length, equals(2));
        expect(secondCached, isNotNull);
        expect(secondCached!.length, equals(1));
        expect(secondCached.first.walletAddress, equals('0x9876543210fedcba'));

        verify(
          mockDataSource.cacheExchangeAssets(tExchangeId, tExchangeAssets),
        ).called(1);
        verify(
          mockDataSource.cacheExchangeAssets(differentId, differentAssets),
        ).called(1);
        verify(mockDataSource.getCachedExchangeAssets(tExchangeId)).called(1);
        verify(mockDataSource.getCachedExchangeAssets(differentId)).called(1);
      });
    });

    group('getCachedExchangeAssets', () {
      const tExchangeId = 294;

      test('should return null when no cached data exists', () async {
        when(
          mockDataSource.getCachedExchangeAssets(tExchangeId),
        ).thenAnswer((_) async => null);

        final cachedAssets = await mockDataSource.getCachedExchangeAssets(
          tExchangeId,
        );
        expect(cachedAssets, isNull);

        verify(mockDataSource.getCachedExchangeAssets(tExchangeId)).called(1);
      });

      test('should return cached data when it exists', () async {
        final tExchangeAssets = [
          ExchangeAssetModel(
            walletAddress: '0x1234567890abcdef',
            balance: 100.5,
            platform: PlatformModel(
              cryptoId: 1,
              symbol: 'ETH',
              name: 'Ethereum',
            ),
            currency: CurrencyModel(
              cryptoId: 1,
              priceUsd: 3000.0,
              symbol: 'ETH',
              name: 'Ethereum',
            ),
          ),
        ];

        when(
          mockDataSource.getCachedExchangeAssets(tExchangeId),
        ).thenAnswer((_) async => tExchangeAssets);

        final cachedAssets = await mockDataSource.getCachedExchangeAssets(
          tExchangeId,
        );

        expect(cachedAssets, isNotNull);
        expect(cachedAssets!.length, equals(1));
        expect(cachedAssets.first.walletAddress, equals('0x1234567890abcdef'));
        expect(cachedAssets.first.balance, equals(100.5));
        expect(cachedAssets.first.platform.symbol, equals('ETH'));
        expect(cachedAssets.first.currency.symbol, equals('ETH'));

        verify(mockDataSource.getCachedExchangeAssets(tExchangeId)).called(1);
      });

      test('should return null for different exchange ID', () async {
        const differentId = 123;
        final tExchangeAssets = [
          ExchangeAssetModel(
            walletAddress: '0x1234567890abcdef',
            balance: 100.5,
            platform: PlatformModel(
              cryptoId: 1,
              symbol: 'ETH',
              name: 'Ethereum',
            ),
            currency: CurrencyModel(
              cryptoId: 1,
              priceUsd: 3000.0,
              symbol: 'ETH',
              name: 'Ethereum',
            ),
          ),
        ];

        when(
          mockDataSource.getCachedExchangeAssets(tExchangeId),
        ).thenAnswer((_) async => tExchangeAssets);
        when(
          mockDataSource.getCachedExchangeAssets(differentId),
        ).thenAnswer((_) async => null);

        final cachedAssets = await mockDataSource.getCachedExchangeAssets(
          differentId,
        );

        expect(cachedAssets, isNull);

        verify(mockDataSource.getCachedExchangeAssets(differentId)).called(1);
      });
    });

    group('clearCache', () {
      const tExchangeId = 294;

      test('should clear cached data for specific exchange', () async {
        when(mockDataSource.clearCache(tExchangeId)).thenAnswer((_) async {});
        when(
          mockDataSource.getCachedExchangeAssets(tExchangeId),
        ).thenAnswer((_) async => null);

        await mockDataSource.clearCache(tExchangeId);

        final clearedAssets = await mockDataSource.getCachedExchangeAssets(
          tExchangeId,
        );
        expect(clearedAssets, isNull);

        verify(mockDataSource.clearCache(tExchangeId)).called(1);
        verify(mockDataSource.getCachedExchangeAssets(tExchangeId)).called(1);
      });

      test(
        'should not affect other exchange caches when clearing specific one',
        () async {
          const firstId = 294;
          const secondId = 123;

          final secondAssets = [
            ExchangeAssetModel(
              walletAddress: '0xabcdef1234567890',
              balance: 50.25,
              platform: PlatformModel(
                cryptoId: 2,
                symbol: 'BTC',
                name: 'Bitcoin',
              ),
              currency: CurrencyModel(
                cryptoId: 2,
                priceUsd: 50000.0,
                symbol: 'BTC',
                name: 'Bitcoin',
              ),
            ),
          ];

          when(mockDataSource.clearCache(firstId)).thenAnswer((_) async {});
          when(
            mockDataSource.getCachedExchangeAssets(firstId),
          ).thenAnswer((_) async => null);
          when(
            mockDataSource.getCachedExchangeAssets(secondId),
          ).thenAnswer((_) async => secondAssets);

          await mockDataSource.clearCache(firstId);

          final firstCached = await mockDataSource.getCachedExchangeAssets(
            firstId,
          );
          final secondCached = await mockDataSource.getCachedExchangeAssets(
            secondId,
          );

          expect(firstCached, isNull);
          expect(secondCached, isNotNull);
          expect(secondCached!.length, equals(1));

          verify(mockDataSource.clearCache(firstId)).called(1);
          verify(mockDataSource.getCachedExchangeAssets(firstId)).called(1);
          verify(mockDataSource.getCachedExchangeAssets(secondId)).called(1);
        },
      );

      test('should handle clearing non-existent cache gracefully', () async {
        const nonExistentId = 999;

        when(mockDataSource.clearCache(nonExistentId)).thenAnswer((_) async {});
        when(
          mockDataSource.getCachedExchangeAssets(nonExistentId),
        ).thenAnswer((_) async => null);

        await mockDataSource.clearCache(nonExistentId);

        final cachedAssets = await mockDataSource.getCachedExchangeAssets(
          nonExistentId,
        );
        expect(cachedAssets, isNull);

        verify(mockDataSource.clearCache(nonExistentId)).called(1);
        verify(mockDataSource.getCachedExchangeAssets(nonExistentId)).called(1);
      });
    });
  });
}
