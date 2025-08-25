import 'package:coin_market_app/core/errors/failures.dart';
import 'package:coin_market_app/core/usecase/usecase.dart';
import 'package:coin_market_app/features/exchanges/domain/entities/exchange_info.dart';
import 'package:coin_market_app/features/exchanges/domain/repositories/exchange_repository.dart';
import 'package:dartz/dartz.dart';

class GetExchangeInfo implements UseCase<ExchangeInfo, int> {
  final ExchangeRepository repository;

  const GetExchangeInfo(this.repository);

  @override
  Future<Either<Failure, ExchangeInfo>> call(int exchangeId) async {
    return await repository.getExchangeInfo(exchangeId);
  }
}
