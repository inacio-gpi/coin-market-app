import 'package:equatable/equatable.dart';

class ExchangeAsset extends Equatable {
  final String walletAddress;
  final double balance;
  final Platform platform;
  final Currency currency;

  const ExchangeAsset({
    required this.walletAddress,
    required this.balance,
    required this.platform,
    required this.currency,
  });

  @override
  List<Object?> get props => [walletAddress, balance, platform, currency];
}

class Platform extends Equatable {
  final int cryptoId;
  final String symbol;
  final String name;

  const Platform({
    required this.cryptoId,
    required this.symbol,
    required this.name,
  });

  @override
  List<Object?> get props => [cryptoId, symbol, name];
}

class Currency extends Equatable {
  final int cryptoId;
  final double priceUsd;
  final String symbol;
  final String name;

  const Currency({
    required this.cryptoId,
    required this.priceUsd,
    required this.symbol,
    required this.name,
  });

  @override
  List<Object?> get props => [cryptoId, priceUsd, symbol, name];
}
