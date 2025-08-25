import 'package:coin_market_app/core/errors/exceptions.dart';
import 'package:coin_market_app/features/exchanges/data/models/exchange_asset_model.dart';
import 'package:hive/hive.dart';

abstract class ExchangeLocalDataSource {
  Future<List<ExchangeAssetModel>?> getCachedExchangeAssets(int exchangeId);
  Future<void> cacheExchangeAssets(
    int exchangeId,
    List<ExchangeAssetModel> assets,
  );
  Future<bool> isDataFresh(int exchangeId);
  Future<void> clearCache(int exchangeId);
}

class ExchangeLocalDataSourceImpl implements ExchangeLocalDataSource {
  static const String _boxName = 'exchange_assets';
  static const String _timestampKey = 'timestamp';
  static const Duration _cacheTtl = Duration(minutes: 5);

  late Box<dynamic> _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  @override
  Future<List<ExchangeAssetModel>?> getCachedExchangeAssets(
    int exchangeId,
  ) async {
    try {
      final key = 'assets_$exchangeId';

      if (!await isDataFresh(exchangeId)) {
        return null;
      }

      final assetsData = _box.get(key) as List<dynamic>?;
      if (assetsData == null) return null;

      return assetsData
          .map((data) => ExchangeAssetModel.fromJson(data ?? {}))
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get cached exchange assets: $e',
        code: '500',
      );
    }
  }

  @override
  Future<void> cacheExchangeAssets(
    int exchangeId,
    List<ExchangeAssetModel> assets,
  ) async {
    try {
      final key = 'assets_$exchangeId';
      final timestampKey = '${key}_$_timestampKey';
      final assetsJson = assets.map((asset) => asset.toJson()).toList();
      await _box.put(key, assetsJson);
      await _box.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache exchange assets: $e',
        code: '500',
      );
    }
  }

  @override
  Future<bool> isDataFresh(int exchangeId) async {
    try {
      final key = 'assets_$exchangeId';
      final timestampKey = '${key}_$_timestampKey';
      final timestamp = _box.get(timestampKey) as int?;

      if (timestamp == null) return false;

      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      return now.difference(cachedTime) < _cacheTtl;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearCache(int exchangeId) async {
    try {
      final key = 'assets_$exchangeId';
      final timestampKey = '${key}_$_timestampKey';

      await _box.delete(key);
      await _box.delete(timestampKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache: $e', code: '500');
    }
  }
}
