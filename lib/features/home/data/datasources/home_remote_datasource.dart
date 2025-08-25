import 'package:coin_market_app/core/api/api_config.dart';
import 'package:coin_market_app/core/api/custom_http_client.dart';
import 'package:coin_market_app/core/errors/exceptions.dart';
import 'package:coin_market_app/features/home/data/models/exchange_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ExchangeModel>> getAllExchanges();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final CustomHttpClient httpClient;

  const HomeRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<List<ExchangeModel>> getAllExchanges() async {
    try {
      final response = await httpClient.get(ApiConfig.exchangeListingsEndpoint);

      if (response.isSuccess && response.jsonBody != null) {
        final data = response.jsonBody!['data'] as List;
        return data.map((json) => ExchangeModel.fromJson(json ?? {})).toList();
      } else {
        throw ServerException(
          message: 'Failed to get all exchanges: ${response.statusCode}',
          code: response.statusCode.toString(),
        );
      }
    } catch (e, s) {
      print('Error: $e');
      print('Stack trace: $s');
      if (e is AppException) rethrow;
      throw ServerException(
        message: 'Failed to get all exchanges: $e',
        code: '500',
      );
    }
  }
}
