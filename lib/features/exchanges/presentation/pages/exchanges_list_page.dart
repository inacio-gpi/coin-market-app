import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_bloc.dart';
import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_event.dart';
import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_state.dart';
import 'package:coin_market_app/features/exchanges/presentation/widgets/exchange_asset_card.dart';
import 'package:coin_market_app/features/exchanges/presentation/widgets/exchange_info_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExchangesListPage extends StatefulWidget {
  final int exchangeId;

  const ExchangesListPage({super.key, required this.exchangeId});

  @override
  State<ExchangesListPage> createState() => _ExchangesListPageState();
}

class _ExchangesListPageState extends State<ExchangesListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExchangeBloc>().add(
      LoadExchangeDetailsEvent(exchangeId: widget.exchangeId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ExchangeBloc, ExchangeState>(
        builder: (context, state) {
          if (state is ExchangeLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading exchange details...'),
                ],
              ),
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
                    onPressed: _refreshData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ExchangeDetailsLoaded) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 320,
                  pinned: true,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  flexibleSpace: FlexibleSpaceBar(
                    background: ExchangeInfoHeader(exchangeInfo: state.info),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _refreshData,
                      tooltip: 'Refresh (Cache: 5 min)',
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Exchange Assets',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                _buildAssetsList(state.assets),
              ],
            );
          }

          return const Center(child: Text('No data available.'));
        },
      ),
    );
  }

  Widget _buildAssetsList(List<dynamic> assets) {
    if (assets.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No assets found for this exchange',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ExchangeAssetCard(asset: assets[index]),
        );
      }, childCount: assets.length),
    );
  }

  void _refreshData() {
    context.read<ExchangeBloc>().add(
      LoadExchangeDetailsEvent(exchangeId: widget.exchangeId),
    );
  }
}
