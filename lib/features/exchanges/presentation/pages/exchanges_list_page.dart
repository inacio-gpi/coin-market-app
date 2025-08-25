import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_bloc.dart';
import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_event.dart';
import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_state.dart';
import 'package:coin_market_app/features/exchanges/presentation/widgets/exchange_asset_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExchangesListPage extends StatefulWidget {
  const ExchangesListPage({super.key});

  @override
  State<ExchangesListPage> createState() => _ExchangesListPageState();
}

class _ExchangesListPageState extends State<ExchangesListPage> {
  static const int _defaultExchangeId = 270; // Default exchange ID

  @override
  void initState() {
    super.initState();
    context.read<ExchangeBloc>().add(
      GetExchangeAssetsEvent(exchangeId: _defaultExchangeId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange Assets'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshAssets(),
            tooltip: 'Refresh (Cache: 5 min)',
          ),
        ],
      ),
      body: BlocBuilder<ExchangeBloc, ExchangeState>(
        builder: (context, state) {
          if (state is ExchangeLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading exchange assets...'),
                ],
              ),
            );
          }

          if (state is ExchangeAssetsLoaded) {
            if (state.assets.isEmpty) {
              return const Center(
                child: Text('No assets found for this exchange.'),
              );
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
                        Icons.cached,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Exchange Assets (ID: $_defaultExchangeId)',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        '${state.assets.length} assets',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.assets.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ExchangeAssetCard(asset: state.assets[index]),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          if (state is ExchangeError) {
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
                    onPressed: _refreshAssets,
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

  void _refreshAssets() {
    context.read<ExchangeBloc>().add(
      RefreshExchangeAssetsEvent(exchangeId: _defaultExchangeId),
    );
  }
}
