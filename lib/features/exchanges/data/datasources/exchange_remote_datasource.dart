import 'package:coin_market_app/core/api/api_config.dart';
import 'package:coin_market_app/core/api/custom_http_client.dart';
import 'package:coin_market_app/core/errors/exceptions.dart';
import 'package:coin_market_app/features/exchanges/data/models/exchange_asset_model.dart';
import 'package:coin_market_app/features/exchanges/data/models/exchange_info_model.dart';

abstract class ExchangeRemoteDataSource {
  Future<List<ExchangeAssetModel>> getExchangeAssets(int exchangeId);
  Future<ExchangeInfoModel> getExchangeInfo(int exchangeId);
}

class ExchangeRemoteDataSourceImpl implements ExchangeRemoteDataSource {
  final CustomHttpClient httpClient;

  const ExchangeRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<List<ExchangeAssetModel>> getExchangeAssets(int exchangeId) async {
    try {
      final response = await httpClient.get(
        ApiConfig.exchangeAssetsEndpoint,
        queryParameters: {'id': exchangeId},
      );

      if (response.isSuccess && response.jsonBody != null) {
        final data = response.jsonBody!['data'];
        if (data is List) {
          return data
              .map((json) => ExchangeAssetModel.fromJson(json ?? {}))
              .toList();
        } else if (data is Map) {
          final listData = data['$exchangeId'] as List;
          return listData
              .map((json) => ExchangeAssetModel.fromJson(json ?? {}))
              .toList();
        }
        throw ServerException(message: 'Invalid data format', code: '400');
      } else {
        throw ServerException(
          message: 'Failed to get exchange assets: ${response.statusCode}',
          code: response.statusCode.toString(),
        );
      }
    } catch (e, s) {
      print('Error: $e');
      print('Stack trace: $s');
      if (e is AppException) rethrow;
      throw ServerException(
        message: 'Failed to get exchange assets: $e',
        code: '500',
      );
    }
  }

  @override
  Future<ExchangeInfoModel> getExchangeInfo(int exchangeId) async {
    try {
      final response = await httpClient.get(
        ApiConfig.exchangeInfoEndpoint,
        queryParameters: {'id': exchangeId},
      );

      if (response.isSuccess && response.jsonBody != null) {
        final data = response.jsonBody!['data'];

        if (data is Map && data.containsKey('$exchangeId')) {
          return ExchangeInfoModel.fromJson(data['$exchangeId']);
        }
        throw ServerException(message: 'Exchange not found', code: '404');
      } else {
        print('Failed to get exchange info: ${response.statusCode}');
        throw ServerException(
          message: 'Failed to get exchange info: ${response.statusCode}',
          code: response.statusCode.toString(),
        );
      }
    } catch (e, s) {
      print('Error: $e');
      print('Stack trace: $s');
      if (e is AppException) rethrow;
      throw ServerException(
        message: 'Failed to get exchange info: $e',
        code: '500',
      );
    }
  }
}
