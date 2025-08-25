import 'package:coin_market_app/core/utils/formatters.dart';
import 'package:coin_market_app/features/exchanges/domain/entities/exchange_info.dart';
import 'package:flutter/material.dart';

class ExchangeInfoHeader extends StatelessWidget {
  final ExchangeInfo exchangeInfo;

  const ExchangeInfoHeader({super.key, required this.exchangeInfo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [theme.colorScheme.inversePrimary, theme.colorScheme.surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo and Name Row
          Row(
            children: [
              // Logo placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.currency_exchange,
                  color: theme.colorScheme.onPrimary,
                  size: 40,
                ),
              ),
              const SizedBox(width: 20),

              // Exchange details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exchangeInfo.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ID: ${exchangeInfo.id}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer.withOpacity(
                          0.8,
                        ),
                      ),
                    ),
                    if (exchangeInfo.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        exchangeInfo.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer
                              .withOpacity(0.9),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Maker Fee',
                  '${(exchangeInfo.makerFee * 100).toStringAsFixed(2)}%',
                  Icons.trending_down,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Taker Fee',
                  '${(exchangeInfo.takerFee * 100).toStringAsFixed(2)}%',
                  Icons.trending_up,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Weekly Visits',
                  Formatters.formatNumber(exchangeInfo.weeklyVisits.toDouble()),
                  Icons.people,
                  Colors.blue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Website and Launch Date
          Row(
            children: [
              if (exchangeInfo.urls.website.isNotEmpty) ...[
                Expanded(
                  child: _buildInfoRow(
                    context,
                    'Website',
                    exchangeInfo.urls.website.first,
                    Icons.language,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: _buildInfoRow(
                  context,
                  'Launched',
                  _formatDate(exchangeInfo.dateLaunched),
                  Icons.calendar_today,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
