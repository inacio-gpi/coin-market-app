import 'package:coin_market_app/features/exchanges/domain/entities/exchange_asset.dart';

class ExchangeAssetModel extends ExchangeAsset {
  const ExchangeAssetModel({
    required super.walletAddress,
    required super.balance,
    required super.platform,
    required super.currency,
  });

  factory ExchangeAssetModel.fromJson(Map<String, dynamic> json) {
    return ExchangeAssetModel(
      walletAddress: json['wallet_address'] ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      platform: PlatformModel.fromJson(json['platform'] ?? {}),
      currency: CurrencyModel.fromJson(json['currency'] ?? {}),
    );
  }

  ExchangeAsset toEntity() => this;

  Map<String, dynamic> toJson() {
    return {
      'wallet_address': walletAddress,
      'balance': balance,
      'platform': (platform as PlatformModel).toJson(),
      'currency': (currency as CurrencyModel).toJson(),
    };
  }
}

class PlatformModel extends Platform {
  const PlatformModel({
    required super.cryptoId,
    required super.symbol,
    required super.name,
  });

  factory PlatformModel.fromJson(Map<String, dynamic> json) {
    return PlatformModel(
      cryptoId: json['crypto_id'] ?? 0,
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'crypto_id': cryptoId, 'symbol': symbol, 'name': name};
  }
}

class CurrencyModel extends Currency {
  const CurrencyModel({
    required super.cryptoId,
    required super.priceUsd,
    required super.symbol,
    required super.name,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      cryptoId: json['crypto_id'] ?? 0,
      priceUsd: (json['price_usd'] as num?)?.toDouble() ?? 0,
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crypto_id': cryptoId,
      'price_usd': priceUsd,
      'symbol': symbol,
      'name': name,
    };
  }
}
