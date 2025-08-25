import 'package:coin_market_app/core/errors/failures.dart';
import 'package:coin_market_app/core/usecase/usecase.dart';
import 'package:coin_market_app/features/exchanges/domain/entities/exchange_asset.dart';
import 'package:coin_market_app/features/exchanges/domain/repositories/exchange_repository.dart';
import 'package:dartz/dartz.dart';

class GetExchangeAssets implements UseCase<List<ExchangeAsset>, int> {
  final ExchangeRepository repository;

  const GetExchangeAssets(this.repository);

  @override
  Future<Either<Failure, List<ExchangeAsset>>> call(int exchangeId) async {
    return await repository.getExchangeAssets(exchangeId);
  }
}
