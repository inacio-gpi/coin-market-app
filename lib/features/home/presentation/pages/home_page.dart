import 'package:coin_market_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:coin_market_app/features/home/presentation/bloc/home_event.dart';
import 'package:coin_market_app/features/home/presentation/bloc/home_state.dart';
import 'package:coin_market_app/features/home/presentation/widgets/exchange_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const GetAllExchangesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Market App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshExchanges(),
            tooltip: 'Refresh exchanges',
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading exchanges...'),
                ],
              ),
            );
          }

          if (state is ExchangesLoaded) {
            if (state.exchanges.isEmpty) {
              return const Center(child: Text('No exchanges found.'));
            }

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Row(
                    children: [
                      Icon(
                        Icons.currency_exchange,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Available Exchanges',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        '${state.exchanges.length} exchanges',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.exchanges.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ExchangeListItem(
                          exchange: state.exchanges[index],
                          onTap: () => _navigateToExchangeDetails(
                            state.exchanges[index].id,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshExchanges,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('No data available.'));
        },
      ),
    );
  }

  void _refreshExchanges() {
    context.read<HomeBloc>().add(const GetAllExchangesEvent());
  }

  void _navigateToExchangeDetails(int exchangeId) {
    Navigator.pushNamed(context, '/exchange-details', arguments: exchangeId);
  }
}
