import 'package:coin_market_app/features/home/domain/entities/exchange.dart';

class ExchangeModel extends Exchange {
  const ExchangeModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.numMarketPairs,
    required super.fiats,
    required super.trafficScore,
    required super.rank,
    super.exchangeScore,
    required super.liquidityScore,
    required super.lastUpdated,
    required super.quote,
  });

  factory ExchangeModel.fromJson(Map<String, dynamic> json) {
    return ExchangeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      numMarketPairs: json['num_market_pairs'] ?? 0,
      fiats: List<String>.from(json['fiats'] ?? []),
      trafficScore: (json['traffic_score'] as num?)?.toDouble() ?? 0.0,
      rank: json['rank'] ?? 0,
      exchangeScore: (json['exchange_score'] as num?)?.toDouble(),
      liquidityScore: (json['liquidity_score'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: DateTime.parse(
        json['last_updated'] ?? DateTime.now().toIso8601String(),
      ),
      quote: ExchangeQuoteModel.fromJson(json['quote'] ?? {}),
    );
  }

  Exchange toEntity() => this;
}

class ExchangeQuoteModel extends ExchangeQuote {
  const ExchangeQuoteModel({
    required super.volume24h,
    required super.volume24hAdjusted,
    required super.volume7d,
    required super.volume30d,
    required super.percentChangeVolume24h,
    required super.percentChangeVolume7d,
    required super.percentChangeVolume30d,
    required super.effectiveLiquidity24h,
    required super.derivativeVolumeUsd,
    required super.spotVolumeUsd,
  });

  factory ExchangeQuoteModel.fromJson(Map<String, dynamic> json) {
    final usdQuote = json['USD'] ?? {};

    return ExchangeQuoteModel(
      volume24h: (usdQuote['volume_24h'] as num?)?.toDouble() ?? 0.0,
      volume24hAdjusted:
          (usdQuote['volume_24h_adjusted'] as num?)?.toDouble() ?? 0.0,
      volume7d: (usdQuote['volume_7d'] as num?)?.toDouble() ?? 0.0,
      volume30d: (usdQuote['volume_30d'] as num?)?.toDouble() ?? 0.0,
      percentChangeVolume24h:
          (usdQuote['percent_change_volume_24h'] as num?)?.toDouble() ?? 0.0,
      percentChangeVolume7d:
          (usdQuote['percent_change_volume_7d'] as num?)?.toDouble() ?? 0.0,
      percentChangeVolume30d:
          (usdQuote['percent_change_volume_30d'] as num?)?.toDouble() ?? 0.0,
      effectiveLiquidity24h:
          (usdQuote['effective_liquidity_24h'] as num?)?.toDouble() ?? 0.0,
      derivativeVolumeUsd:
          (usdQuote['derivative_volume_usd'] as num?)?.toDouble() ?? 0.0,
      spotVolumeUsd: (usdQuote['spot_volume_usd'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
