import 'package:coin_market_app/core/config/env_config.dart';
import 'package:coin_market_app/core/injection/injection_container.dart';
import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_bloc.dart';
import 'package:coin_market_app/features/exchanges/presentation/pages/exchanges_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([EnvConfig.initialize(), Hive.initFlutter()]);

  await init();

  runApp(const CoinMarketApp());
}

class CoinMarketApp extends StatelessWidget {
  const CoinMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExchangeBloc>(create: (context) => getIt<ExchangeBloc>()),
      ],
      child: MaterialApp(
        title: 'Coin Market App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const ExchangesListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
