import 'package:coin_market_app/core/config/env_config.dart';
import 'package:coin_market_app/core/injection/injection_container.dart';
import 'package:coin_market_app/core/routes/app_router.dart';
import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_bloc.dart';
import 'package:coin_market_app/features/home/presentation/bloc/home_bloc.dart';
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
        BlocProvider<HomeBloc>(create: (context) => getIt<HomeBloc>()),
        BlocProvider<ExchangeBloc>(create: (context) => getIt<ExchangeBloc>()),
      ],
      child: MaterialApp(
        title: 'Coin Market App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: AppRouter.home,
        onGenerateRoute: AppRouter.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
