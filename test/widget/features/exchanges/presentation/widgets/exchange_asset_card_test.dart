import 'package:coin_market_app/features/exchanges/domain/entities/exchange_asset.dart';
import 'package:coin_market_app/features/exchanges/presentation/widgets/exchange_asset_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExchangeAssetCard', () {
    final mockExchangeAsset = ExchangeAsset(
      walletAddress: '0x1234567890abcdef',
      balance: 100.5,
      platform: const Platform(cryptoId: 1, name: 'Ethereum', symbol: 'ETH'),
      currency: const Currency(
        cryptoId: 1,
        name: 'Ethereum',
        symbol: 'ETH',
        priceUsd: 2500.0,
      ),
    );

    Widget createTestWidget() {
      return MaterialApp(
        home: Scaffold(body: ExchangeAssetCard(asset: mockExchangeAsset)),
      );
    }

    testWidgets('should display currency name', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Ethereum'), findsNWidgets(2)); // Platform + Currency
    });

    testWidgets('should display currency symbol', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('ETH'), findsNWidgets(2)); // Platform + Currency
    });

    testWidgets('should display platform name', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Ethereum'), findsNWidgets(2)); // Platform + Currency
    });

    testWidgets('should display balance', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Formatters.formatNumber(100.5) returns "101" with NumberFormat.compact
      expect(find.textContaining('101'), findsOneWidget);
    });

    testWidgets('should display price USD', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Formatters.formatCurrency(2500.0) returns "$2,500.00"
      expect(find.textContaining('2,500.00'), findsOneWidget);
    });

    testWidgets('should display wallet address', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.textContaining('0x1234567890abcdef'), findsOneWidget);
    });

    testWidgets('should display total value', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Total value = balance * price = 100.5 * 2500 = 251,250
      // Formatters.formatCurrency(251250) returns "$251,250.00"
      expect(find.textContaining('251,250.00'), findsOneWidget);
    });

    testWidgets('should display all asset information correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Check all displayed information
      expect(find.text('Ethereum'), findsNWidgets(2)); // Platform + Currency
      expect(find.text('ETH'), findsNWidgets(2)); // Platform + Currency
      expect(find.textContaining('101'), findsOneWidget);
      expect(find.textContaining('2,500.00'), findsOneWidget);
      expect(find.textContaining('0x1234567890abcdef'), findsOneWidget);
      expect(find.textContaining('251,250.00'), findsOneWidget);

      // Check that it's a Card
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should handle different asset data', (
      WidgetTester tester,
    ) async {
      final differentAsset = ExchangeAsset(
        walletAddress: '0xabcdef1234567890',
        balance: 50.25,
        platform: const Platform(cryptoId: 2, name: 'Bitcoin', symbol: 'BTC'),
        currency: const Currency(
          cryptoId: 2,
          name: 'Bitcoin',
          symbol: 'BTC',
          priceUsd: 45000.0,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ExchangeAssetCard(asset: differentAsset)),
        ),
      );

      expect(find.text('Bitcoin'), findsNWidgets(2)); // Platform + Currency
      expect(find.text('BTC'), findsNWidgets(2)); // Platform + Currency
      // Formatters.formatNumber(50.25) returns "50.3" with NumberFormat.compact
      expect(find.textContaining('50.3 BTC'), findsOneWidget);
      expect(find.textContaining('45,000.00'), findsOneWidget);
      expect(find.textContaining('0xabcdef1234567890'), findsOneWidget);
      // Total value = 50.25 * 45000 = 2,261,250
      expect(find.textContaining('2,261,250.00'), findsOneWidget);
    });

    testWidgets('should display wallet icon', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
    });

    testWidgets('should display computer icon for platform', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.computer), findsOneWidget);
    });

    testWidgets('should display currency exchange icon for currency', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.currency_exchange), findsOneWidget);
    });

    testWidgets('should display attach money icon for total value', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.attach_money), findsOneWidget);
    });

    testWidgets('should handle zero balance', (WidgetTester tester) async {
      final zeroBalanceAsset = ExchangeAsset(
        walletAddress: '0x1234567890abcdef',
        balance: 0.0,
        platform: const Platform(cryptoId: 1, name: 'Ethereum', symbol: 'ETH'),
        currency: const Currency(
          cryptoId: 1,
          name: 'Ethereum',
          symbol: 'ETH',
          priceUsd: 2500.0,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ExchangeAssetCard(asset: zeroBalanceAsset)),
        ),
      );

      // Formatters.formatNumber(0.0) returns "0" and it's displayed as "0 ETH"
      expect(find.text('0 ETH'), findsOneWidget);
      // Total value = 0.0 * 2500 = 0, displayed as "$0.00"
      expect(find.text('\$0.00'), findsOneWidget);
    });

    testWidgets('should handle very large numbers', (
      WidgetTester tester,
    ) async {
      final largeNumberAsset = ExchangeAsset(
        walletAddress: '0x1234567890abcdef',
        balance: 999999999.99,
        platform: const Platform(cryptoId: 1, name: 'Ethereum', symbol: 'ETH'),
        currency: const Currency(
          cryptoId: 1,
          name: 'Ethereum',
          symbol: 'ETH',
          priceUsd: 999999999.99,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ExchangeAssetCard(asset: largeNumberAsset)),
        ),
      );

      // Formatters.formatNumber(999999999.99) returns "1B" with NumberFormat.compact
      expect(find.textContaining('1B'), findsOneWidget); // Balance
      // Formatters.formatCurrency(999999999.99) returns "$999,999,999.99"
      expect(find.textContaining('999,999,999.99'), findsOneWidget); // Price
    });

    testWidgets('should display platform and currency sections', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Platform'), findsOneWidget);
      expect(find.text('Currency'), findsOneWidget);
    });

    testWidgets('should display balance and price labels', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Balance'), findsOneWidget);
      expect(find.text('Price (USD)'), findsOneWidget);
    });

    testWidgets('should display total value label', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Total Value'), findsOneWidget);
    });
  });
}
