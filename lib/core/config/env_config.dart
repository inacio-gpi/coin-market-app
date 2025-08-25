class EnvConfig {
  static String? _coinMarketCapApiKey;

  static bool _isProduction = false;
  static bool _enableLogging = true;
  static bool _enableCache = true;

  static Future<void> initialize() async {
    _coinMarketCapApiKey = const String.fromEnvironment(
      'COINMARKETCAP_API_KEY',
    );
    _isProduction = const bool.fromEnvironment(
      'IS_PRODUCTION',
      defaultValue: false,
    );
    _enableLogging = const bool.fromEnvironment(
      'ENABLE_LOGGING',
      defaultValue: true,
    );
    _enableCache = const bool.fromEnvironment(
      'ENABLE_CACHE',
      defaultValue: true,
    );
  }

  static String? get coinMarketCapApiKey => _coinMarketCapApiKey;

  static bool get isProduction => _isProduction;

  static bool get enableLogging => _enableLogging;

  static bool get enableCache => _enableCache;

  static bool get isValid {
    return _coinMarketCapApiKey != null && _coinMarketCapApiKey!.isNotEmpty;
  }

  static Map<String, dynamic> get summary {
    return {
      'hasApiKey':
          _coinMarketCapApiKey != null && _coinMarketCapApiKey!.isNotEmpty,
      'isProduction': _isProduction,
      'enableLogging': _enableLogging,
      'enableCache': _enableCache,
    };
  }
}
