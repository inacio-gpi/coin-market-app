import 'package:coin_market_app/core/config/env_config.dart';

abstract class HttpConfig {
  String get baseUrl;
  Map<String, dynamic>? get headers;
  Duration get timeout;
  int get maxRetries;
  Duration get retryDelay;
}

class CoinMarketCapHttpConfig extends HttpConfig {
  @override
  String get baseUrl => 'https://pro-api.coinmarketcap.com';

  @override
  Map<String, dynamic>? get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (EnvConfig.coinMarketCapApiKey != null)
      'X-CMC_PRO_API_KEY': EnvConfig.coinMarketCapApiKey!,
  };

  @override
  Duration get timeout => const Duration(seconds: 30);

  @override
  int get maxRetries => 3;

  @override
  Duration get retryDelay => const Duration(seconds: 2);
}

class DevHttpConfig extends HttpConfig {
  @override
  String get baseUrl => 'https://sandbox-api.coinmarketcap.com';

  @override
  Map<String, dynamic>? get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (EnvConfig.coinMarketCapApiKey != null)
      'X-CMC_PRO_API_KEY': EnvConfig.coinMarketCapApiKey!,
  };

  @override
  Duration get timeout => const Duration(seconds: 15);

  @override
  int get maxRetries => 2;

  @override
  Duration get retryDelay => const Duration(seconds: 1);
}

class HttpConfigFactory {
  static HttpConfig createConfig({bool isProduction = false}) {
    return isProduction ? CoinMarketCapHttpConfig() : DevHttpConfig();
  }

  static HttpConfig createFromEnvironment() {
    return createConfig(isProduction: EnvConfig.isProduction);
  }
}
