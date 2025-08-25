import 'package:coin_market_app/core/api/api_config.dart';
import 'package:coin_market_app/core/api/custom_http_client.dart';
import 'package:coin_market_app/core/errors/exceptions.dart';
import 'package:coin_market_app/features/exchanges/data/models/exchange_asset_model.dart';

abstract class ExchangeRemoteDataSource {
  Future<List<ExchangeAssetModel>> getExchangeAssets(int exchangeId);
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
        final data = response.jsonBody!['data'] as List;
        return data
            .map((json) => ExchangeAssetModel.fromJson(json ?? {}))
            .toList();
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
}
