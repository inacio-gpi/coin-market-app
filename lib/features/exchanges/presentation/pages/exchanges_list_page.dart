import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_bloc.dart';
import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_event.dart';
import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_state.dart';
import 'package:coin_market_app/features/exchanges/presentation/widgets/exchange_asset_card.dart';
import 'package:coin_market_app/features/exchanges/presentation/widgets/exchange_info_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      body: SafeArea(
        child: BlocBuilder<ExchangeBloc, ExchangeState>(
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _goBack,
                      child: const Text('Voltar'),
                    ),
                  ],
                ),
              );
            }

            if (state is ExchangeDetailsLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Theme.of(
                        context,
                      ).colorScheme.inversePrimary,
                    ),

                    expandedHeight: 400,
                    pinned: true,
                    floating: false,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.inversePrimary,
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ExchangeInfoHeader(exchangeInfo: state.info),
                      centerTitle: true,
                      title: Text(
                        '${state.info.name} Assets',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 3.0,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                      titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _refreshData,
                        tooltip: 'Refresh (Cache: 5 min)',
                      ),
                    ],
                  ),

                  // Seção de Assets com design melhorado
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Exchange Assets',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${state.assets.length} assets',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Lista de assets
                  _buildAssetsList(state.assets),
                ],
              );
            }

            return const Center(child: Text('No data available.'));
          },
        ),
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

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ExchangeAssetCard(asset: assets[index]),
          );
        }, childCount: assets.length),
      ),
    );
  }

  void _refreshData() {
    context.read<ExchangeBloc>().add(
      LoadExchangeDetailsEvent(exchangeId: widget.exchangeId),
    );
  }

  void _goBack() {
    Navigator.pop(context);
  }
}
