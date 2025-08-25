import 'package:coin_market_app/features/exchanges/presentation/pages/exchanges_list_page.dart';
import 'package:coin_market_app/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String home = '/';
  static const String exchangeDetails = '/exchange-details';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );

      case exchangeDetails:
        final exchangeId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ExchangesListPage(exchangeId: exchangeId),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found!'))),
        );
    }
  }
}
