import 'package:coin_market_app/core/errors/failures.dart';
import 'package:coin_market_app/features/home/domain/entities/exchange.dart';
import 'package:coin_market_app/features/home/domain/usecases/get_all_exchanges.dart';
import 'package:coin_market_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:coin_market_app/features/home/presentation/pages/home_page.dart';
import 'package:coin_market_app/features/home/presentation/widgets/exchange_list_item.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_page_test.mocks.dart';

@GenerateMocks([GetAllExchanges])
void main() {
  group('HomePage', () {
    late MockGetAllExchanges mockGetAllExchanges;
    late HomeBloc homeBloc;

    final mockExchanges = [
      Exchange(
        id: 1,
        name: 'Binance',
        slug: 'binance',
        numMarketPairs: 1000,
        fiats: ['USD', 'EUR'],
        trafficScore: 1000.0,
        rank: 1,
        exchangeScore: 95.0,
        liquidityScore: 0.9,
        lastUpdated: DateTime(2025, 1, 1),
        quote: const ExchangeQuote(
          volume24h: 1000000.0,
          volume24hAdjusted: 1000000.0,
          volume7d: 7000000.0,
          volume30d: 30000000.0,
          percentChangeVolume24h: 5.0,
          percentChangeVolume7d: 10.0,
          percentChangeVolume30d: 15.0,
          effectiveLiquidity24h: 0.8,
          derivativeVolumeUsd: 500000.0,
          spotVolumeUsd: 500000.0,
        ),
      ),
    ];

    final mockLargeExchanges = List.generate(
      20,
      (index) => Exchange(
        id: index + 1,
        name: 'Exchange ${index + 1}',
        slug: 'exchange_${index + 1}',
        numMarketPairs: 100 + index,
        fiats: ['USD', 'EUR'],
        trafficScore: 100.0 + index,
        rank: index + 1,
        exchangeScore: 90.0 + index,
        liquidityScore: 0.8 + (index * 0.01),
        lastUpdated: DateTime(2025, 1, 1),
        quote: ExchangeQuote(
          volume24h: 1000000.0 + (index * 100000),
          volume24hAdjusted: 1000000.0 + (index * 100000),
          volume7d: 7000000.0 + (index * 700000),
          volume30d: 30000000.0 + (index * 3000000),
          percentChangeVolume24h: 5.0 + index,
          percentChangeVolume7d: 10.0 + index,
          percentChangeVolume30d: 15.0 + index,
          effectiveLiquidity24h: 0.8 + (index * 0.01),
          derivativeVolumeUsd: 500000.0 + (index * 50000),
          spotVolumeUsd: 500000.0 + (index * 50000),
        ),
      ),
    );

    Widget createTestWidget() {
      return MaterialApp(
        routes: {
          '/exchange-details': (context) => const Scaffold(
            body: Center(child: Text('Exchange Details Page')),
          ),
        },
        home: BlocProvider<HomeBloc>(
          create: (context) => homeBloc,
          child: const HomePage(),
        ),
      );
    }

    testWidgets('should display app bar with title', (
      WidgetTester tester,
    ) async {
      mockGetAllExchanges = MockGetAllExchanges();
      when(mockGetAllExchanges(null)).thenAnswer((_) async => const Right([]));
      homeBloc = HomeBloc(getAllExchanges: mockGetAllExchanges);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Coin Market App'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);

      homeBloc.close();
    });

    testWidgets('should display refresh button in app bar', (
      WidgetTester tester,
    ) async {
      mockGetAllExchanges = MockGetAllExchanges();
      when(mockGetAllExchanges(null)).thenAnswer((_) async => const Right([]));
      homeBloc = HomeBloc(getAllExchanges: mockGetAllExchanges);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.refresh), findsOneWidget);

      homeBloc.close();
    });

    testWidgets('should display empty state when no exchanges', (
      WidgetTester tester,
    ) async {
      mockGetAllExchanges = MockGetAllExchanges();
      when(mockGetAllExchanges(null)).thenAnswer((_) async => const Right([]));
      homeBloc = HomeBloc(getAllExchanges: mockGetAllExchanges);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('No exchanges found.'), findsOneWidget);

      homeBloc.close();
    });

    testWidgets('should display exchanges list when data is loaded', (
      WidgetTester tester,
    ) async {
      mockGetAllExchanges = MockGetAllExchanges();
      when(
        mockGetAllExchanges(null),
      ).thenAnswer((_) async => Right(mockExchanges));
      homeBloc = HomeBloc(getAllExchanges: mockGetAllExchanges);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Binance'), findsOneWidget);
      expect(find.byType(ExchangeListItem), findsNWidgets(1));
      expect(find.text('Available Exchanges'), findsOneWidget);
      expect(find.text('1 exchanges'), findsOneWidget);

      homeBloc.close();
    });

    testWidgets('should display large exchanges list correctly', (
      WidgetTester tester,
    ) async {
      mockGetAllExchanges = MockGetAllExchanges();
      when(
        mockGetAllExchanges(null),
      ).thenAnswer((_) async => Right(mockLargeExchanges));
      homeBloc = HomeBloc(getAllExchanges: mockGetAllExchanges);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Available Exchanges'), findsOneWidget);
      expect(find.text('20 exchanges'), findsOneWidget);
      expect(find.text('Exchange 1'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);

      homeBloc.close();
    });

    testWidgets('should display error state when API fails', (
      WidgetTester tester,
    ) async {
      mockGetAllExchanges = MockGetAllExchanges();
      when(
        mockGetAllExchanges(null),
      ).thenAnswer((_) async => Left(ServerFailure(message: 'Server error')));
      homeBloc = HomeBloc(getAllExchanges: mockGetAllExchanges);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Error: Server error'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      homeBloc.close();
    });

    testWidgets('should call refresh when refresh button is tapped', (
      WidgetTester tester,
    ) async {
      mockGetAllExchanges = MockGetAllExchanges();
      when(mockGetAllExchanges(null)).thenAnswer((_) async => const Right([]));
      homeBloc = HomeBloc(getAllExchanges: mockGetAllExchanges);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();

      verify(mockGetAllExchanges(null)).called(greaterThan(1));

      homeBloc.close();
    });

    testWidgets('should call refresh when retry button is tapped', (
      WidgetTester tester,
    ) async {
      mockGetAllExchanges = MockGetAllExchanges();
      when(
        mockGetAllExchanges(null),
      ).thenAnswer((_) async => Left(ServerFailure(message: 'Server error')));
      homeBloc = HomeBloc(getAllExchanges: mockGetAllExchanges);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Retry'));
      await tester.pump();

      verify(mockGetAllExchanges(null)).called(greaterThan(1));

      homeBloc.close();
    });

    testWidgets('should navigate to exchange details when exchange is tapped', (
      WidgetTester tester,
    ) async {
      mockGetAllExchanges = MockGetAllExchanges();
      when(
        mockGetAllExchanges(null),
      ).thenAnswer((_) async => Right(mockExchanges));
      homeBloc = HomeBloc(getAllExchanges: mockGetAllExchanges);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on the first exchange
      await tester.tap(find.byType(ExchangeListItem).first);
      await tester.pumpAndSettle();

      // Should navigate to exchange details page
      expect(find.text('Exchange Details Page'), findsOneWidget);

      homeBloc.close();
    });

    testWidgets('should display exchange details correctly', (
      WidgetTester tester,
    ) async {
      mockGetAllExchanges = MockGetAllExchanges();
      when(
        mockGetAllExchanges(null),
      ).thenAnswer((_) async => Right(mockExchanges));
      homeBloc = HomeBloc(getAllExchanges: mockGetAllExchanges);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check header information
      expect(find.text('Available Exchanges'), findsOneWidget);
      expect(find.text('1 exchanges'), findsOneWidget);

      // Check exchange item
      expect(find.text('Binance'), findsOneWidget);
      expect(find.byType(ExchangeListItem), findsOneWidget);

      homeBloc.close();
    });

    testWidgets('should handle multiple refresh calls', (
      WidgetTester tester,
    ) async {
      mockGetAllExchanges = MockGetAllExchanges();
      when(mockGetAllExchanges(null)).thenAnswer((_) async => const Right([]));
      homeBloc = HomeBloc(getAllExchanges: mockGetAllExchanges);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap refresh multiple times
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();

      // Should be called multiple times
      verify(
        mockGetAllExchanges(null),
      ).called(4); // 1 from initState + 3 from taps

      homeBloc.close();
    });
  });
}
