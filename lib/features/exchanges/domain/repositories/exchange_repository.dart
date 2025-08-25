import 'package:coin_market_app/core/errors/failures.dart';
import 'package:coin_market_app/features/exchanges/domain/entities/exchange_asset.dart';
import 'package:coin_market_app/features/exchanges/domain/entities/exchange_info.dart';
import 'package:dartz/dartz.dart';

abstract class ExchangeRepository {
  Future<Either<Failure, List<ExchangeAsset>>> getExchangeAssets(
    int exchangeId,
  );

  Future<Either<Failure, ExchangeInfo>> getExchangeInfo(int exchangeId);
}
