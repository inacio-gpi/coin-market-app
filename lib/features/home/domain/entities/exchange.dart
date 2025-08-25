import 'package:equatable/equatable.dart';

class Exchange extends Equatable {
  final int id;
  final String name;
  final String slug;
  final int numMarketPairs;
  final List<String> fiats;
  final double trafficScore;
  final int rank;
  final double? exchangeScore;
  final double liquidityScore;
  final DateTime lastUpdated;
  final ExchangeQuote quote;

  const Exchange({
    required this.id,
    required this.name,
    required this.slug,
    required this.numMarketPairs,
    required this.fiats,
    required this.trafficScore,
    required this.rank,
    this.exchangeScore,
    required this.liquidityScore,
    required this.lastUpdated,
    required this.quote,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    numMarketPairs,
    fiats,
    trafficScore,
    rank,
    exchangeScore,
    liquidityScore,
    lastUpdated,
    quote,
  ];
}

class ExchangeQuote extends Equatable {
  final double volume24h;
  final double volume24hAdjusted;
  final double volume7d;
  final double volume30d;
  final double percentChangeVolume24h;
  final double percentChangeVolume7d;
  final double percentChangeVolume30d;
  final double effectiveLiquidity24h;
  final double derivativeVolumeUsd;
  final double spotVolumeUsd;

  const ExchangeQuote({
    required this.volume24h,
    required this.volume24hAdjusted,
    required this.volume7d,
    required this.volume30d,
    required this.percentChangeVolume24h,
    required this.percentChangeVolume7d,
    required this.percentChangeVolume30d,
    required this.effectiveLiquidity24h,
    required this.derivativeVolumeUsd,
    required this.spotVolumeUsd,
  });

  @override
  List<Object?> get props => [
    volume24h,
    volume24hAdjusted,
    volume7d,
    volume30d,
    percentChangeVolume24h,
    percentChangeVolume7d,
    percentChangeVolume30d,
    effectiveLiquidity24h,
    derivativeVolumeUsd,
    spotVolumeUsd,
  ];
}
