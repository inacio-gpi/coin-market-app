import 'package:coin_market_app/features/home/domain/entities/exchange.dart';
import 'package:coin_market_app/features/home/presentation/widgets/exchange_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExchangeListItem', () {
    final mockExchange = Exchange(
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
    );

    Widget createTestWidget() {
      return MaterialApp(
        home: Scaffold(
          body: ExchangeListItem(exchange: mockExchange, onTap: () {}),
        ),
      );
    }

    testWidgets('should display exchange name', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Binance'), findsOneWidget);
    });

    testWidgets('should display exchange rank', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Rank: 1'), findsOneWidget);
    });

    testWidgets('should display volume 24h', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Volume 24h'), findsOneWidget);
      expect(find.textContaining('1,000,000'), findsOneWidget);
    });

    testWidgets('should display spot volume', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Spot Volume'), findsOneWidget);
      expect(find.textContaining('500,000'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExchangeListItem(
              exchange: mockExchange,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ExchangeListItem));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should display all exchange information correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Check all displayed information
      expect(find.text('Binance'), findsOneWidget);
      expect(find.text('Rank: 1'), findsOneWidget);
      expect(find.text('Volume 24h'), findsOneWidget);
      expect(find.text('Spot Volume'), findsOneWidget);
      expect(find.textContaining('1,000,000'), findsOneWidget);
      expect(find.textContaining('500,000'), findsOneWidget);

      // Check that it's a Card with InkWell
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should handle different exchange data', (
      WidgetTester tester,
    ) async {
      final differentExchange = Exchange(
        id: 2,
        name: 'Coinbase',
        slug: 'coinbase',
        numMarketPairs: 500,
        fiats: ['USD'],
        trafficScore: 800.0,
        rank: 2,
        exchangeScore: 85.0,
        liquidityScore: 0.7,
        lastUpdated: DateTime(2025, 1, 2),
        quote: const ExchangeQuote(
          volume24h: 2000000.0,
          volume24hAdjusted: 2000000.0,
          volume7d: 14000000.0,
          volume30d: 60000000.0,
          percentChangeVolume24h: 3.0,
          percentChangeVolume7d: 8.0,
          percentChangeVolume30d: 12.0,
          effectiveLiquidity24h: 0.6,
          derivativeVolumeUsd: 1000000.0,
          spotVolumeUsd: 1000000.0,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExchangeListItem(exchange: differentExchange, onTap: () {}),
          ),
        ),
      );

      expect(find.text('Coinbase'), findsOneWidget);
      expect(find.text('Rank: 2'), findsOneWidget);
      expect(find.text('Volume 24h'), findsOneWidget);
      expect(find.text('Spot Volume'), findsOneWidget);
      expect(find.textContaining('2,000,000'), findsOneWidget);
      expect(find.textContaining('1,000,000'), findsOneWidget);
    });

    testWidgets('should be tappable and show visual feedback', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Find the Card
      final card = find.byType(Card);
      expect(card, findsOneWidget);

      // Find the InkWell
      final inkWell = find.byType(InkWell);
      expect(inkWell, findsOneWidget);

      // Tap the ExchangeListItem
      await tester.tap(find.byType(ExchangeListItem));
      await tester.pump();

      // Should not throw any errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('should display currency exchange icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.currency_exchange), findsOneWidget);
    });

    testWidgets('should display chevron right icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('should display trending up icon for volume 24h', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.trending_up), findsOneWidget);
    });

    testWidgets('should display attach money icon for spot volume', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.attach_money), findsOneWidget);
    });
  });
}
