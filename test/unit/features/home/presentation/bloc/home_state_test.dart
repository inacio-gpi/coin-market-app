import 'package:coin_market_app/features/home/domain/entities/exchange.dart';
import 'package:coin_market_app/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeState', () {
    group('HomeInitial', () {
      test('should be equal when instances are the same', () {
        final state1 = HomeInitial();
        final state2 = HomeInitial();

        expect(state1, equals(state2));
      });

      test('should have correct hash code', () {
        final state1 = HomeInitial();
        final state2 = HomeInitial();

        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should have correct string representation', () {
        final state = HomeInitial();
        expect(state.toString(), equals('HomeInitial()'));
      });

      test('should be instance of HomeInitial', () {
        final state = HomeInitial();
        expect(state, isA<HomeInitial>());
      });

      test('should be instance of HomeState', () {
        final state = HomeInitial();
        expect(state, isA<HomeState>());
      });
    });

    group('HomeLoading', () {
      test('should be equal when instances are the same', () {
        final state1 = HomeLoading();
        final state2 = HomeLoading();

        expect(state1, equals(state2));
      });

      test('should have correct hash code', () {
        final state1 = HomeLoading();
        final state2 = HomeLoading();

        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should have correct string representation', () {
        final state = HomeLoading();
        expect(state.toString(), equals('HomeLoading()'));
      });

      test('should be instance of HomeLoading', () {
        final state = HomeLoading();
        expect(state, isA<HomeLoading>());
      });

      test('should be instance of HomeState', () {
        final state = HomeLoading();
        expect(state, isA<HomeState>());
      });
    });

    group('ExchangesLoaded', () {
      late List<Exchange> mockExchanges;

      setUp(() {
        mockExchanges = [
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
      });

      test('should be equal when instances have same exchanges', () {
        final state1 = ExchangesLoaded(exchanges: mockExchanges);
        final state2 = ExchangesLoaded(exchanges: mockExchanges);

        expect(state1, equals(state2));
      });

      test('should not be equal when instances have different exchanges', () {
        final differentExchanges = [
          Exchange(
            id: 3,
            name: 'Kraken',
            slug: 'kraken',
            numMarketPairs: 300,
            fiats: ['USD'],
            trafficScore: 70.0,
            rank: 3,
            exchangeScore: 85.0,
            liquidityScore: 0.7,
            lastUpdated: DateTime(2025, 1, 1),
            quote: const ExchangeQuote(
              volume24h: 300000.0,
              volume24hAdjusted: 300000.0,
              volume7d: 2100000.0,
              volume30d: 9000000.0,
              percentChangeVolume24h: 0.02,
              percentChangeVolume7d: 0.06,
              percentChangeVolume30d: 0.12,
              effectiveLiquidity24h: 0.6,
              derivativeVolumeUsd: 150000.0,
              spotVolumeUsd: 150000.0,
            ),
          ),
        ];

        final state1 = ExchangesLoaded(exchanges: mockExchanges);
        final state2 = ExchangesLoaded(exchanges: differentExchanges);

        expect(state1, isNot(equals(state2)));
      });

      test('should have correct hash code', () {
        final state1 = ExchangesLoaded(exchanges: mockExchanges);
        final state2 = ExchangesLoaded(exchanges: mockExchanges);

        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should have correct string representation', () {
        final state = ExchangesLoaded(exchanges: mockExchanges);
        expect(state.toString(), contains('ExchangesLoaded'));
        expect(state.toString(), contains('Exchange('));
      });

      test('should be instance of ExchangesLoaded', () {
        final state = ExchangesLoaded(exchanges: mockExchanges);
        expect(state, isA<ExchangesLoaded>());
      });

      test('should be instance of HomeState', () {
        final state = ExchangesLoaded(exchanges: mockExchanges);
        expect(state, isA<HomeState>());
      });

      test('should have correct exchanges property', () {
        final state = ExchangesLoaded(exchanges: mockExchanges);
        expect(state.exchanges, equals(mockExchanges));
        expect(state.exchanges.length, equals(2));
        expect(state.exchanges.first.name, equals('Binance'));
        expect(state.exchanges.last.name, equals('Coinbase'));
      });

      test('should handle empty exchanges list', () {
        final state = ExchangesLoaded(exchanges: []);
        expect(state.exchanges, isEmpty);
        expect(state.exchanges.length, equals(0));
      });
    });

    group('HomeError', () {
      test('should be equal when instances have same message', () {
        const state1 = HomeError(message: 'Server error occurred');
        const state2 = HomeError(message: 'Server error occurred');

        expect(state1, equals(state2));
      });

      test('should not be equal when instances have different messages', () {
        const state1 = HomeError(message: 'Server error occurred');
        const state2 = HomeError(message: 'Network error occurred');

        expect(state1, isNot(equals(state2)));
      });

      test('should have correct hash code', () {
        const state1 = HomeError(message: 'Server error occurred');
        const state2 = HomeError(message: 'Server error occurred');

        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should have correct string representation', () {
        const state = HomeError(message: 'Server error occurred');
        expect(state.toString(), contains('HomeError'));
        expect(state.toString(), contains('Server error occurred'));
      });

      test('should be instance of HomeError', () {
        const state = HomeError(message: 'Server error occurred');
        expect(state, isA<HomeError>());
      });

      test('should be instance of HomeState', () {
        const state = HomeError(message: 'Server error occurred');
        expect(state, isA<HomeState>());
      });

      test('should have correct message property', () {
        const state = HomeError(message: 'Server error occurred');
        expect(state.message, equals('Server error occurred'));
      });

      test('should handle empty message', () {
        const state = HomeError(message: '');
        expect(state.message, equals(''));
      });

      test('should handle long message', () {
        const longMessage =
            'This is a very long error message that contains many characters and should be handled properly by the error state';
        const state = HomeError(message: longMessage);
        expect(state.message, equals(longMessage));
      });
    });

    test('should have different hash codes for different state types', () {
      final initial = HomeInitial();
      final loading = HomeLoading();
      final loaded = ExchangesLoaded(exchanges: []);
      const error = HomeError(message: 'Error');

      expect(initial.hashCode, isNot(equals(loading.hashCode)));
      expect(loading.hashCode, isNot(equals(loaded.hashCode)));
      expect(loaded.hashCode, isNot(equals(error.hashCode)));
      expect(initial.hashCode, isNot(equals(error.hashCode)));
    });

    test('should not be equal for different state types', () {
      final initial = HomeInitial();
      final loading = HomeLoading();
      final loaded = ExchangesLoaded(exchanges: []);
      const error = HomeError(message: 'Error');

      expect(initial, isNot(equals(loading)));
      expect(loading, isNot(equals(loaded)));
      expect(loaded, isNot(equals(error)));
      expect(initial, isNot(equals(error)));
    });

    test('should be immutable', () {
      final initial1 = HomeInitial();
      final initial2 = HomeInitial();
      final loading1 = HomeLoading();
      final loading2 = HomeLoading();

      expect(initial1, equals(initial2));
      expect(initial1.hashCode, equals(initial2.hashCode));
      expect(loading1, equals(loading2));
      expect(loading1.hashCode, equals(loading2.hashCode));
    });
  });
}
