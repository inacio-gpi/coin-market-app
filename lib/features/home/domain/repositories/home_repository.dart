import 'package:coin_market_app/core/errors/failures.dart';
import 'package:coin_market_app/features/home/domain/entities/exchange.dart';
import 'package:dartz/dartz.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Exchange>>> getAllExchanges();
}
